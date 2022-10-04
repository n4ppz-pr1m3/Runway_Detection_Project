
% function area = convex_polygon_area(polygon)

% Computes the area of a convex polygon

% Input :
% polygon (2xN 2-d double array) : polygon vertices cartesian coordinates

% Output :
% area (double) : polygon area

function area = convex_polygon_area(polygon)

assert(is_convex(polygon), "polygon must be convex")

p = [polygon, polygon(:, 1)];
area = 0.5 * abs(p(1, 1:end-1)*p(2, 2:end)' - p(2, 1:end-1)*p(1, 2:end)');
end

