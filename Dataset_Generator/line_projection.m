
% function [point_hat, distance] = line_projection(point, line)

% Computes the orthogonal projection of a 2d point onto a line.

% Input :
% point (2 1-d double array) : point coordinates
% line (3 1-d double array) : line homogenous coordinates

% Output :
% point_hat (2 1-d double array) : projected point coordinates
% distance (double) : distance between the point and the line

function [point_hat, distance] = line_projection(point, line)

assert(isvector(point) && length(point) == 2, "point is expected to be a 2-vector")
assert(isvector(line) && length(line) == 3, "line is expected to be a 3-vector")

xp = point(1);
yp = point(2);

a = line(1);
b = line(2);
c = line(3);

lambda = (a*xp+b*yp+c) / (a^2+b^2);
point_hat = point - lambda*[a; b];

if nargout > 1
    distance = abs(lambda) * sqrt(a^2+b^2);
end
end

