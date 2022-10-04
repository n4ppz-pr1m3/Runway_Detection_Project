
% function p = zhang_matrices2params(intrinsicMatrix, extrinsics)

% Composes a Zhang calibration parameters vector from an intrinsic matrix
% and a global extrinsics vector.

% Input :
% intrinsicMatrix (3x3 2-d double array) : intrinsic matrix
% extrinsics (6xN 1-d double array) : stacked extrinsics of all views

% Output :
% p (3+6xN 1-d double array) : calibration parameters vector

function p = zhang_matrices2params(intrinsicMatrix, extrinsics)

f = intrinsicMatrix(1, 1);
u0 = intrinsicMatrix(1, 3);
v0 = intrinsicMatrix(2, 3);
p = [f; u0; v0; extrinsics(:)];

end

