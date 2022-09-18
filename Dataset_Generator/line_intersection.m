% function [x, y] = line_intersection(line1, line2)

% Compute the cartesian intersection of two lines.

% Returns Inf/-Inf/NaN if the lines are parallel

% Input :
% line1 (3 1-d array) : homogenous coordinates of the first line
% line2 (3 1-d array) : homogenous coordinates of the second line

% Output :
% x (double) : cartesian x coordinates of the intersection
% y (double) : cartesian y coordinates of the intersection

function [x, y] = line_intersection(line1, line2)

point = homogenous_intersection(line1, line2);

x = point(1) / point(3);
y = point(2) / point(3);

end

