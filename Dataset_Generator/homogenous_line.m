% function line = homogenous_line(point1, point2)

% Compute the homogenous coordinates of the line joining two points in 2d.

% Input :
% point1 (3 1-d array) : homogenous coordinates of the first point
% point2 (3 1-d array) : homogenous coordinates of the second point

% Output :
% line (3 1-d double array) : homogenous coordinates of the joining line

function line = homogenous_line(point1, point2)

if ~isvector(point1) || (length(point1) ~= 3) || ...
        ~isvector(point2) || (length(point2) ~= 3)
    error("point1 and point2 are expected to be 3-vectors")
end

x1 = point1(1); y1 = point1(2); w1 = point1(3);
x2 = point2(1); y2 = point2(2); w2 = point2(3);

line = [y1*w2 - y2*w1;...
        x2*w1 - x1*w2;...
        x1*y2 - x2*y1];

end

