
% function full_labels_data = update_heterogenous_predataset_labels(full_runways_data,...
%                                                                     new_full_calibrationData,...
%                                                                     preDatasetFolder,...
%                                                                     pad_value)

% Updates a pre-dataset with new calibration settings.

% It is assumed that the exisisting pre-dataset has been created with
% identical airports data and padding value. Hence, only labels need to be
% recomputed.

% The existing label data is overwritten.

% Input :
% full_runways_data (1-d cell array of runways data struct) : runways data
% new_full_calibrationData (1-d cell array of calibration data struct) : updated calibration settings
% preDatasetFolder (string) : pre-dataset folder path
% pad_value (integer) : padding value

% Output :
% full_labels_data (1-d cell array of labels data struct) : updated labels data

function full_labels_data = update_heterogenous_predataset_labels(full_runways_data,...
                                                                    new_full_calibrationData,...
                                                                    preDatasetFolder,...
                                                                    pad_value)
                       
load(fullfile(preDatasetFolder, "full_poses_data.mat"), "full_poses_data");
nSubDatasets = numel(full_runways_data);
full_labels_data = cell(nSubDatasets, 1);
for i=1:nSubDatasets
    disp("Updating labels for sub-dataset " + string(i) + " ...");
    runways_data = full_runways_data{i};
    poses_data = full_poses_data{i};
    calibrationData = new_full_calibrationData{i};
    full_labels_data{i} = generate_labels(runways_data, poses_data, calibrationData, pad_value);                                                     
    disp("... done")
end
% Overwrite existing labels data
save(fullfile(preDatasetFolder, "full_labels_data.mat"), "full_labels_data");

end

