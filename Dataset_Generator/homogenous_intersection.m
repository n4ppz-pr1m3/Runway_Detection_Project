
% function point = homogenous_intersection(line1, line2)

% Compute the homogenous intersection of two lines.

% Input :
% line1 (3 1-d double array) : homogenous coordinates of the first line
% line2 (3 1-d double array) : homogenous coordinates of the second line

% Output :
% point (3 1-d double array) : homogenous coordinates of the intersection

function point = homogenous_intersection(line1, line2)

if ~isvector(line1) || (length(line1) ~= 3) || ...
        ~isvector(line2) || (length(line2) ~= 3)
    error("line1 and line2 are expected to be 3-vectors")
end

a1 = line1(1); b1 = line1(2); c1 = line1(3);
a2 = line2(1); b2 = line2(2); c2 = line2(3);

point = [b1*c2 - b2*c1;...
         a2*c1 - a1*c2;...
         a1*b2 - a2*b1];

end

