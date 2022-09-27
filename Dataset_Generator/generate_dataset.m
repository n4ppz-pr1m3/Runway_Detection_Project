function generate_dataset(full_airports_data,...
                        full_camera_locations,...
                        full_calibration_data,...
                        preDatasetFolder, pdfImagesFolder,...
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
                                                        preDatasetFolder, pdfImagesFolder,...
                                                        render_times, pad_value);
disp("Pre-dataset done. " + string(dataset_size) + " pdf images created.");
toc

% Conversion to PASCAL VOC
tic
disp(newline + "Converting pre-dataset to PASCAL VOC...");
% Saves labels used
save_labels(preDatasetFolder, datasetName);

% Conversion
to_PASCAL_VOC(full_calibration_data, full_labels_data, pdfImagesFolder,...
                datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder, basename)
disp(newline + "Conversion done." + newline + "Dataset successfully created at " + fullfile(datasetFolder));
toc

% Validate labels
tic
validate_labels(validationFolder, validation_ratio,...
    full_labels_data, full_calibration_data, fullfile(datasetFolder, imagesFolder));
toc
end

