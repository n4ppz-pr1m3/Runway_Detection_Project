function [full_labels_data, full_poses_data, dataset_size] = generate_heterogenous_predataset(full_airports_data,...
                                                            full_camera_locations,...
                                                            full_calibrationData,...
                                                            preDatasetFolder, pdfImagesFolder,...
                                                            render_times, basename)
                                         
offset = 0;
nSubDatasets = numel(full_airports_data);
full_labels_data = cell(nSubDatasets, 1);
full_poses_data = cell(nSubDatasets, 1);
for i=1:nSubDatasets
    disp("Generating sub-dataset " + string(i));
    airports_data = full_airports_data{i};
    coord_type = full_camera_locations{i, 1};
    param1 = full_camera_locations{i, 2};
    param2 = full_camera_locations{i, 3};
    param3 = full_camera_locations{i, 4};
    calibrationData = full_calibrationData{i};
    check_dir = (i == 1);
    [full_labels_data{i}, full_poses_data{i}, sub_dataset_size] = generate_homogenous_predataset(airports_data,...
                                                            coord_type, param1, param2, param3,...
                                                            calibrationData,...
                                                            preDatasetFolder, pdfImagesFolder,...
                                                            render_times, basename, offset, check_dir);
                                                        
    disp(string(sub_dataset_size) + " pdf images produced for sub-dataset " + string(i) + newline);
    offset = offset + sub_dataset_size;
end

dataset_size = offset;

save(fullfile(preDatasetFolder, "full_labels_data.mat"), "full_labels_data");
save(fullfile(preDatasetFolder, "full_poses_data.mat"), "full_poses_data");

end

