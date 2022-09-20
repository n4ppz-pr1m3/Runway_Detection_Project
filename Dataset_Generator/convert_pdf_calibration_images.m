function calibrationData = convert_pdf_calibration_images(currentCalibrationData)

calibrationData = currentCalibrationData;

sourceFolder = calibrationData.pdfImagesFolder;
destinationFolder = calibrationData.imagesFolder;
baseFilename = calibrationData.baseFilename;
imageFormat = calibrationData.imageFormat;
dpi = calibrationData.dpi;

disp(newline + "Converting pdf calibration images to " + imageFormat)

% Estimates crop
test_file = fullfile(sourceFolder, baseFilename + "_1.pdf");
cmd = "convert -density " + dpi + " -depth 8 -quality 100 " + test_file + " tmp.png";

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
    image = imread("tmp.png");
    cropValue = string(ceil(1e-2 * size(image, 1)));
    calibrationData.cropValue = cropValue;
    save(calibrationData.file, "calibrationData");
    disp('Crop estimation done')
end

% Images conversion
disp("Converting images...")
cmd = "mogrify -format " + imageFormat + " -path " + destinationFolder + ...
    " -density " + string(dpi) + " -depth 8 -quality 100 -gravity South -chop 0x" +...
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