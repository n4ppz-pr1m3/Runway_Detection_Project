function M = z_extrinsic_matrix(cameraPose, worldPose, method)

% Compute the extrinsic parameters matrix of the camera

% This matrix represents the rigid body transformation from the world
% reference frame to the camera reference frame. The camera's orientation
% is w.r.t the NED reference frame at the camera's location. Similarly, the
% world's orientation is w.r.t the NED reference frame at the world's
% origin.
% M = [R T]. R (3*3 matrix) and T (3*1 matrix/vector) respectively
% represent the rotation and translation parts of the transformation.

% The matrix can either be computed with quaternions or rotation matrices.

% Camera axes / directions:
% X-axis : right | Y-axis : down | Z-axis : optical axis

% Usage
% [xC; yC; zC] = M * [xW; yW; zW; 1]
% [xW; yW; zW] : coordinates of a point P in the world reference frame
% [xC; yC; zC] : coordinates of P in the camera reference frame

% pose := [lat, lon, ht, heading, pitch, roll]
% lat : geodetic coordinates of the object
% lon :                    -
% ht :                     -
% heading : orientation of the object
% pitch :               -
% roll :                -

% Input :
% cameraPose (6 1-d double array) : camera pose
% worldPose (6 1-d double array) : world pose
% [Optional] method (string) : computation method ('quat' (default) | 'rotm')

% Output :
% M (3*4 2-d double array) : rigid body transformation matrix

if ~exist("method", "var")
    method = "quat";
end

if method == "quat"
    [Q, T] = z_extrinsic_camera_quaternion(cameraPose, worldPose);
    R = quat2rotm(Q);
    M = [R' T];
elseif method == "rotm"
    % Rotation from z-camera to camera frame
    % camera frame :
    %       X-axis : Optical axis | Y-axis : "Right" | Z-axis : "Down"
    % z-camera frame :
    %       X-axis : "Right" | Y-axis : "Down" | Z-axis : Optical axis
    rotZCamera2Camera = [0 1 0; 0 0 1; 1 0 0];
    
    M = rotZCamera2Camera * extrinsic_camera_matrix(cameraPose, worldPose);
else
    error("Unknown computation method " + method);
end

end

