clc; clear; close all;

load("./Calibration/Intrinsic/Calibration_Data/calibrationIntrinsic.mat");
load("./Debug/runwayData.mat");

intrinsicMatrix = calibrationIntrinsic.intrinsicMatrix;
imageSize = [1006, 1920];

airports = string(fieldnames(runwayData));
airports = airports(2:11);

param1 = 0:45:315;
param2 = 29.5:30:90;
param3 = [5000, 10000];
coord_type = "spherical";

imagesFolder = "./Dataset/PNGImages";
masksFolder = "./Dataset/RunwaysMasks";
basename = "airport_image_";

fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig); 

offset = 0;

runways_labels = [];

for i=1:numel(airports)
    airport_data = runwayData.(airports(i));
    [labels, images_names] = update_pre_dataset(airport_data, intrinsicMatrix,...
        imageSize,...
        param1, param2, param3, coord_type,...
        imagesFolder, masksFolder, basename, offset,...
        g, fig);
    
    nImages = size(labels, 1);
    for j=1:nImages
        fieldname = images_names(j);
        runways_labels.(fieldname) = labels(j, :);
    end
    offset = offset + nImages;
end
close(fig)
save("./Debug/runways_labels.mat", "runways_labels");

to_PASCAL_VOC(runways_labels, "./Dataset/Annotation", masksFolder);
