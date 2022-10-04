
% function update_dataset(full_airports_data,...
%                         updated_full_calibration_data,...
%                         preDatasetFolder,...
%                         basename, pad_value,...
%                         newDatasetName, newDatasetFolder, newImagesFolder, newAnnotationsFolder, newMasksFolder,...
%                         newValidationFolder, validation_ratio)

% Creates a new dataset from an existing one.

% The only difference allowed between the new dataset and the existing one
% are the calibration settings. Airports used and camera views remain
% identical. This allows the creation of an identical dataset with
% different images sizes/formats.

% The pdf source images being reused, their generation is skipped making
% the dataset creation faster than building it from scratch. Time is mostly
% spent on the images conversion to the new target sizes and formats.

% Input :
% full_airports_data (N 1-d cell array of airports data struct) : airports data associated with each sub-dataset
% updated_full_calibration_data (N 1-d cell array of calibration data struct) : new calibration data associated with each sub-dataset
% preDatasetFolder (string) : path to the pre-dataset folder
% basename (string) : base dataset filenames
% pad_value (integer) : padding value for files indexing
% newDatasetName (string) : new dataset name
% newDatasetFolder (string) : new dataset folder path
% newImagesFolder (string) :  new dataset images folder name
% newAnnotationsFolder (string) : new dataset annotations folder name
% newMasksFolder (string) : new dataset masks folder name
% newValidationFolder (string) : new validation folder path
% validation_ratio (double) : sampling rate used for validation

function update_dataset(full_airports_data,...
                        updated_full_calibration_data,...
                        preDatasetFolder,...
                        basename, pad_value,...
                        newDatasetName, newDatasetFolder, newImagesFolder, newAnnotationsFolder, newMasksFolder,...
                        newValidationFolder, validation_ratio)

disp("--------------------------- Updating existing dataset --------------------------------")

% Pre dataset labels update
tic                               
disp("Updating pre-dataset labels ..." + newline)                      
updated_full_labels_data = update_heterogenous_predataset_labels(full_airports_data,...
                                                            updated_full_calibration_data,...
                                                            preDatasetFolder,...
                                                            pad_value);
disp(newline + "Update complete")
toc

% Saves labels used
save_labels(preDatasetFolder, newDatasetName);

% Conversion to PASCAL VOC
tic
disp(newline + "Converting pre-dataset to PASCAL VOC..." + newline);
pdfImagesFolder = get_pdfImagesFolder(preDatasetFolder);
to_PASCAL_VOC(updated_full_calibration_data, updated_full_labels_data, pdfImagesFolder,...
                newDatasetName, newDatasetFolder, newImagesFolder, newAnnotationsFolder, newMasksFolder, basename)
disp(newline + "Conversion done." + newline + "New dataset successfully created at " + fullfile(newDatasetFolder));
toc

% Validates dataset
tic
validate_dataset(newValidationFolder, validation_ratio,...
    updated_full_labels_data, fullfile(newDatasetFolder, newImagesFolder));
toc
end
