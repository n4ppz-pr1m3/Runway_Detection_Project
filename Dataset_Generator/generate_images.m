
% function generate_images(calibration_data, pdfImagesFolder, tmpFolder, imagesFolder, basename, check_dir)

% Converts source pdf images to target image format and size specified by
% the calibration settings.

% The pdf images are first being converted into a temporary folder before
% being moved and renamed into the target folder.

% Input :
% calibration_data (calibration data struct) : calibration settings
% pdfImagesFolder (string) : path to the source pdf images folder
% tmpFolder (string) : path to the temporary folder
% imagesFolder (string) : path to the destination folder
% basename (string) : base dataset filenames
% check_dir (boolean) : specifies if a folder needs to be created

function generate_images(calibration_data, pdfImagesFolder, tmpFolder, imagesFolder, basename, check_dir)

if check_dir && ~mkdir(".", imagesFolder)
    error("Unable to create " + imagesFolder);
end

% Images conversion
disp(newline + "Converting images...")
imageFormat = calibration_data.imageFormat;
dpi = calibration_data.dpi;
cropValue = calibration_data.cropValue;

cmd = "mogrify -format " + imageFormat + " -path " + tmpFolder + ...
    " -density " + dpi + " -depth 8 -quality 100 -gravity South -chop 0x" +...
    cropValue + " " + pdfImagesFolder + "/*.pdf";

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
    disp("... done")
end

% Images renaming
disp("Renaming images...")
[~, images_names, ext] = get_names(tmpFolder);
for i=1:numel(images_names)
    name = fullfile(tmpFolder, strcat(images_names{i}, ext{i}));
    new_name = fullfile(imagesFolder, strcat(basename, images_names{i}, ext{i}));
    [status, msg] = movefile(name, new_name);
    if status
        disp(msg)
    end
end
disp("... done")

end

