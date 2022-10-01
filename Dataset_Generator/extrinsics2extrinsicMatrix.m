% function extrinsicMatrix = extrinsics2extrinsicMatrix(extrinsics)

% Converts an extrinsics vector to a matrix form.

% Given an extrinsics vector vE = [vR; T] with rotation vector vR and
% translation vector T, the associated extrinsic matrix is E = [R; T] with
% R being the rotation matrix computed from vR with Rodrigues' formula.

% Input :
% extrinsics (6 1-d double array) : extrinsics vector

% Output :
% extrinsicMatrix (3x4 2-d double array) : extrinsic matrix

function extrinsicMatrix = extrinsics2extrinsicMatrix(extrinsics)
rotationVector = extrinsics(1:3);
translationVector = extrinsics(4:6);
extrinsicMatrix = [rotationVectorToMatrix(rotationVector), translationVector];
end

