% function extrinsics = extrinsicMatrix2extrinsics(extrinsicMatrix)

% Converts an extrinsic matrix to a 6dof vector.

% Given an extrinsic matrix E = [R T] with rotation matrix R and translation
% vector T, the associated extrinsics vector is given by vE = [vR; T] with
% vR being the vector representation of R according to Rodrigues' formula.

% Input :
% extrinsicMatrix (3x4 2-d double array) : extrinsic matrix

% Output :
% extrinsics (6 1-d double array) : extrinsics vector

function extrinsics = extrinsicMatrix2extrinsics(extrinsicMatrix)
rotationMatrix = extrinsicMatrix(1:3, 1:3);
rotationVector = rotationMatrixToVector(rotationMatrix)';
translationVector = extrinsicMatrix(:, 4);
extrinsics = [rotationVector; translationVector];
end
