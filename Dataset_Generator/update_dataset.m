function update_dataset(full_airports_data,...
                        updated_full_calibration_data,...
                        preDatasetFolder, pdfImagesFolder,...
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
to_PASCAL_VOC(updated_full_calibration_data, updated_full_labels_data, pdfImagesFolder,...
                newDatasetName, newDatasetFolder, newImagesFolder, newAnnotationsFolder, newMasksFolder, basename)
disp(newline + "Conversion done." + newline + "New dataset successfully created at " + fullfile(newDatasetFolder));
toc

% Validate labels
tic
validate_labels(newValidationFolder, validation_ratio,...
    updated_full_labels_data, updated_full_calibration_data, fullfile(newDatasetFolder, newImagesFolder));
toc
end
