
% function calibration_data = convert_pdf_calibration_images(currentCalibrationData)

% Converts pdf calibration images to target image size and format specified
% in calibration data

% Input :
% currentCalibrationData (calibration struct) : input calibration data

% Output :
% calibration_data (calibration struct) : updated calibration data

function calibration_data = convert_pdf_calibration_images(currentCalibrationData)

calibration_data = currentCalibrationData;

sourceFolder = calibration_data.pdfImagesFolder;
destinationFolder = calibration_data.imagesFolder;
baseFilename = calibration_data.baseFilename;
imageFormat = calibration_data.imageFormat;
dpi = calibration_data.dpi;

disp(newline + "Converting pdf calibration images to " + imageFormat)

% Estimates crop
test_file = fullfile(sourceFolder, baseFilename + "_1.pdf");
tmp_img = "tmp." + imageFormat;
cmd = "convert -density " + dpi + " -depth 8 -quality 100 " + test_file + " " + tmp_img;

% Linux
if isunix
    status = system(cmd);
% Windows
elseif ispc
    status = system("magick " + cmd);
end
if status
    disp('Conversion error')
else
    image = imread(tmp_img);
    cropValue = string(ceil(1e-2 * size(image, 1)));
    calibration_data.cropValue = cropValue;
    save(calibration_data.file, "calibration_data");
    disp('Crop estimation done')
end

% Images conversion
disp("Converting images...")
cmd = "mogrify -format " + imageFormat + " -path " + destinationFolder + ...
    " -density " + dpi + " -depth 8 -quality 100 -gravity South -chop 0x" +...
    cropValue + " " + sourceFolder + "/*.pdf";

% Linux
if isunix
    status = system(cmd);
% Windows
elseif ispc
    status = system("magick " + cmd);
end

if status
    disp('Conversion error')
else
    disp("Conversion done" + newline)
end

end