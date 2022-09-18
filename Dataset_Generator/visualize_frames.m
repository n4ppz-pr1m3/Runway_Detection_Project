function visualize_frames(cameraPose, worldPose, length)

% Visualize the world and camera reference frames.

% Also provides visualization of the NED reference frames at the world and camera 
% location for context. The orientations of the frames are w.r.t the respective NED
% frames.

% Base axes color of the NED frames
% North/X: Red - East/Y: Green - Down/Z: Blue

% Base axes color of the world and camera frames
% X: Yellow - Y : Cyan - Z: Magenta

% Notes:
% For the camera frame, the X axis is the optical axis

% Input :
% cameraPose (6 1-d double array) : camera pose
% worldPose (6 1-d double array) : world pose
% length (double) : axes length

% Output :
% None

% Note
% pose := [lat, lon, ht, heading, pitch, roll]
% lat (double) : geodetic coordinates of the object
% lon (double) :                    -
% ht (double) :                      -
% heading (double) : object orientation
% pitch (double) :           -
% roll (double) :  

% World parameters
latWorld = worldPose(1);
lonWorld = worldPose(2);
htWorld = worldPose(3);
headingWorld = worldPose(4);
pitchWorld = worldPose(5);
rollWorld = worldPose(6);

% Camera parameters
latCam = cameraPose(1);
lonCam = cameraPose(2);
htCam = cameraPose(3);
headingCam = cameraPose(4);
pitchCam = cameraPose(5);
rollCam = cameraPose(6);

wgs84 = wgs84Ellipsoid;

fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig);
hold(g, 'on');

% World NED ---------------------------------------------------------------
% North/X-axis
[lat, lon, ht] = ned2geodetic([0 length], 0, 0, latWorld, lonWorld, htWorld, wgs84);
geoplot3(g, lat, lon, ht, 'r', 'LineWidth', 5, 'HeightReference','ellipsoid');

% East/Y-axis
[lat, lon, ht] = ned2geodetic(0, [0 length], 0, latWorld, lonWorld, htWorld, wgs84);
geoplot3(g, lat, lon, ht, 'g', 'LineWidth', 5, 'HeightReference','ellipsoid');

% Down/Z-axis
[lat, lon, ht] = ned2geodetic(0, 0, [0 length], latWorld, lonWorld, htWorld, wgs84);
geoplot3(g, lat, lon, ht, 'b', 'LineWidth', 5, 'HeightReference','ellipsoid');

% World frame (rotated world NED) -----------------------------------------
if headingWorld ~= 0 || pitchWorld ~= 0 || rollWorld ~= 0
    rotWorldNED2World = rotz(headingWorld) * roty(pitchWorld) * rotx(rollWorld);
  
    % Local world X-axis
    point = rotWorldNED2World * [length; 0; 0];
    xW = point(1); yW = point(2); zW = point(3);
    [latW, lonW, htW] = ned2geodetic([0 xW], [0 yW], [0 zW], latWorld, lonWorld, htWorld, wgs84);
    geoplot3(g, latW, lonW, htW, 'y', 'LineWidth', 5, 'HeightReference','ellipsoid');

    % Local world Y-axis
    point = rotWorldNED2World * [0; length; 0];
    xW = point(1); yW = point(2); zW = point(3);
    [latW, lonW, htW] = ned2geodetic([0 xW], [0 yW], [0 zW], latWorld, lonWorld, htWorld, wgs84);
    geoplot3(g, latW, lonW, htW, 'c', 'LineWidth', 5, 'HeightReference','ellipsoid');

    % Local world Z-axis
    point = rotWorldNED2World * [0; 0; length];
    xW = point(1); yW = point(2); zW = point(3);
    [latW, lonW, htW] = ned2geodetic([0 xW], [0 yW], [0 zW], latWorld, lonWorld, htWorld, wgs84);
    geoplot3(g, latW, lonW, htW, 'm', 'LineWidth', 5, 'HeightReference','ellipsoid');
end

% Camera NED ---------------------------------------------------------------
% North/X-axis
[lat, lon, ht] = ned2geodetic([0 length], 0, 0, latCam, lonCam, htCam, wgs84);
geoplot3(g, lat, lon, ht, 'r', 'LineWidth', 5, 'HeightReference','ellipsoid');

% East/Y-axis
[lat, lon, ht] = ned2geodetic(0, [0 length], 0, latCam, lonCam, htCam, wgs84);
geoplot3(g, lat, lon, ht, 'g', 'LineWidth', 5, 'HeightReference','ellipsoid');

% Down/Z-axis
[lat, lon, ht] = ned2geodetic(0, 0, [0 length], latCam, lonCam, htCam, wgs84);
geoplot3(g, lat, lon, ht, 'b', 'LineWidth', 5, 'HeightReference','ellipsoid');


% Camera frame (rotated camera NED) -----------------------------------
if headingCam ~= 0 || pitchCam ~= 0 || rollCam ~= 0
    rotCamNED2Cam = rotz(headingCam) * roty(pitchCam) * rotx(rollCam);
    
    % Local camera X-axis
    point = rotCamNED2Cam * [length; 0; 0];
    xC = point(1); yC = point(2); zC = point(3);
    [latC, lonC, htC] = ned2geodetic([0 xC], [0 yC], [0 zC], latCam, lonCam, htCam, wgs84);
    geoplot3(g, latC, lonC, htC, 'y', 'LineWidth', 5, 'HeightReference','ellipsoid');

    % Local camera Y-axis
    point = rotCamNED2Cam * [0; length; 0];
    xC = point(1); yC = point(2); zC = point(3);
    [latC, lonC, htC] = ned2geodetic([0 xC], [0 yC], [0 zC], latCam, lonCam, htCam, wgs84);
    geoplot3(g, latC, lonC, htC, 'c', 'LineWidth', 5, 'HeightReference','ellipsoid');

    % Local camera Z-axis
    point = rotCamNED2Cam * [0; 0; length];
    xC = point(1); yC = point(2); zC = point(3);
    [latC, lonC, htC] = ned2geodetic([0 xC], [0 yC], [0 zC], latCam, lonCam, htCam, wgs84);
    geoplot3(g, latC, lonC, htC, 'm', 'LineWidth', 5, 'HeightReference','ellipsoid');
end

hold(g, 'off');

campos(g, latCam, lonCam, htCam);
camheading(g, headingCam);
campitch(g, pitchCam);
%camroll(g, rollCam);   % apply roll to the view

end