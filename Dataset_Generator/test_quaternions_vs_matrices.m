
% Shows the numerical difference when computing a change of coordinates
% transformation on random data when using quaternions and rotation matrices.

clear; clc;
cameraPose = [1000 * randn(1, 3), 100 * randn(1, 3)];   % Random camera pose
worldPose = [1000 * randn(1, 3), 100 * randn(1, 3)];    % Random world pose
worldPoint = 1000 * randn(3, 1);                        % Random world point

mQuat = z_extrinsic_matrix(cameraPose, worldPose, 'quat');
mRot = z_extrinsic_matrix(cameraPose, worldPose, 'rotm');

camPointQuat = mQuat * [worldPoint; 1];
camPointRot = mRot * [worldPoint; 1];

absErr = norm(camPointRot - camPointQuat);
relErr = absErr / norm(camPointQuat);
disp("Absolute difference between camera coordinates computed with rotation matrices and quaternions : " + absErr);
disp("Relative difference between camera coordinates computed with rotation matrices and quaternions : " + relErr);
