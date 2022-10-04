
% function extrinsics = homographies2extrinsics(homographies, intrinsicMatrix)

% Computes extrinsics vectors from a set of homographies and an intrinsic matrix.

% In the context of Zhang calibration, each homography represents the
% transformation associated with the imaging of a planar surface. The
% corresponding extrinsics vector encodes the relative pose of the camera
% w.r.t the surface.

% Input :
% homographies (3x3xN 3-d double array) : homographies
% intrinsicMatrix (3x3 2-d double array) : intrinsic matrix

% Output :
% extrinsics (6xN 2-d double array) : extrinsics vectors

function extrinsics = homographies2extrinsics(homographies, intrinsicMatrix)

nHomographies = size(homographies, 3);
extrinsics = zeros(6, nHomographies);
for i=1:nHomographies
    RT = intrinsicMatrix \ homographies(:, :, i);
    RT = RT .* (2/(norm(RT(:, 1)) + norm(RT(:, 2))));
    r1 = RT(:, 1);
    r2 = RT(:, 2);
    r3 = cross(r1, r2);
    [U, ~, V] = svd([r1, r2, r3]);
    RV = rotationMatrixToVector(U*V')';
    T = RT(:, 3);
    extrinsics(:, i) = [RV; T];
end

end

