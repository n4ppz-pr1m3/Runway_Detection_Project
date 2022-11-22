
% function [full_labels_data, full_poses_data, dataset_size] = generate_heterogenous_predataset(full_runways_data,...
%                                                             full_camera_locations,...
%                                                             full_calibrationData,...
%                                                             preDatasetFolder,...
%                                                             render_times, pad_value)

% Generates an heterogenous pre-dataset from a set of homogenous
% pre-datasets.

% Input :
% full_runways_data (N 1-d cell array of runways_data struct) : runways data associated with each sub-dataset
% full_camera_locations (Nx4 2-d cell array) : camera locations associated with each sub-dataset
% full_calibration_data (N 1-d cell array of calibration_data struct) : calibration data associated with each sub-dataset
% preDatasetFolder (string) : path to the pre-dataset folder
% render_times (3 1-d double array) : render times
% pad_value (integer) : padding value for files indexing

% Output :
% full_labels_data (N 1-d cell array of labels_data struct) : labels data aggregated from each sub-dataset
% full_poses_data (N 1-d cell array of poses_data struct) : poses data aggregated from each sub-dataset
% dataset_size (integer) : dataset size

function [full_labels_data, full_poses_data, dataset_size] = generate_heterogenous_predataset(full_runways_data,...
                                                            full_camera_locations,...
                                                            full_calibrationData,...
                                                            preDatasetFolder,...
                                                            render_times, pad_value)
                                         
offset = 0;
nSubDatasets = numel(full_runways_data);
full_labels_data = cell(nSubDatasets, 1);
full_poses_data = cell(nSubDatasets, 1);
for i=1:nSubDatasets
    disp("Generating sub-dataset " + string(i));
    runways_data = full_runways_data{i};
    coord_type = full_camera_locations{i, 1};
    param1 = full_camera_locations{i, 2};
    param2 = full_camera_locations{i, 3};
    param3 = full_camera_locations{i, 4};
    calibrationData = full_calibrationData{i};
    pdfImagesFolderName = "PDF_Images_" + string(i);
    check_dir = (i == 1);
    [full_labels_data{i}, full_poses_data{i}, sub_dataset_size] = generate_homogenous_predataset(runways_data,...
                                                            coord_type, param1, param2, param3,...
                                                            calibrationData,...
                                                            preDatasetFolder, pdfImagesFolderName,...
                                                            render_times, pad_value, offset, check_dir);
                                                        
    disp(string(sub_dataset_size) + " pdf images produced for sub-dataset " + string(i) + " in " + pdfImagesFolderName + newline);
    offset = offset + sub_dataset_size;
end

dataset_size = offset;

save(fullfile(preDatasetFolder, "full_labels_data.mat"), "full_labels_data");
save(fullfile(preDatasetFolder, "full_poses_data.mat"), "full_poses_data");

end

