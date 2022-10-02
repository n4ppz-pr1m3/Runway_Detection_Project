
% function [fov_hor, fov_ver] = fov(fx, fy, width, height)

% Compute the field of view of a camera along the x and y directions.

% Input :
% fx (double) : focal length of the camera along the x axis
% fy (double) : focal length of the camera along the y axis
% width (double) : image width
% height (double) : image height

% Output :
% fov_hor (double) : horizontal field of view in degrees
% fov_ver (double) : vertical field of view in degrees

function [fov_hor, fov_ver] = fov(fx, fy, width, height)

fov_hor = 2 * atan2(width, 2*fx) * (180/pi);
fov_ver = 2 * atan2(height, 2*fy) * (180/pi);

end

