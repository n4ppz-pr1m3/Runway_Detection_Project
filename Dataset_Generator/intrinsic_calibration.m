function calibrationData = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                baseFilename, imageFormat, default_calibration)

if ~exist("default_calibration", "var")
    default_calibration = true;
end

calibrationData = setup_calibration(numImages, dpi, calibrationFolder,...
                                baseFilename, imageFormat);
calibrationData = generate_pdf_calibration_images(calibrationData);
calibrationData = convert_pdf_calibration_images(calibrationData);
calibrationData = measure_images_points(calibrationData);
calibrationData = estimate_intrinsic(calibrationData);
pause(0.1);

disp("Fine tuning estimation")
while true
    disp(['Enter an integer to edit the corresponding image coordinates and   ';...
          're-estimate the parameters or press Return to keep the current ones']);
    prompt = "Image index [1-" + string(numImages) + "] : ";
    image_index = input(prompt);
    if isempty(image_index)
        image_index = 0;
    end

    if (image_index >= 1) && (image_index <= numImages)
        close all;
        calibrationData = measure_images_points(calibrationData, image_index);
        calibrationData = estimate_intrinsic(calibrationData);
        pause(0.1);
    else
        break;
    end
end
show_reprojections(calibrationData)

disp(newline + "Calibration complete")
disp("Calibration data saved to " + calibrationData.file)

if default_calibration
    save("CalibrationData.mat", "calibrationData")
    disp("Calibration set to default. Saving calibration data to local workspace")
end

end

