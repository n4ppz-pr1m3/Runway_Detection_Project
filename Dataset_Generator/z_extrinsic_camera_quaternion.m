% function [Q, T] = z_extrinsic_camera_quaternion(cameraPose, worldPose)

% Compute the extrinsic parameters matrix of the camera with quaternions

% This matrix represents the rigid body transformation from the world
% reference frame to the camera reference frame. The camera's orientation
% is w.r.t the NED reference frame at the camera's location. Similarly, the
% world's orientation is w.r.t the NED reference frame at the world's
% origin.

% Input :
% cameraPose (6 1-d double array) : camera pose
% worldPose (6 1-d double array) : world pose

% Output :
% Q (quaternion) : rotation part of the transformation
% t (3 1-d double array) : translation part of the transformation

% Usage
% [xW; yW; zW] : coordinates of a point P in the world reference frame
% [xC; yC; zC] : coordinates of P in the camera reference frame

% worldPoint = [xW; yW; zW];
% cameraPoint = quat2rotm(Q)' * worlPoint + T;
% or
% cameraPoint = rotateframe(Q, worldPoint');
% cameraPoint = cameraPoint' + T;
% [xC; yC; zC] := cameraPoint

% pose := [lat, lon, ht, heading, pitch, roll]
% lat : geodetic coordinates of the object
% lon :                    -
% ht :                     -
% heading : orientation of the object
% pitch :               -
% roll :                -

function [Q, T] = z_extrinsic_camera_quaternion(cameraPose, worldPose)

% Rotation component
% rotation from world's NED to world frame
headingWorld = worldPose(4);
pitchWorld = worldPose(5);
rollWorld = worldPose(6);
%rotWorldNED2World = rotz(headingWorld) * roty(pitchWorld) * rotx(rollWorld);
quatWorldNED2World = quaternion([-rollWorld, -pitchWorld, -headingWorld], ...
    'eulerd', 'XYZ', 'frame');

% transformation from the camera's NED to the world's NED
cameraLocation = cameraPose(1:3);
worldOrigin = worldPose(1:3);
M = ned2ned(cameraLocation, worldOrigin);
rotCameraNED2WorldNED = M(1:3, 1:3);
quatCameraNED2WorldNED =  quaternion(rotCameraNED2WorldNED, 'rotmat', 'frame');

% rotation from camera frame to camera's NED
headingCam = cameraPose(4);
pitchCam = cameraPose(5);
rollCam = cameraPose(6);
%rotCamera2CameraNED = rotx(-rollCam) * roty(-pitchCam) * rotz(-headingCam);
quatCamera2CameraNED =  quaternion([headingCam, pitchCam, rollCam], ...
    'eulerd', 'ZYX', 'frame');

% rotation from z-camera to camera frame
% camera frame :
%       X-axis : Optical axis | Y-axis : "Right" | Z-axis : "Down"
% z-camera frame :
%       X-axis : "Right" | Y-axis : "Down" | Z-axis : Optical axis
rotZCamera2Camera = [0 1 0; 0 0 1; 1 0 0];
quatZCamera2Camera = quaternion(rotZCamera2Camera, 'rotmat', 'frame');

% complete quaternion
%R = rotCamera2CameraNED * rotCameraNED2WorldNED * rotWorldNED2World;
Q = quatWorldNED2World * quatCameraNED2WorldNED * quatCamera2CameraNED * quatZCamera2Camera;

% Translation component
% translation expressed in camera's NED
T = M(1:3, 4);

% translation expressed in z-camera frame
quatTranslation = quatCamera2CameraNED * quatZCamera2Camera;
rotTranslation = quat2rotm(quatTranslation);
rotTranslation = rotTranslation';
T = rotTranslation * T;

end