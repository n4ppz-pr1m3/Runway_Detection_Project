
% function calibration_data = generate_pdf_calibration_images(currentCalibrationData)

% Interactive application to generate pdf calibration images.

% In addition, calibration settings are updated with the control point
% camera coordinates for each image.

% Input :
% currentCalibrationData (calibration data struct) : input calibration settings

% Output :
% calibration_data (calibration data struct) : updated calibration settings

function calibration_data = generate_pdf_calibration_images(currentCalibrationData)

disp("Generating pdf calibration images and calibration points camera coordinates")

calibration_data = currentCalibrationData;

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
numImages = calibration_data.numImages;
baseFilename = calibration_data.baseFilename;
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

    % Camera coordinates
    worldTransform = z_extrinsic_matrix(cameraPose, worldPose);
    cameraPoints(i, :) = (worldTransform * [worldPoint; 1])';
 
    % Saves image
    pdfImages = calibration_data.pdfImagesFolder;
    filename = fullfile(pdfImages, baseFilename + "_" + string(i) + ".pdf");
    exportapp(fig, filename);
end
close(fig)

calibration_data.cameraPoints = cameraPoints;
save(calibration_data.file, "calibration_data");

end

