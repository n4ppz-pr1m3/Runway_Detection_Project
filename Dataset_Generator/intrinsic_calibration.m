%% Calibration procedure
% Estimates the intrinsic parameters of a camera by using multiple views of
% a single control point with known camera and image coordinates.

% Pipeline
% 1a - Calibration images generation in pdf format
% 1b - Camera coordinates computation
% 2 - Calibration images conversion in target size and format
% 3 - Image coordinates computation
% 4 - [Optional] Re-computation of selected image coordinates
% 5 - Intrinsic parameters estimation
% 6 - [Optional] Visualize reprojected control points

% Step 3 being a manual process, multiple iterations of step 4 followed by
% step 5 might be necessary for accurate estimations.
%% Images generation + camera coordinates generation
clear; clc; close all

numImages = 4; % Number of images used for calibration
cropValue = 11;
dpi = 50;

baseFilename = "calibration_image";
imageFormat = "png";
calibrationFolder = "./Calibration/Intrinsic";
calibrationDataPath = calibrationFolder + "/calibrationIntrinsic.mat";
calibrationData = "calibrationIntrinsic";
sourceFolder = calibrationFolder + "/Original_PDF_Calibration_Images";  % pdf images
destinationFolder = calibrationFolder + "/Calibration_Images";          % converted images
reprojectionFolder = calibrationFolder + "/Reprojection_Images";

if ~mkdir(".", calibrationFolder)
    error("Unable to create " + calibrationFolder);
end

if ~mkdir(".", sourceFolder)
    error("Unable to create " + sourceFolder);
end

if ~mkdir(".", destinationFolder)
    error("Unable to create " + destinationFolder);
end

if ~mkdir(".", reprojectionFolder)
    error("Unable to create " + reprojectionFolder);
end

% Calibration settings
calibrationIntrinsic = [];
calibrationIntrinsic.numImages = numImages;
calibrationIntrinsic.imageFormat = imageFormat;
calibrationIntrinsic.imageSize = [];
calibrationIntrinsic.cropValue = cropValue;
calibrationIntrinsic.dpi = dpi;
calibrationIntrinsic.baseFilename = baseFilename;
calibrationIntrinsic.imagesFolder = destinationFolder;
calibrationIntrinsic.pdfImagesFolder = sourceFolder;
calibrationIntrinsic.reprojectionFolder = reprojectionFolder;
calibrationIntrinsic.cameraPoints = [];
calibrationIntrinsic.imagePoints = [];
calibrationIntrinsic.intrinsicMatrix = [];
calibrationIntrinsic.fov = [];
calibrationIntrinsic.residuals = [];
calibrationIntrinsic.meanReprojectionError = [];

% Calibration points  -------------------------------------------------------
%load('./Calibration/Intrinsic/Calibration_Data/dataLTP.mat')
dataLTP = load_dataLTP;

% LTP1
ltp1 = dataLTP(1, :);
latLTP1 = string2angle(ltp1(2));
lonLTP1 = string2angle(ltp1(3));
htLTP1 = double(ltp1(4));
latFPAP1 = string2angle(ltp1(5));
lonFPAP1 = string2angle(ltp1(6));

% LTP2
ltp2 = dataLTP(2, :);
latLTP2 = string2angle(ltp2(2));
lonLTP2 = string2angle(ltp2(3));
htLTP2 = double(ltp2(4));
latFPAP2 = string2angle(ltp2(5));
lonFPAP2 = string2angle(ltp2(6));

% World pose
wgs84 = wgs84Ellipsoid;
[headingWorld, pitchWorld, dLTP] = geodetic2aer(latLTP2, lonLTP2, htLTP2, ...
    latLTP1, lonLTP1, htLTP1, wgs84);

worldPose = [latLTP1, lonLTP1, htLTP1, headingWorld, pitchWorld, 0];

% Plot
fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig);

% Calibration point selection
wp = "LTP1"; % LTP1 | LTP2
c = (wp == "LTP1");
latWP = c*latLTP1 + (1-c)*latLTP2;
lonWP = c*lonLTP1 + (1-c)*lonLTP2;
htWP = c*htLTP1 + (1-c)*htLTP2;

worldPoint = [(1-c)*dLTP; 0; 0];
geoplot3(g, latWP, lonWP, htWP, 'ro', 'MarkerSize', 1, 'LineWidth', 0.5, 'HeightReference','ellipsoid');

% Initial camera
[latCam, lonCam, htCam] = aer2geodetic(0, 90, 500, ...
    latWP, lonWP, htWP, wgs84);
campos(g, latCam, lonCam, htCam);
campitch(g, -90);

% Images and calibration point camera coordinates generation --------------
cameraPoints = zeros(numImages, 3);
disp("Generating " + string(numImages) + " images.")
for i=1:numImages
    disp("Position the camera and press ENTER in the command window to generate image " + string(i));
    pause
    % Selected camera pose
    [latCam, lonCam, htCam] = campos(g);
    headingCam = camheading(g);
    pitchCam = campitch(g);
    rollCam = camroll(g);
    cameraPose = [latCam, lonCam, htCam, headingCam, pitchCam, rollCam];

    % Camera coordinate
    worldTransform = z_extrinsic_matrix(cameraPose, worldPose);
    cameraPoints(i, :) = (worldTransform * [worldPoint; 1])';
 
    % Save image
    filename = sourceFolder + "/" + baseFilename + "_" + string(i) + ".pdf";
    exportapp(fig, filename);
end
close(fig)
% Save calibration point camera coordinates
calibrationIntrinsic.cameraPoints = cameraPoints;
save(calibrationDataPath, calibrationData);

%% Images conversion
clear; clc; close all;
load(calibrationDataPath);
sourceFolder = calibrationIntrinsic.pdfImagesFolder;
destinationFolder = calibrationIntrinsic.imagesFolder;
imageFormat = calibrationIntrinsic.imageFormat;

dpi = calibrationIntrinsic.dpi;
cropValue = calibrationIntrinsic.cropValue;

disp("Converting images...")
cmd = "mogrify -format " + imageFormat + " -path " + destinationFolder + ...
    " -density " + string(dpi) + " -depth 8 -quality 100 -gravity South -chop 0x" +...
    string(cropValue) + " " + sourceFolder + "/*.pdf";

% Linux
if isunix
    status = system(cmd);
% Windows
elseif ispc
    status = system("magick " + cmd);
end

if status
    disp('Conversion error')
else
    disp('Conversion done')
end

%% Image coordinates generation
clc; clear; close all;
load(calibrationDataPath);
imagesFolder = calibrationIntrinsic.imagesFolder;
baseFilename = calibrationIntrinsic.baseFilename;
ext = calibrationIntrinsic.imageFormat;
numImages = calibrationIntrinsic.numImages;

imagePoints = zeros(numImages, 2);
for i=1:numImages
    filename = imagesFolder + "/" + baseFilename + "_" + string(i) + "." + ext;
    %imagePoints(i, :) = mark_image(filename, 1, 1, [], '');
    imagePoints(i, :) = mark_point(filename, 0.025);
end

% Save calibration point image coordinates
calibrationIntrinsic.imagePoints = imagePoints;

% Save images size
I = imread(filename);
calibrationIntrinsic.imageSize = size(I);
save(calibrationDataPath, calibrationData);

%% [OPTIONAL] Edit image coordintes
clc; clear; close all;
load(calibrationDataPath);
imagesFolder = calibrationIntrinsic.imagesFolder;
baseFilename = calibrationIntrinsic.baseFilename;
ext = calibrationIntrinsic.imageFormat;

numImage = 1; % Image coordinates to edit

filename = imagesFolder + "/" + baseFilename + "_" + string(numImage) + "." + ext;
imagePoints = calibrationIntrinsic.imagePoints;
%imagePoints(numImage, :) = mark_image(filename, 1, 1, [], '');
imagePoints(numImage, :) = mark_point(filename, 0.025);
calibrationIntrinsic.imagePoints = imagePoints;
save(calibrationDataPath, calibrationData);

%% [Default] Intrinsic parameters estimation
% Estimates 5 parameters : focal lengths along X and Y, skew and principal point
clc; clear; close all;
load(calibrationDataPath);
cameraPoints = calibrationIntrinsic.cameraPoints;
imagePoints = calibrationIntrinsic.imagePoints;
[intrinsicMatrix0, aspectRatio, skew, mre0, lmx, lmy] = estimate_intrinsic(imagePoints, cameraPoints);
[intrinsicMatrix, residuals, mre] = least_squares_estimate(imagePoints, cameraPoints, aspectRatio, skew);
calibrationIntrinsic.intrinsicMatrix = intrinsicMatrix;
calibrationIntrinsic.residuals = residuals;
calibrationIntrinsic.meanReprojectionError = mre;
imageSize = calibrationIntrinsic.imageSize;
fx = intrinsicMatrix(1, 1); fy = intrinsicMatrix(2, 2);
[fov_hor, fov_ver] = fov(fx, fy, imageSize(2), imageSize(1));
calibrationIntrinsic.fov = [fov_hor, fov_ver];
save(calibrationDataPath, calibrationData);


%% [Optional] Show reprojections
% Visualize reprojected control points
clc; clear; close all;
load(calibrationDataPath);
numImages = calibrationIntrinsic.numImages;
width = calibrationIntrinsic.imageSize(2);
intrinsicMatrix = calibrationIntrinsic.intrinsicMatrix;
cameraPoints = calibrationIntrinsic.cameraPoints;
residuals = calibrationIntrinsic.residuals;
errors = zeros(numImages, 1);
for i=1:numImages
    errors(i) = norm(residuals(i, 1));
end

% Debug
reprojectedImagePoints = cameraPoints * intrinsicMatrix';
reprojectedImagePoints = reprojectedImagePoints ./ reprojectedImagePoints(:, 3);
reprojectedImagePoints = reprojectedImagePoints(:, 1:2);
imagePoints = calibrationIntrinsic.imagePoints;
mre = sqrt(sum((imagePoints-reprojectedImagePoints).^2, 'all') / numImages);

imageFolder = calibrationIntrinsic.imagesFolder;
reprojectionFolder = calibrationIntrinsic.reprojectionFolder;
basename = calibrationIntrinsic.baseFilename;
ext = calibrationIntrinsic.imageFormat;
for i=1:numImages
    filename = imageFolder + "/" + basename + "_" + string(i) + "." + ext;
    reproj_filename = reprojectionFolder + "/reprojected_" + basename + "_" + string(i) + "." + ext;
    fig = imshow(filename);
    hold on;
    plot(imagePoints(i, 1), imagePoints(i, 2), 'r+');
    plot(reprojectedImagePoints(i, 1), reprojectedImagePoints(i, 2), 'go');
    hold off;
    if imagePoints(i, 1) >= width/2
        lcn = "northwest";
    else
        lcn = "northeast";
    end
    legend("Original calibration point", "Reprojected calibration point", "Location", lcn);
    title("Reprojection error : " + string(errors(i)) + " pixels");
    saveas(fig, reproj_filename);
end
close all;
save(calibrationDataPath, calibrationData);
