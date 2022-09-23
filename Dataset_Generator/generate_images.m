function generate_images(calibration_data, pdfImagesFolder, tmpFolder, imagesFolder, basename, check_dir)

if check_dir && ~mkdir(".", imagesFolder)
    error("Unable to create " + imagesFolder);
end


% Images conversion
disp("Converting images...")
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
tic
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
toc

end

