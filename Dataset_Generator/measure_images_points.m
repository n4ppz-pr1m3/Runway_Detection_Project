function calibrationData = measure_images_points(currentCalibrationData, varargin)

calibrationData = currentCalibrationData;

imagesFolder = calibrationData.imagesFolder;
baseFilename = calibrationData.baseFilename;
ext = calibrationData.imageFormat;
numImages = calibrationData.numImages;

if nargin == 1
    % Measure all calibration points images coordinates
    imagesPoints = zeros(numImages, 2);
    for i=1:numImages
        filename = fullfile(imagesFolder, baseFilename + "_" + string(i) + "." + ext);
        %imagesPoints(i, :) = mark_image(filename, 1, 1, [], '');
        imagesPoints(i, :) = mark_point(filename, 0.025);
    end

    % Images size
    image = imread(filename);
    calibrationData.imageSize = size(image);
else
    % Edit a single measurement
    image_index = varargin{1};
    imagesPoints = calibrationData.imagesPoints;
    filename = fullfile(imagesFolder, baseFilename + "_" + string(image_index) + "." + ext);
    imagesPoints(image_index, :) = mark_point(filename, 0.025);
end

% Calibration points images coordinates
calibrationData.imagesPoints = imagesPoints;

save(calibrationData.file, "calibrationData");





end

