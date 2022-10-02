
% function calibrationData = measure_images_points(currentCalibrationData, varargin)

% Interactive application to measure control point coordinates on the
% images used to perform a calibration.

% Calibration settings are updated with control point image coordinates.

% By default, the coordinates from all the images are measured unless a
% specific image index is provided.

% Input :
% currentCalibrationData (calibration data struct) : input calibration settings
% varargin{1} := image_index (integer) : target image to get coordinates from

% Output :
% calibrationData (calibration data struct) : updated calibration settings

function calibrationData = measure_images_points(currentCalibrationData, varargin)

calibrationData = currentCalibrationData;

imagesFolder = calibrationData.imagesFolder;
baseFilename = calibrationData.baseFilename;
ext = calibrationData.imageFormat;
numImages = calibrationData.numImages;

if nargin == 1
    % Measure all calibration points images coordinates
    disp(['Measuring calibration points images coordinates                                                    ';...
          'Measurement procedure :                                                                            ';...
          'Click on the red calibration point to set up 2 orthogonal lines                                    ';...
          '[OPTIONAL] Zoom-in on the calibration point and use the arrow keys to fine-tune the lines location ';...
          'Press Return to register the calibration point image coordinates as the intersection of the 2 lines'])
    imagesPoints = zeros(numImages, 2);
    for i=1:numImages
        filename = fullfile(imagesFolder, baseFilename + "_" + string(i) + "." + ext);
        %imagesPoints(i, :) = mark_image(filename, 1, 1, [], '');
        imagesPoints(i, :) = mark_point(filename, 0.025);
    end

    % Images size
    image = imread(filename);
    calibrationData.imageSize = size(image);
    disp("Measurements done" + newline)
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

