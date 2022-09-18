% function M = inv_extrinsic(extrinsic)

% Given an extrinsic transformation from a reference frame to another,
% compute the reverse transformation.

% Usage:
% Given the following:
% Two frames: A and B
% An extrinsic transformation from A to B: extAB
% A point P with coordinates pA := [xA; yA; zA] and pB := [xB; yB; zB] in
% frames A and B.
% We have: pB = extAB * [pA; 1]
% Then extBA := inv_extrinsic(extAB) verify : pA = extBA * [pB; 1]

% Input :
% extrinsic (3*4 2-d double array) : rigid body transformation

% Output :
% M (3*4 2-d double array) : inverse transformation

function M = inv_extrinsic(extrinsic)

if size(extrinsic, 1) ~= 3 || size(extrinsic, 2) ~= 4
    error("The extrinsic is expected to have size 3x4")
end

% Rotation component
R = extrinsic(1:3, 1:3);

% Translation component
T = extrinsic(1:3, 4);

% Inverse transformation
M = [R' -R'*T];

end