
% function calibrationData = setup_calibration(numImages, dpi,...
%                                              calibrationFolder,...
%                                              baseFilename, imageFormat)

% Initialize the calibration settings before performing camera calibration.

% Input :
% numImages (integer) : number of images required for the calibration
% dpi (integer) : dpi value used when converting pdf calibration images
% calibrationFolder (string) : calibration folder name
% baseFilename (string) : base calibration image name
% imageFormat (string) : target image format

% Output :
% calibrationData (calibration data struct) : calibration settings

function calibrationData = setup_calibration(numImages, dpi,...
                                             calibrationFolder,...
                                             baseFilename, imageFormat)


if isempty(calibrationFolder)
    calibrationFolder = "Calibration";
end

pdfImages = fullfile(calibrationFolder, "Original_PDF_Calibration_Images");
imagesFolder = fullfile(calibrationFolder, "Calibration_Images");
reprojectionsFolder = fullfile(calibrationFolder, "Reprojections_Images");
calibrationDataPath = fullfile(calibrationFolder, "calibration_data.mat");

if ~mkdir(".", calibrationFolder)
    error("Unable to create " + calibrationFolder);
end

if ~mkdir(".", pdfImages)
    error("Unable to create " + pdfImages);
end

if ~mkdir(".", imagesFolder)
    error("Unable to create " + imagesFolder);
end

if ~mkdir(".", reprojectionsFolder)
    error("Unable to create " + reprojectionsFolder);
end

disp(newline + "---------------------------- Starting new calibration -------------------------------------" + newline)

% Calibration settings
calibrationData = [];
calibrationData.file = calibrationDataPath;
calibrationData.numImages = numImages;
calibrationData.baseFilename = baseFilename;
calibrationData.imageFormat = imageFormat;
calibrationData.imageSize = [];
calibrationData.cropValue = [];
calibrationData.dpi = string(dpi);
calibrationData.pdfImagesFolder = pdfImages;
calibrationData.imagesFolder = imagesFolder;
calibrationData.reprojectionsFolder = reprojectionsFolder;
calibrationData.cameraPoints = [];
calibrationData.imagesPoints = [];
calibrationData.intrinsicMatrix = [];
calibrationData.fov = [];
calibrationData.residuals = [];
calibrationData.meanReprojectionError = [];

save(calibrationDataPath, "calibrationData");

end

