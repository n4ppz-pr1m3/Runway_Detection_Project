clc; clear; close all;

% ----------------------------------------- Data processing
raw_airports_data = "SAMPLE_AIRPORT_DATA.xlsx";
filter_list = curated_airports;
runways_data = get_runways_data(raw_airports_data, filter_list);

% ----------------------------------------- Low Res Camera calibration
numImages = 5;
dpi = 30;
calibrationFolder = "Calibration_Low";
baseFilename = "calibration_image";
imageFormat = "png";
default_calibration = false;

calibration_data_low = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                 baseFilename, imageFormat, default_calibration);

% ----------------------------------------- High Res Camera calibration
numImages = 5;
dpi = 50;
calibrationFolder = "Calibration_Low";
baseFilename = "calibration_image";
imageFormat = "png";
default_calibration = false;

calibration_data_high = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                 baseFilename, imageFormat, default_calibration);

% ----------------------------------------- Low Res Dataset parameters
coord_type = "spherical";
param1 = [0, 90];
param2 = [30, 60];
param3 = [10000, 15000];

full_camera_locations = {coord_type, param1, param2, param3};

full_calibration_data = {calibration_data_low};

preDatasetFolder = "Pre_Dataset_Low_High";

datasetName = "Example_Dataset_Low";
datasetFolder = "Dataset_Low";
imagesFolder = "Images";
annotationsFolder = "Annotations";
masksFolder = "Masks";

render_times = [5, 2.5, 1];
basename = "apt_image_";
pad_value = 4;
validationFolder = "Validation_Low";
validation_ratio = 0.1;

full_airports_data = {runways_data};

generate_dataset(full_airports_data,...
                full_camera_locations,...
                full_calibration_data,...
                preDatasetFolder,...
                render_times, basename, pad_value,...
                datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder,...
                validationFolder, validation_ratio);


% ----------------------------------------- High Res Dataset parameters

updated_full_calibration_data = {calibration_data_high};

newDatasetName = "Example_Dataset_High";
newDatasetFolder = "Dataset_High";
newImagesFolder = "NEW_Images";
newAnnotationsFolder = "NEW_Annotations";
newMasksFolder = "NEW_Masks";


basename = "APT_IMG";
pad_value = 4;
newValidationFolder = "Validation_High";
validation_ratio = 0.15;


update_dataset(full_airports_data,...
                        updated_full_calibration_data,...
                        preDatasetFolder,...
                        basename, pad_value,...
                        newDatasetName, newDatasetFolder, newImagesFolder, newAnnotationsFolder, newMasksFolder,...
                        newValidationFolder, validation_ratio)