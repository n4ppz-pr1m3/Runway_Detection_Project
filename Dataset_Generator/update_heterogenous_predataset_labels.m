function full_labels_data = update_heterogenous_predataset_labels(full_airports_data,...
                                                                    new_full_calibrationData,...
                                                                    preDatasetFolder,...
                                                                    pad_value)
                       
load(fullfile(preDatasetFolder, "full_poses_data.mat"), "full_poses_data");
nSubDatasets = numel(full_airports_data);
full_labels_data = cell(nSubDatasets, 1);
for i=1:nSubDatasets
    disp("Updating labels for sub-dataset " + string(i) + " ...");
    airports_data = full_airports_data{i};
    poses_data = full_poses_data{i};
    calibrationData = new_full_calibrationData{i};
    full_labels_data{i} = generate_labels(airports_data, poses_data, calibrationData, pad_value);                                                     
    disp("... done")
end
% Overwrite existing labels data
save(fullfile(preDatasetFolder, "full_labels_data.mat"), "full_labels_data");

end

