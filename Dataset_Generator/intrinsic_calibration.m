function calibrationData = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                baseFilename, imageFormat)

calibrationData = setup_calibration(numImages, dpi, calibrationFolder,...
                                baseFilename, imageFormat);
calibrationData = generate_pdf_calibration_images(calibrationData);
calibrationData = convert_pdf_calibration_images(calibrationData);
calibrationData = measure_images_points(calibrationData);
calibrationData = estimate_intrinsic(calibrationData);
pause(0.1);

% Fine tuning
while true
    prompt = "Enter an integer in the range 1-" + string(numImages) + " to edit the corresponding image or press Return to quit: ";
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

end

