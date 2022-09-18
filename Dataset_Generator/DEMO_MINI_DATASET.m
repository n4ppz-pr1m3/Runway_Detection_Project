clc; clear; close all;

% Sample data --------------------------------------------------------
load("runwayData.mat");
airports_data = runwayData;

airports = string(fieldnames(airports_data));
airports = airports([4, 9, 11]);

data = [];
for i=1:numel(airports)
    data.(airports(i)) = airports_data.(airports(i));
end
airports_data = data;
% ----------------------------------------------------------------------

param1 = [0, 30];
param2 = [30, 30];
param3 = [10000, 15000];
coord_type = "spherical";

load("./Calibration/Intrinsic/calibrationIntrinsic.mat");

preDatasetFolder = "./Pre_Dataset";
pdfImagesFolder = "./Pre_Dataset/PDF_Images";

imagesFolder = "./Dataset/PNGImages";
annotationFolder = "./Dataset/Annotation";
masksFolder = "./Dataset/RwyMasks";

basename = "apt_image_";

N = generate_dataset(airports_data,...
                param1, param2, param3, coord_type,...
                calibrationIntrinsic,...
                preDatasetFolder, pdfImagesFolder,...
                imagesFolder, annotationFolder, masksFolder,...
                basename, 0);
            
generate_dataset(airports_data,...
                param1, param2, param3, coord_type,...
                calibrationIntrinsic,...
                preDatasetFolder, pdfImagesFolder,...
                imagesFolder, annotationFolder, masksFolder,...
                basename, N)