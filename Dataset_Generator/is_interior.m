
% function bool = is_interior(p, polygon, method)

% Checks if a point is inside a convex polygon

% 3 computation methods are available.

% "side check" (default)
% Checks that the point is on the correct side of each edge by evaluating
% the angles (V_{i}P, V_{i}V_{i+1}) and ensuring they are less than 180 degrees.

% "hyperplane"
% Compute the hyperplane equation associated with each edge and ensure that
% the point lies on the correct region.

% "wachspress"
% Compute the wachspress coordinates of the point (generalized barycentric
% coordinates w.r.t. the polygon vertices) and ensure they're non negative.

% Input :
% p (2 1-d double array) : coordinates of the point
% polygon (2xN 2-d double array) : polygon vertices cartesian coordinates
% method (string) : "side check"|"hyperplane"|"wachspress"

% Output :
% bool (boolean) : interior test return value

function bool = is_interior(p, polygon, method)

if (numel(size(p)) ~= 2) || (size(p, 2) ~= 1)
    error("p is expected to be a length 2 column vector")
end

[is_cvx, verticesOrdering] = is_convex(polygon);
if ~is_cvx
    error("polygon is expected to be convex")
end

if ~exist("method", "var")
    method = "side check";
end

if (method == "side check") || (method == "hyperplane")

    if verticesOrdering == "clockwise"
        orientation = "direct";
        orderingIndicator = 1;
    elseif verticesOrdering == "counter-clockwise"
        orientation = "indirect";
        orderingIndicator = -1;
    else
        error("Unexpected vertices ordering " + string(verticesOrdering));
    end
    
    nVertices = size(polygon, 2);
    edges = [polygon(:, 2:end), polygon(:, 1)] - polygon;
    
    if method == "side check"
        v = p - polygon;
        alt180 = true;
        i = 1;
        while (i <= nVertices) && alt180
            alt180 = angleLessThan180(v(:, i), edges(:, i), orientation);
            i = i + 1;
        end
        bool = alt180;
    
    elseif method == "hyperplane"
        is_inside = true;
        i = 1;
        while (i <= nVertices) && is_inside
            a = -edges(2, i);
            b = edges(1, i);
            c = -[a, b] * polygon(:, i);
            is_inside = (sign([a, b]*p + c) * orderingIndicator) <= 0;
            i = i + 1;
        end
        bool = is_inside;
    end

elseif method == "wachspress"
    weights = wachspress_coordinates(p, polygon);
    bool = ~any(sign(weights) == -1);

else
    error("Unknown method " + string(method) + ". Valid methods are: 'side check'|'hyperplane'|'wachspress'")
end

end
