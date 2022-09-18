% function line = points2line(point1, point2)

% Compute the homogenous coordinates of the line joining two points in 2d.

% Input :
% point1 (2 1-d array) : cartesian coordinates of the first point
% point2 (2 1-d array) : cartesian coordinates of the second point

% Output :
% line (3 1-d double array) : homogenous coordinates of the joining line

function line = points2line(point1, point2)

if ~isvector(point1) || (length(point1) ~= 2) || ...
        ~isvector(point2) || (length(point2) ~= 2)
    error("point1 and point2 are expected to be 2-vectors")
end

homogenous_point1 = cartesian2homogenous(point1);
homogenous_point2 = cartesian2homogenous(point2);

line = homogenous_line(homogenous_point1, homogenous_point2);

    function hv = cartesian2homogenous(v)
        if size(v, 1) == 1
            hv = [v, 1];
        elseif size(v, 2) == 1
            hv = [v; 1];
        end
    end

end

