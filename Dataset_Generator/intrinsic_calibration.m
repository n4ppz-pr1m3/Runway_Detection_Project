% function calibrationData = intrinsic_calibration(numImages, dpi, calibrationFolder,...
%                                 baseFilename, imageFormat, default_calibration)

% Interactive application to perform camera calibration.

% Calibration procedure
% Estimates the intrinsic parameters of a camera by using multiple views of
% a single control point with known camera and image coordinates.

% Pipeline
% 0 - Calibration parameters initialization
% 1a - Calibration images generation in pdf format
% 1b - Camera coordinates computation
% 2 - Calibration images conversion in target size and format
% 3 - Images coordinates computation
% 4 - [Optional] Re-computation of selected image coordinates
% 5 - Intrinsic parameters estimation

% Step 3 being a manual process, multiple iterations of step 4 followed by
% step 5 might be necessary for accurate estimations.

% The only way to specify the target image size is via the dpi (dot per inch).
% For a "natural" rendering, a value of 96 is recommended. Higher values
% will lead to higher resolutions (but at the cost of image quality) and
% vice versa.

% If default_calibration is set to true, in addition to being saved in
% calibrationFolder, calibrationData will be saved in the local workspace.

% Input :
% numImages (integer) : number of images to perform calibration
% dpi (integer) : dpi used for converting source pdf images
% calibrationFolder (string) : calibration folder path
% baseFilename (string) : calibration images basename
% imageFormat (string) : target image format
% default_calibration (boolean) : set the calibration settings as default

% Output :
% calibrationData (calibration data struct) : calibration settings

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
% Visualize reprojections
show_reprojections(calibrationData)

disp(newline + "Calibration complete")
disp("Calibration data saved to " + calibrationData.file)

if default_calibration
    save("CalibrationData.mat", "calibrationData")
    disp("Calibration set to default. Saving calibration data to local workspace")
end

end

