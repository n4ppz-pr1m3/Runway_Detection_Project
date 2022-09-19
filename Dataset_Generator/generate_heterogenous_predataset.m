function [dataset_size, full_labels_data] = generate_heterogenous_predataset(full_airports_data,...
                                                        full_camera_locations,...
                                                        full_calibrationData,...
                                                        preDatasetFolder, pdfImagesFolder,...
                                                        wait_times, basename)
                                         
offset = 0;
nSubDatasets = numel(full_airports_data);
full_labels_data = cell(nSubDatasets, 1);
for i=1:nSubDatasets
    disp("Generating sub-dataset " + string(i));
    airports_data = full_airports_data{i};
    coord_type = full_camera_locations{i, 1};
    param1 = full_camera_locations{i, 2};
    param2 = full_camera_locations{i, 3};
    param3 = full_camera_locations{i, 4};
    calibrationData = full_calibrationData{i};
    check_dir = (i == 1);
    [sub_dataset_size, full_labels_data{i}] = generate_homogenous_predataset(airports_data,...
                                                            coord_type, param1, param2, param3,...
                                                            calibrationData,...
                                                            preDatasetFolder, pdfImagesFolder,...
                                                            wait_times, basename, offset, check_dir);
                                                        
    disp(string(sub_dataset_size) + " pdf images produced for sub-dataset " + string(i) + newline);
    offset = offset + sub_dataset_size;
end

dataset_size = offset;

% DEBUG
save("Pre_Dataset\full_labels_data.mat", "full_labels_data");

end

