function [H, condA, resnorm, residual, exitflag, output] = estimate_homography(imagePoints1, imagePoints2, imageLines1, imageLines2, endpointsLines1, normalization_type)

% nPoints = size(imagePoints1, 1);
% nLines = size(imageLines1, 1);
if ~isempty(imagePoints1) && ~isempty(imagePoints2)
    IP1 = imagePoints1 ./ imagePoints1(:, 3);
    IP2 = imagePoints2 ./ imagePoints2(:, 3);
else
    IP1 = [];
    IP2 = [];
end
LP1 = imageLines1;
LP2 = imageLines2;

% Normalization
switch normalization_type
    case "point"
        % Points
        [IP1, s1, tx1, ty1] = normalization_points(IP1);
        [IP2, s2, tx2, ty2] = normalization_points(IP2);
        
        % Lines
        if ~isempty(LP1) && ~isempty(LP2)
            LP1 = LP1 * [s1, 0, -s1*tx1;...
                         0, s1, -s1*ty1;...
                         0, 0, -s1^2];
            LP2 = LP2 * [s2, 0, -s2*tx2;...
                         0, s2, -s2*ty2;...
                         0, 0, -s2^2];
        end
        
    case "line"
        % Lines
        [LP1, ta1, tb1, tc1, s1] = normalization_lines(LP1);       
        [LP2, ta2, tb2, tc2, s2] = normalization_lines(LP2);
        
        % Points
        if ~isempty(IP1) && ~isempty(IP2)
            IP1 = IP1 * [s1^2, 0, s1*ta1/tc1;...
                         0, s1^2, s1*tb1/tc1;...
                         0, 0, s1];
            IP2 = IP2 * [s2^2, 0, s2*ta2/tc2;...
                         0, s2^2, s2*tb2/tc2;...
                         0, 0, s2];
        end
end

A = [design_matrix_points(IP1, IP2);...
     design_matrix_lines(LP1, LP2)];

condA = cond(A);
[~, ~, V] = svd(A);
h0 = V(:, end);
 
% Non-linear optimization
lb = -Inf(size(h0));
ub = Inf(size(h0));
switch normalization_type
    case "point"
        options = optimoptions("lsqcurvefit", SpecifyObjectiveGradient=true, CheckGradients=true); % COMPUTE JAC
        val_fun = @(x, xdata) image2imageP(x, xdata);
        imageData = IP2(:, 1:2) ./ IP2(:, 3);
        imageData = imageData';
        [h, resnorm, residual, exitflag, output] = lsqcurvefit(...
            val_fun, h0, IP1, imageData(:), lb, ub, options);
    case "line"
%         EP1 = IP1(endpointsLines1(:, 1), :);
%         EP2 = IP1(endpointsLines1(:, 2), :);
%         linesData = [EP1, EP2, imageLines2];
%         val_fun = @(x) residual_area(x, linesData);
%         [h, resnorm, residual, exitflag, output] = fminunc(val_fun, h0);
        warning("Non linear optimization inactive for line homographies")
        resnorm = 0; residual = 0; exitflag = 0; output = 0;
        h = h0;

end

H = reshape(h, 3, 3);

 % Remove normalization effects
 switch normalization_type
     case "point"
         norm_mat1 = [s1, 0, tx1;...
                      0, s1, ty1;...
                      0, 0, 1];
         norm_mat2 = [s2, 0, tx2;...
                      0, s2, ty2;...
                      0, 0, 1];
                  
          H = norm_mat2 \ (H*norm_mat1);
          
     case "line"
         norm_mat1 = [1, 0, -ta1/tc1;...
                      0, 1, -tb1/tc1;...
                      0, 0, s1];
         norm_mat2 = [1, 0, -ta2/tc2;...
                      0, 1, -tb2/tc2;...
                      0, 0, s2];
                  
         H = norm_mat1 \ (H'*norm_mat2);
         H = H';
 end

    function A = design_matrix_points(IP1, IP2)
        if ~isempty(IP1)
            % Explicit
            n = size(IP1, 1);
            A = zeros(2*n, 9);
            for i=1:n
                x1 = IP1(i, 1); y1 = IP1(i, 2); w1 = IP1(i, 3);
                x2 = IP2(i, 1); y2 = IP2(i, 2); w2 = IP2(i, 3);
                A(1+2*(i-1):2*i, :) = ...
                    [x1*w2,     0, -x1*x2,  y1*w2,     0, -y1*x2, w1*w2,     0, -w1*x2;...
                         0, x1*w2, -x1*y2,      0, y1*w2, -y1*y2,     0, w1*w2, -w1*y2];
            end
        else
            A = [];
        end
    end

    function A = design_matrix_lines(LP1, LP2)
        if ~isempty(LP1)
            % Explicit
            n = size(LP1, 1);
            A = zeros(2*n, 9);
            for i=1:n
                a1 = LP1(i, 1); b1 = LP1(i, 2); c1 = LP1(i, 3);
                a2 = LP2(i, 1); b2 = LP2(i, 2); c2 = LP2(i, 3);
                A(1+2*(i-1):2*i, :) = ...
                    [a2*c1, b2*c1, c2*c1,     0,     0,     0, -a2*a1, -b2*a1, -c2*a1;...
                         0,     0,     0, a2*c1, b2*c1, c2*c1, -a2*b1, -b2*b1, -c2*b1];
            end
        else
            A = [];
        end
    end

    function [norm_points, s, tx, ty] = normalization_points(points)
    n = size(points, 1);
    point_bar = mean(points);
    sigma = sum((points-point_bar).^2, 'all') / n;
    s = sqrt(2 / sigma);
    tx = -s*point_bar(1);
    ty = -s*point_bar(2);
    norm_points = points * [s, 0, 0;...
                            0, s, 0;...
                            tx, ty, 1];
    end

    function [norm_lines, ta, tb, tc, s] = normalization_lines(lines)
        t = sum(lines, 1);
        ta = t(1);
        tb = t(2);
        tc = t(3);
        tlines = lines * [1, 0, 0;...
                          0, 1, 0;...
                         -ta/tc, -tb/tc, 1];
        l = tlines.^2;
        s = sqrt(sum(l(:, 1:2), 'all') / (2*sum(l(:, 3))));
        norm_lines = tlines * [1, 0, 0;...
                               0, 1, 0;...
                               0, 0, s];
    end

    function [imagePointsHat, J] = image2imageP(h, imagePoints)
    h = [h(1), h(4), h(7);...
         h(2), h(5), h(8);...
         h(3), h(6), h(9)];

     imagePointsHat = h * imagePoints';
     imagePointsHat = imagePointsHat(1:2, :) ./ imagePointsHat(3, :);
     imagePointsHat = imagePointsHat(:);

     if nargout > 1
         % Jacobian
         nPoints = size(imagePoints, 1);
         J = zeros(2*nPoints, 9); % CHECK JAC COMPUTATION
         for j=1:nPoints
             xI = imagePoints(j, 1);
             yI = imagePoints(j, 2);
             wI = imagePoints(j, 3);
             U1 = h(1, :) * [xI; yI; wI];
             U2 = h(2, :) * [xI; yI; wI];
             D = h(3, :) * [xI; yI; 1];
             J(1+2*(j-1):2*j, :) = [xI/D, 0, -xI*U1/D^2, yI/D, 0, -yI*U1/D^2, wI/D, 0, -wI*U1/D^2;...
                                    0, xI/D, -xI*U2/D^2, 0, yI/D, -yI*U2/D^2, 0, wI/D, -wI*U2/D^2];
         end
     end
    end

    function res = residual_area(h, linesData)
    h = [h(1), h(4), h(7);...
         h(2), h(5), h(8);...
         h(3), h(6), h(9)];

    nLines = size(linesData, 1);
    
    endpoints1 = linesData(:, 1:3);
    endpoints2 = linesData(:, 4:6);

    endpointsHat1 = h * endpoints1';
    endpointsHat1 = endpointsHat1(1:2, :) ./ endpointsHat1(3, :);

    endpointsHat2 = h * endpoints2';
    endpointsHat2 = endpointsHat2(1:2, :) ./ endpointsHat2(3, :);

    imageLines = linesData(:, end-2:end);
    res = 0;
    for j=1:nLines
        ep1 = endpointsHat1(:, j);
        ep2 = endpointsHat2(:, j);
        line = imageLines(j, :);
        proj_ep1 = line_projection(ep1, line);
        proj_ep2 = line_projection(ep2, line);
        res = res + area([ep1, proj_ep1, proj_ep2, ep2]);
    end
    end

    function A = area(quad)
    assert(all(size(quad) == [2, 4]), "quad is expected to be size 2x4");
    if is_convex(quad)
        A = convex_polygon_area(quad);
    else
        a = quad(:, 1); pa = quad(:, 2); pb = quad(:, 3); b = quad(:, 4);
        ab = homogenous_line([a; 1], [b; 1]);
        papb = homogenous_line([pa; 1], [pb; 1]);
        if norm(ab) == 0 || norm(papb) == 0
            A = 0;
        else
            m = homogenous_intersection(ab, papb);
            if m(end) ~= 0
                m = m ./ m(end); m = m(1:2);
                A = convex_polygon_area([a, m, pa]) + convex_polygon_area([b, m, pb]);
            else
                ab_unit = ab ./ norm(ab);
                papb_unit = papb ./ norm(papb);
                if any(sign(ab_unit) ~= sign(papb_unit))
                    papb_unit = -papb_unit;
                end
                d = abs(ab_unit(3)-papb_unit(3)) / norm(ab_unit(1:2));
                A = norm(papb)*d;
            end
        end
    end
    end
end

