
% function generate_dataset(full_airports_data,...
%                         full_camera_locations,...
%                         full_calibration_data,...
%                         preDatasetFolder,...
%                         render_times, basename, pad_value,...
%                         datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder,...
%                         validationFolder, validation_ratio)

% Creates a new dataset from scratch.

% Initially, a pre-dataset made of source pdf images and raw labels data is
% produced. Afterwards, the pre-dataset is converted to Pascal VOC, the only
% currently supported format.

% The heterogenous pre-dataset is assembled from a set of homogenous pre-datasets.
% Each pre-dataset is produced with specific calibration setting meaning that all
% the images have identical size and format.

% render_times is a 3-vector specifying :
% - The initial render delay
% - The delay associated with each new airport
% - The delay between each camera location

% When non zero, validation_ratio specifies the proportion of each
% sub-dataset that will be randomly sampled for validation. The selected
% images will be saved in validationFolder with labels drawn on them.

% Input :
% full_airports_data (N 1-d cell array of airports data struct) : airports data associated with each sub-dataset
% full_calibration_data (N 1-d cell array of calibration data struct) : calibration data associated with each sub-dataset
% preDatasetFolder (string) : path to the pre-dataset folder
% render_times (3 1-d double array) : render times
% basename (string) : base dataset filenames
% pad_value (integer) : padding value for files indexing
% datasetName (string) : dataset name
% datasetFolder (string) : path to the dataset folder
% imagesFolder (string) : dataset images folder name
% annotationsFolder (string) : dataset annotations folder name
% masksFolder (string) : dataset masks folder name
% validationFolder (string) : path to the validation folder
% validation_ratio (double) : sampling rate used for validation

function generate_dataset(full_airports_data,...
                        full_camera_locations,...
                        full_calibration_data,...
                        preDatasetFolder,...
                        render_times, basename, pad_value,...
                        datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder,...
                        validationFolder, validation_ratio)

disp("------------------------------ Creating new dataset --------------------------------------------" + newline)

% Pre dataset
tic                               
disp("Generating pre-dataset..." + newline)                      
[full_labels_data, ~, dataset_size] = generate_heterogenous_predataset(full_airports_data,...
                                                        full_camera_locations,...
                                                        full_calibration_data,...
                                                        preDatasetFolder,...
                                                        render_times, pad_value);
disp("Pre-dataset done. " + string(dataset_size) + " pdf images created.");
toc

% Conversion to PASCAL VOC
tic
disp(newline + "Converting pre-dataset to PASCAL VOC...");
% Saves labels used
save_labels(preDatasetFolder, datasetName);

% Conversion
pdfImagesFolder = get_pdfImagesFolder(preDatasetFolder);
to_PASCAL_VOC(full_calibration_data, full_labels_data, pdfImagesFolder,...
                datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder, basename)
disp(newline + "Conversion done." + newline + "Dataset successfully created at " + fullfile(datasetFolder));
toc

% Validates dataset
tic
validate_dataset(validationFolder, validation_ratio,...
    full_labels_data, fullfile(datasetFolder, imagesFolder));
toc
end

