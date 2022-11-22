
% function calibration_data = setup_calibration(numImages, dpi,...
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
% calibration_data(calibration_data struct) : calibration settings

function calibration_data = setup_calibration(numImages, dpi,...
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
calibration_data = [];
calibration_data.file = calibrationDataPath;
calibration_data.numImages = numImages;
calibration_data.baseFilename = baseFilename;
calibration_data.imageFormat = imageFormat;
calibration_data.imageSize = [];
calibration_data.cropValue = [];
calibration_data.dpi = string(dpi);
calibration_data.pdfImagesFolder = pdfImages;
calibration_data.imagesFolder = imagesFolder;
calibration_data.reprojectionsFolder = reprojectionsFolder;
calibration_data.cameraPoints = [];
calibration_data.imagesPoints = [];
calibration_data.intrinsicMatrix = [];
calibration_data.fov = [];
calibration_data.residuals = [];
calibration_data.meanReprojectionError = [];

save(calibrationDataPath, "calibration_data");

end

