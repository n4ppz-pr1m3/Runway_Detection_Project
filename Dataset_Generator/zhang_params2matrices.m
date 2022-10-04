
% function [intrinsicMatrix, extrinsics] = zhang_params2matrices(p)

% Extracts the intrinsic matrix and extrinsics from a Zhang calibration
% parameters vector.

% p should have length 3+6xN where N is the number of images used
% for calibration since an ideal camera with square pixels and no
% distorsion is assumed.

% The ith column of extrinsics is e_i := [vR_i; T_i] is the transformation
% associated with view i with vR_i being the rotation vector and T_i the
% translation.

% Input :
% p (1-d double array) : parameters vectors

% Output :
% intrinsicMatrix (3x3 2-d double array) : intrinsic matrix
% extrinsics (6xN 2-d double array) : extrinsics vectors

function [intrinsicMatrix, extrinsics] = zhang_params2matrices(p)

intrinsicMatrix = [p(1), 0,    p(2);...
                   0,    p(1), p(3);...
                   0,    0,    1];
               
extrinsics = reshape(p(4:end), 6, []);
end

