
% function show_reprojections(calibrationData)

% Vizualize the control point reprojections.

% The images are also saved in the reprojection folder specified in the
% calibration settings.

% Input :
% calibrationData (calibration data struct) : calibration settings

function show_reprojections(calibrationData)

close all;
disp(newline + "Computing reprojections errors")

numImages = calibrationData.numImages;
width = calibrationData.imageSize(2);
residuals = calibrationData.residuals;
errors = zeros(numImages, 1);
for i=1:numImages
    errors(i) = norm(residuals(i, 1));
end

imagesPoints = calibrationData.imagesPoints;
cameraPoints = calibrationData.cameraPoints;
intrinsicMatrix = calibrationData.intrinsicMatrix;
reprojectedImagesPoints = cameraPoints * intrinsicMatrix';
reprojectedImagesPoints = reprojectedImagesPoints(:, 1:2) ./ reprojectedImagesPoints(:, 3);

imagesFolder = calibrationData.imagesFolder;
reprojectionsFolder = calibrationData.reprojectionsFolder;
basename = calibrationData.baseFilename;
ext = calibrationData.imageFormat;
% fig = figure;
% fig.Visible = "off";
for i=1:numImages
    fig = figure;
    filename = fullfile(imagesFolder, basename + "_" + string(i) + "." + ext);
    reproj_filename = fullfile(reprojectionsFolder, "reproj_" + basename + "_" + string(i) + "." + ext);
    imshow(filename);
    hold on;
    plot(imagesPoints(i, 1), imagesPoints(i, 2), 'r+');
    plot(reprojectedImagesPoints(i, 1), reprojectedImagesPoints(i, 2), 'go');
    hold off;
    if imagesPoints(i, 1) >= width/2
        lcn = "northwest";
    else
        lcn = "northeast";
    end
    legend("Original calibration point", "Reprojected calibration point", "Location", lcn);
    title("Reprojection error : " + string(errors(i)) + " pixels");
    saveas(fig, reproj_filename);
end
%close(fig)
close all;
disp("Done")

end

