function new_full_labels_data = update_heterogenous_predataset_labels(full_airports_data,...
                                                                    new_full_calibrationData,...
                                                                    preDatasetFolder,...
                                                                    basename)

full_poses_path = fullfile(preDatasetFolder, "full_poses_data.mat");                         
load(full_poses_path, "full_poses_data");
nSubDatasets = numel(full_airports_data);
new_full_labels_data = cell(nSubDatasets, 1);
for i=1:nSubDatasets
    disp("Updating labels for sub-dataset " + string(i) + " ...");
    airports_data = full_airports_data{i};
    poses_data = full_poses_data{i};
    calibrationData = new_full_calibrationData{i};
    new_full_labels_data{i} = generate_labels(airports_data, poses_data, calibrationData, basename);                                                     
    disp("... done")
end
save(full_poses_path, "full_poses_data");

end

