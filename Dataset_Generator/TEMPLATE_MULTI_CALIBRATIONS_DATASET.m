clc; clear; close all;

% ----------------------------------------- Data processing
raw_airports_data = "SAMPLE_AIRPORT_DATA.xlsx";
filter_list = curated_airports;
runways_data = get_runways_data(raw_airports_data, filter_list);

% ----------------------------------------- First Camera calibration
numImages = 5;
dpi = 50;
calibrationFolder = "Multi_Calibration_1";
baseFilename = "calibration_image";
imageFormat = "png";
default_calibration = false;

calibration_data_1 = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                 baseFilename, imageFormat, default_calibration);

% ----------------------------------------- Second Camera calibration
numImages = 5;
dpi = 60;
calibrationFolder = "Multi_Calibration_2";
baseFilename = "calibration_image";
imageFormat = "jpg";
default_calibration = false;

calibration_data_2 = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                 baseFilename, imageFormat, default_calibration);


% ----------------------------------------- Dataset parameters
coord_type = "spherical";
param1 = [0, 180];
param2 = [30, 60];
param3 = [10000, 15000];

full_camera_locations = {coord_type, param1,    param2,    param3;...      % Parameters sub-dataset 1
                         coord_type, param1+90, param2+20, param3;...      %       -    sub-dataset 2
                         coord_type, param1-45, param2,    param3};        %       -    sub-dataset 3 

full_calibration_data = {calibration_data_1,...                            % Calibration sub-dataset 1
                         calibration_data_2,...                            %       -     sub-dataset 2
                         calibration_data_2};                              %       -     sub-dataset 3

preDatasetFolder = "Pre_Dataset_Multi";

datasetName = "Example_Dataset_Multi";
datasetFolder = "Dataset_Multi";
imagesFolder = "Images";
annotationsFolder = "Annotations";
masksFolder = "Masks";

render_times = [5, 2.5, 1];
basename = "apt_image_";
pad_value = 4;
validationFolder = "Validation_Multi";
validation_ratio = 0.1;

full_airports_data = {runways_data, runways_data, runways_data};

generate_dataset(full_airports_data,...
                 full_camera_locations,...
                 full_calibration_data,...
                 preDatasetFolder,...
                 render_times, basename, pad_value,...
                 datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder,...
                 validationFolder, validation_ratio);