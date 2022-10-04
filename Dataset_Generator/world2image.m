% function imagePoints = world2image(cameraMatrix, worldPoints)

% Compute the image coordinates of world points.

% Notes
% s * [xI; yI; 1] = cameraMatrix * [xW; yW; zW; 1]
% cameraMatrix = K * [R t]
% K : 3*3 intrinsic matrix of the camera used to produce the image
% [R T] : 3*4 extrinsic matrix (transformation from world coordinates to
% camera coordinates)
% [xI; yI; 1] : homogenous image coordinates
% [xW; yW; zW; 1] : homogenous world coordinates
% s : scale factor

% Input :
% cameraMatrix (3*4 2-d double array) : camera matrix                     -
% worldPoints (3*n 2-d double array) : 3d world coordinates

% Output :
% imagePoints (2*n 2-d double array) : 2d image coordinates

function imagePoints = world2image(cameraMatrix, worldPoints)

% homogenous world coordinates
nPoints = size(worldPoints, 2);
homogenousWorldPoints = [worldPoints; ones(1, nPoints)];

% homogenous image coordinates
homogenousImagePoints = cameraMatrix * homogenousWorldPoints;

% normalize the scale factors
imagePoints = homogenousImagePoints(1:2, :) ./ homogenousImagePoints(3, :);

end

