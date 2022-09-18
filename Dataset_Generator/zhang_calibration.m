%% Images generation + camera coordinates generation
clear; clc; close all

numImages = 9; % Number of images used for calibration

baseFilename = "calibration_image";
imageFormat = "png";
sourceFolder = "./Calibration/Zhang/Original_PDF_Calibration_Images";  % pdf images
destinationFolder = "./Calibration/Zhang/Calibration_Images";          % converted images

% Calibration settings
calibrationZhang = [];
calibrationZhang.numImages = numImages;
calibrationZhang.baseFilename = baseFilename;
calibrationZhang.imageFormat = imageFormat;
calibrationZhang.imagesFolder = destinationFolder;
calibrationZhang.pdfImagesFolder = sourceFolder;

% Calibration points  -------------------------------------------------------
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

% Initial camera
[latCam, lonCam, htCam] = aer2geodetic(0, 90, 500, ...
    latLTP1, lonLTP1, htLTP1, wgs84);
campos(g, latCam, lonCam, htCam);
campitch(g, -90);

% Images and world transforms generation --------------
worldTransforms = zeros(3, 4, numImages);
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
    worldTransforms(:, :, i) = z_extrinsic_matrix(cameraPose, worldPose);
 
    % Save image
    filename = sourceFolder + "/" + baseFilename + "_" + string(i) + ".pdf";
    exportapp(fig, filename);
end
close(fig)
% Save calibration point camera coordinates
calibrationZhang.worldTransforms = worldTransforms;
save("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat", "calibrationZhang");
%% Images conversion
clear; clc; close all;
load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat");
sourceFolder = calibrationZhang.pdfImagesFolder;
destinationFolder = calibrationZhang.imagesFolder;
ext = calibrationZhang.imageFormat;

disp("Converting images...")
cmd = "mogrify -format " + ext + " -path " + destinationFolder + ...
    " -density 96 -depth 8 -quality 100  " + sourceFolder + "/*.pdf";
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

% Edges detection
disp('Edges detection...')
baseFilename = calibrationZhang.baseFilename;
nImages = calibrationZhang.numImages;
for i=1:nImages
    filename = destinationFolder + "/" + baseFilename + "_" + string(i) + "." + ext;
    rgb = imread(filename);
    gray = rgb2gray(rgb);
    bw = ~edge(gray);
    imwrite(bw, filename);
end
disp('Edges detection complete')

%% Image coordinates generation
clc; clear; close all;
load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat");
imagesFolder = calibrationZhang.imagesFolder;
baseFilename = calibrationZhang.baseFilename;
ext = calibrationZhang.imageFormat;
numImages = calibrationZhang.numImages;

% The pattern's keypoints are located on a (2x24) grid
nHorizontal = 2;
nVertical = 24;
keypoints = nHorizontal * nVertical;
numLines = nHorizontal + nVertical;
imagePoints = zeros(keypoints, 2, numImages);
imageLines = zeros(numLines, 3, numImages);
for i=1:numImages
    filename = imagesFolder + "/" + baseFilename + "_" + string(i) + "." + ext;
    [imagePoints(:, :, i), imageLines(:, :, i)] = mark_image(filename, nHorizontal, nVertical, [], '');
end
close all;
% Save calibration point image coordinates
calibrationZhang.imagePoints = imagePoints;
calibrationZhang.imageLines = imageLines;
calibrationZhang.keypoints = keypoints;
calibrationZhang.numLines = numLines;

% Save images size
I = imread(filename);
calibrationZhang.imageSize = size(I);
save("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat", "calibrationZhang");
%% [Optional Edit image coordinates
clc; clear; close all;
load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat");
imagesFolder = calibrationZhang.imagesFolder;
baseFilename = calibrationZhang.baseFilename;
ext = calibrationZhang.imageFormat;
imagePoints = calibrationZhang.imagePoints;
imageLines = calibrationZhang.imageLines;

% The pattern's keypoints are located on a (2x24) grid
nHorizontal = 2;
nVertical = 24;

numImage = 4; % Image number to edit

filename = imagesFolder + "/" + baseFilename + "_" + string(numImage) + "." + ext;
[imagePoints(:, :, numImage), imageLines(:, :, numImage)] = mark_image(filename, nHorizontal, nVertical, [], '');

close all;
% Save calibration point image coordinates
calibrationZhang.imagePoints = imagePoints;
save("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat", "calibrationZhang");
%% World Points
% Camera calibration recommendations
% https://fr.mathworks.com/help/vision/ug/prepare-camera-and-capture-images.html
clc; clear; close all;
load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat");

d1 = 1.8;           % stripe width
d2 = 1.5;           % inter-stripe length
d3 = 30;            % stripe length
L = 12 * (d1+d2);   % pattern width
L = 3.4 + 12*d1 + 10*d2;

values = zeros(1, 10);
values(1:2:end) = 1:5;
values(2:2:end) = 1:5;

coefs_d1 = [0, values, 6];
coefs_d2 = [0, 0, values];

% x coordinates of the corners of the first 6 stripes
xCorners = d1*coefs_d1' + d2*coefs_d2';

% x offset between the first corner of the first stripe and the first
% corner of the 7th stripe.
offset = 6*d1 + 7*d2;
offset = 6*d1 + 5*d2 + 3.4;

worldPoints = zeros(48, 2);
worldPoints(1:48, 1) = [xCorners; xCorners + offset; xCorners; xCorners + offset];
worldPoints(25:48, 2) = d3;

calibrationZhang.worldPoints = worldPoints;

% World Lines / World Lines Endpoints
worldLinesEndpoints = [1, 25, 1:24;...
                      24, 48, 25:48]';
ep_1 = worldPoints(1, :);
ep_24 = worldPoints(24, :);
ep_25 = worldPoints(25, :);
ep_48 = worldPoints(48, :);
worldLines = zeros(26, 3);
worldLines(1:2, :) = [homogenous_line([ep_1, 1], [ep_24, 1])';...
                      homogenous_line([ep_25, 1], [ep_48, 1])'];
for i=1:24
    ep_i = worldPoints(i, :);
    ep_ip24 = worldPoints(i+24, :);
    worldLines(i+2, :) = homogenous_line([ep_i, 1], [ep_ip24, 1])';
end

calibrationZhang.worldLinesEndpoints = worldLinesEndpoints;
calibrationZhang.worldLines = worldLines;

save("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat", "calibrationZhang");

%% Parameters estimations
clc; clear; close all;
load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat");
nPoints = calibrationZhang.keypoints;
worldPoints = calibrationZhang.worldPoints;
allImagePoints = calibrationZhang.imagePoints;
worldLines = calibrationZhang.worldLines;
worldLinesEndpoints = calibrationZhang.worldLinesEndpoints;
allImageLines = calibrationZhang.imageLines;
nImages = calibrationZhang.numImages;

% Homographies estimation
homographies = zeros(3, 3, nImages);
for i=1:nImages
    imagePoints = allImagePoints(:, :, i);
    imageLines = allImageLines(:, :, i);
    [homographies(:, :, i), condA, resnorm, ~, exitflag, output] = estimate_homography(...
        [worldPoints, ones(nPoints, 1)], [imagePoints, ones(nPoints, 1)],...
        worldLines, imageLines, worldLinesEndpoints,... 
        "point");

end

calibrationZhang.homographies = homographies;

% IAC
omega = estimate_iac(homographies);

% Intrinsic matrix
intrinsicMatrix0 = estimate_intrinsic_iac(omega, "direct");
calibrationZhang.intrinsicMatrix0 = intrinsicMatrix0;

% Extrinsic parameters
extrinsics0 = homographies2extrinsics(homographies, intrinsicMatrix0);
calibrationZhang.extrinsics0 = extrinsics0;

% Non linear optimization
p0 = zhang_matrices2params(intrinsicMatrix0, extrinsics0);
[p, resnorm, residual, exitflag, output] = ...
    refine_zhang_estimation(allImagePoints, worldPoints, p0);


[intrinsicMatrix, extrinsics] = zhang_params2matrices(p);
calibrationZhang.intrinsicMatrix = intrinsicMatrix;
calibrationZhang.extrinsics = extrinsics;

save("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat", "calibrationZhang");

%% Reprojections
clc; clear; close all;
load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat");

imagePoints = calibrationZhang.imagePoints;
worldPoints = calibrationZhang.worldPoints;
homographies = calibrationZhang.homographies;
nImages = calibrationZhang.numImages;
nPoints = calibrationZhang.keypoints;
imagesFolder = calibrationZhang.imagesFolder;
basename = calibrationZhang.baseFilename;
ext = calibrationZhang.imageFormat;

MRE = zeros(nImages, 4);
fig = figure;
t = 0.05;

% Homographies reprojections
for i=1:nImages
    h = homographies(:, :, i);
    imagePointsHat = image2image(h, worldPoints');
    imagePointsHat = imagePointsHat';   
    mre = sqrt(sum((imagePoints(:, :, i)-imagePointsHat).^2, 'all')/nPoints);
    MRE(i, 1) = mre;
    imshow(imagesFolder + "/" + basename + "_" + string(i) + "." + ext);
    hold on;
    plot(imagePoints(:, 1, i), imagePoints(:, 2, i), 'g+', "LineStyle", "none");
    plot(imagePointsHat(:, 1), imagePointsHat(:, 2), 'ro', "LineStyle", "none");
    hold off;
    legend("Measured image points", "Reprojected world points");
    title("MRE Homography " + string(i) + " : " + string(mre) + " pixels")
    pause(t);
    saveas(fig, "./Calibration/Zhang/Reprojection_Images/h_reproj_" + string(i) + ".png")
end

% Initial camera matrices reprojections
intrinsicMatrix0 = calibrationZhang.intrinsicMatrix0;
extrinsics0 = calibrationZhang.extrinsics0;
for i=1:nImages
    extrinsicMatrix = extrinsics2extrinsicMatrix(extrinsics0(:, i));
    cameraMatrix = intrinsicMatrix0 * extrinsicMatrix;
    imagePointsHat = world2image(cameraMatrix, [worldPoints, zeros(nPoints, 1)]');
    imagePointsHat = imagePointsHat';
    mre = sqrt(sum((imagePoints(:, :, i)-imagePointsHat).^2, 'all')/nPoints);
    MRE(i, 2) = mre;
    imshow(imagesFolder + "/" + basename + "_" + string(i) + "." + ext);
    hold on;
    plot(imagePoints(:, 1, i), imagePoints(:, 2, i), 'g+', "LineStyle", "none");
    plot(imagePointsHat(:, 1), imagePointsHat(:, 2), 'ro', "LineStyle", "none");
    hold off;
    legend("Measured image points", "Reprojected world points");
    title("MRE Initial Camera Matrix " + string(i) + " : " + string(mre) + " pixels")
    pause(t);
    saveas(fig, "./Calibration/Zhang/Reprojection_Images/icm_reproj_" + string(i) + ".png")
end

% Refined camera matrices reprojections
intrinsicMatrix = calibrationZhang.intrinsicMatrix;
extrinsics = calibrationZhang.extrinsics;
for i=1:nImages
    extrinsicMatrix = extrinsics2extrinsicMatrix(extrinsics(:, i));
    cameraMatrix = intrinsicMatrix * extrinsicMatrix;
    imagePointsHat = world2image(cameraMatrix, [worldPoints, zeros(nPoints, 1)]');
    imagePointsHat = imagePointsHat';
    mre = sqrt(sum((imagePoints(:, :, i)-imagePointsHat).^2, 'all')/nPoints);
    MRE(i, 3) = mre;
    imshow(imagesFolder + "/" + basename + "_" + string(i) + "." + ext);
    hold on;
    plot(imagePoints(:, 1, i), imagePoints(:, 2, i), 'g+', "LineStyle", "none");
    plot(imagePointsHat(:, 1), imagePointsHat(:, 2), 'ro', "LineStyle", "none");
    hold off;
    legend("Measured image points", "Reprojected world points");
    title("MRE Refined Camera Matrix " + string(i) + " : " + string(mre) + " pixels")
    pause(t);
    saveas(fig, "./Calibration/Zhang/Reprojection_Images/fcm_reproj_" + string(i) + ".png")
end

% Matlab camera matrices reprojection
imageSize = calibrationZhang.imageSize;
[cameraParameters, imageUsed, estimationErrors] = estimateCameraParameters(...
                imagePoints, worldPoints, 'WorldUnits', 'm', 'ImageSize', imageSize(1:2));
residuals = cameraParameters.ReprojectionErrors;
for i=1:nImages
    res = residuals(:, :, i);
    MRE(i, 4) = sqrt(sum(res.^2, 'all')/nPoints);
end

% Reprojections evolution
bar(MRE(:, 1:3))
%plot(MRE, '-o')
legend("Homographies", "Initial camera matrices", "Refined camera matrices")
xlabel("Image number")
xticks(1:nImages)
ylabel("Mean reprojection error (pixels)")
title("Reprojections errors evolution")
fig.WindowState = 'maximized';
pause(0.1)
saveas(fig, "./Calibration/Zhang/Reprojection_Images/reproj_evolution.png")

% Reprojections comparisons
bar(MRE(:, 3:4))
%plot(MRE, '-o')
legend("Custom estimation", "Matlab estimation")
xlabel("Image number")
xticks(1:nImages)
ylabel("Mean reprojection error (pixels)")
title("Reprojections errors comparison")
fig.WindowState = 'maximized';
pause(0.1)
saveas(fig, "./Calibration/Zhang/Reprojection_Images/reproj_comparison.png")
            
close all;


