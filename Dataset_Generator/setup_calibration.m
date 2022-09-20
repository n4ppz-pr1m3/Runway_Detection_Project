function calibrationData = setup_calibration(numImages, dpi,...
                                             calibrationFolder,...
                                             baseFilename, imageFormat)


pdfImages = fullfile(calibrationFolder, "Original_PDF_Calibration_Images");
imagesFolder = fullfile(calibrationFolder, "Calibration_Images");
reprojectionsFolder = fullfile(calibrationFolder, "Reprojections_Images");
calibrationDataPath = fullfile(calibrationFolder, "calibrationData.mat");

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
calibrationData.imagePoints = [];
calibrationData.intrinsicMatrix = [];
calibrationData.fov = [];
calibrationData.residuals = [];
calibrationData.meanReprojectionError = [];


save(calibrationDataPath, "calibrationData");

end

