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

%% 0 - Calibration parameters
clear; clc; close all

numImages = 4;      % Number of images used for calibration
dpi = 30;           % dpi used for conversion from pdf images

baseFilename = "calibration_image";
imageFormat = "png";
calibrationFolder = "./Calibration/Intrinsic";

calibrationData = setup_calibration(numImages, dpi, calibrationFolder,...
                                    baseFilename, imageFormat);

%% 1a/1b - Images generation + camera coordinates generation

calibrationData = generate_pdf_calibration_images(calibrationData);

%% 2 - Images conversions

calibrationData = convert_pdf_calibration_images(calibrationData);

%% Images coordinates generation

calibrationData = measure_images_points(calibrationData);

%% [OPTIONAL] Edit image coordintes

image_number = 1;     % Image coordinates to edit
calibrationData = measure_images_points(calibrationData, image_number);

%% Intrinsic parameters estimation

calibrationData = estimate_intrinsic(calibrationData);

%% [Optional] Show reprojections

show_reprojections(calibrationData)
