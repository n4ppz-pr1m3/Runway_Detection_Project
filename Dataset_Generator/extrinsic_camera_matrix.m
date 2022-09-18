function M = extrinsic_camera_matrix(cameraPose, worldPose)

% Compute the extrinsic parameters matrix of the camera with rotation
% matrices

% This matrix represents the rigid body transformation from the world
% reference frame to the camera reference frame. The camera's orientation
% is w.r.t the NED reference frame at the camera's location. Similarly, the
% world's orientation is w.r.t the NED reference frame at the world's
% origin.
% M = [R T]. R (3*3 matrix) and T (3*1 matrix/vector) respectively
% represent the rotation and translation parts of the transformation.

% Camera axes / directions:
% X-axis : optical axis | Y-axis : right | Z-axis : down

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

% Output :
% M (3*4 2-d double array) : rigid body transformation matrix

% Rotation component
% rotation from world's NED to world frame
headingWorld = worldPose(4);
pitchWorld = worldPose(5);
rollWorld = worldPose(6);
rotWorldNED2World = rotz(headingWorld) * roty(pitchWorld) * rotx(rollWorld);

% transformation from the camera's NED to the world's NED
cameraLocation = cameraPose(1:3);
worldOrigin = worldPose(1:3);
M = ned2ned(cameraLocation, worldOrigin);
rotCameraNED2WorldNED = M(1:3, 1:3);

% rotation from camera frame to camera's NED
headingCam = cameraPose(4);
pitchCam = cameraPose(5);
rollCam = cameraPose(6);
rotCamera2CameraNED = rotx(-rollCam) * roty(-pitchCam) * rotz(-headingCam);

% complete rotation
R = rotCamera2CameraNED * rotCameraNED2WorldNED * rotWorldNED2World;
M(1:3, 1:3) = R;

% Translation component
% translation expressed in camera's NED
T = M(1:3, 4);

% translation expressed in camera frame / final translation
T = rotCamera2CameraNED * T;
M(1:3, 4) = T;

end