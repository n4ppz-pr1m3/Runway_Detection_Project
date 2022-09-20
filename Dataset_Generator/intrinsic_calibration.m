function calibrations = intrinsic_calibration(calibrations_parameters)

nCalibrations = numel(calibrations_parameters);
calibrations = cell(nCalibrations, 1);
for i=1:nCalibrations
    calibration_parameters = calibrations_parameters{i};
    numImages = calibration_parameters.numImages;
    dpi = calibration_parameters.dpi;
    calibrationFolder = calibration_parameters.calibrationFolder;
    baseFilename = calibration_parameters.baseFilename;
    imageFormat = calibration_parameters.imageFormat;

    calibrationData = setup_calibration(numImages, dpi, calibrationFolder,...
                                    baseFilename, imageFormat);
    calibrationData = generate_pdf_calibration_images(calibrationData);
    calibrationData = convert_pdf_calibration_images(calibrationData);
    calibrationData = measure_images_points(calibrationData);
    calibrationData = estimate_intrinsic(calibrationData);
    show_reprojections(calibrationData)

    calibrations{i} = calibrationData;
end
end

