function generate_images(pdfImagesFolder, imagesFolder, imageFormat, cropValue, dpi)

if ~mkdir(".", imagesFolder)
    error("Unable to create " + imagesFolder);
end

if ~exist("dpi", "var")
    dpi = 96;
end

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

