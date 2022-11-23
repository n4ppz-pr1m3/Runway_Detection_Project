clc; clear; close all;

% ----------------------------------------- Data processing
raw_airports_data = "SAMPLE_AIRPORT_DATA.xlsx";
filter_list = curated_airports;
runways_data = get_runways_data(raw_airports_data, filter_list);

% ----------------------------------------- Camera calibration
numImages = 5;
dpi = 94;
calibrationFolder = "Mono_Calibration";
baseFilename = "calibration_image";
imageFormat = "jpg";
default_calibration = false;

calibration_data = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                 baseFilename, imageFormat, default_calibration);

% ----------------------------------------- Dataset parameters
coord_type = "spherical";
param1 = [0, 90];
param2 = [30, 60];
param3 = [10000, 15000];

full_camera_locations = {coord_type, param1, param2, param3};

full_calibration_data = {calibration_data};

preDatasetFolder = "Pre_Dataset_Mono";

datasetName = "Example_Dataset_Mono";
datasetFolder = "Dataset_Mono";
imagesFolder = "Images";
annotationsFolder = "Annotations";
masksFolder = "Masks";

render_times = [5, 2.5, 1];
basename = "apt_image_";
pad_value = 4;
validationFolder = "Validation_Mono";
validation_ratio = 0.1;

full_airports_data = {runways_data};

generate_dataset(full_airports_data,...
                full_camera_locations,...
                full_calibration_data,...
                preDatasetFolder,...
                render_times, basename, pad_value,...
                datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder,...
                validationFolder, validation_ratio);