function [p, resnorm, residual, exitflag, output] = refine_zhang_estimation(allImagePoints, worldPoints, p0)

nPoints = size(allImagePoints, 1);
nImages = size(allImagePoints, 3);

imagesData = zeros(2*nPoints*nImages, 1);
for i=1:nImages
    imagePoints = allImagePoints(:, :, i);
    imagesData(1+2*nPoints*(i-1):2*nPoints*i) = imagePoints(:);
end

val_fun = @(x, xdata) world2images(x, xdata);
lb = [0; 0; 0; -Inf(size(p0(4:end)))];
ub = Inf(size(p0));

[p, resnorm, residual, exitflag, output] = lsqcurvefit(...
    val_fun, p0, worldPoints, imagesData, lb, ub);

    function allImagePointsHat = world2images(p, worldPoints)
        
        n = size(worldPoints, 1);
        nPoses = round((length(p)-3) / 6);
        allImagePointsHat = zeros(2*n*nPoses, 1);
        
        f = p(1); u0 = p(2); v0 = p(3);
        intrinsicMatrix = [f, 0, u0;...
                           0, f, v0;...
                           0, 0, 1];
                       
        for j=1:nPoses
            extrinsicMatrix = extrinsics2extrinsicMatrix(p(4+6*(j-1):3+6*j));
            cameraMatrix = intrinsicMatrix * extrinsicMatrix;
            imagePointsHat = world2image(cameraMatrix, [worldPoints, zeros(n, 1)]');
            imagePointsHat = imagePointsHat';
            allImagePointsHat(1+2*n*(j-1):2*n*j) = imagePointsHat(:);
        end
    end
    
end
