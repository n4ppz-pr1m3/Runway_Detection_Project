function save_labels(preDatasetFolder, datasetName)

disp(newline + "Saving labels...")
labels_file = fullfile(preDatasetFolder, "full_labels_data.mat");
named_labels_file = fullfile(preDatasetFolder, strcat("full_labels_data_", datasetName, ".mat"));
[status, msg] = copyfile(labels_file, named_labels_file);
if status
    disp(msg);
end
disp("Labels saved at : " + named_labels_file);

end

