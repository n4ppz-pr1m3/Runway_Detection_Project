%% Calibration procedure
% Estimates the intrinsic parameters of a camera by using multiple views of
% a single control point with known camera and image coordinates.

% Pipeline
% 0 - Calibration parameters
% 1a - Calibration images generation in pdf format
% 1b - Camera coordinates computation
% 2 - Calibration images conversion in target size and format
% 3 - Images coordinates computation
% 4 - [Optional] Re-computation of selected image coordinates
% 5 - Intrinsic parameters estimation
% 6 - [Optional] Visualize reprojected control points

% Step 3 being a manual process, multiple iterations of step 4 followed by
% step 5 might be necessary for accurate estimations.