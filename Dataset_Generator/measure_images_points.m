function calibrationData = measure_images_points(currentCalibrationData)

calibrationData = currentCalibrationData;

imagesFolder = calibrationData.imagesFolder;
baseFilename = calibrationData.baseFilename;
ext = calibrationData.imageFormat;
numImages = calibrationData.numImages;

imagePoints = zeros(numImages, 2);
for i=1:numImages
    filename = imagesFolder + "/" + baseFilename + "_" + string(i) + "." + ext;
    %imagePoints(i, :) = mark_image(filename, 1, 1, [], '');
    imagePoints(i, :) = mark_point(filename, 0.025);
end

% Calibration points images coordinates
calibrationData.imagePoints = imagePoints;

% Images size
image = imread(filename);
calibrationData.imageSize = size(image);

save(calibrationData.file, "calibrationData");





end

