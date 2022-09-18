function generate_images(pdfImagesFolder, imagesFolder, calibration_data, check_dir)

if check_dir && ~mkdir(".", imagesFolder)
    error("Unable to create " + imagesFolder);
end

imageFormat = calibration_data.imageFormat;
dpi = calibration_data.dpi;
cropValue = calibration_data.cropValue;

cmd = "mogrify -format " + imageFormat + " -path " + imagesFolder + ...
    " -density " + string(dpi) + " -depth 8 -quality 100 -gravity South -chop 0x" +...
    string(cropValue) + " " + pdfImagesFolder + "/*.pdf";

% Linux
if isunix
    status = system(cmd);
    
% Windows
elseif ispc
    status = system("magick " + cmd);
end

if status
    disp('Conversion error')
end

end

