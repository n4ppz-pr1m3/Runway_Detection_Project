
% function [labels_data, poses_data, dataset_size] = generate_homogenous_predataset(runways_data,...
%                                                     coord_type, param1, param2, param3,...
%                                                     calibration_data,...
%                                                     preDatasetFolder,...
%                                                     render_times, pad_value, offset, check_dir)

% Generates an homogenous pre-dataset.

% The term homogenous comes from the fact that all images have common size
% and format.

% labels_data has a nested structure. Each entry contains raw label
% information for each dataset image. For label key LBL :
% labels_data.LBL.airport := (string) airport name
%       -        .corners := (2x4xN 3-d double array) image coordinates of each airport's runways corners
%       -        .boxes := (Nx4 2-d double array) bounding boxes vectors of each airport's runways
%       -        .masks := (HxWxN 3-d logical array) segmentation masks of each airport's runways

% Similarly, poses_data contains raw camera locations information for each
% airport. For airport APT :
% poses_data.APT.poses := (Nx6 2-d double array) camera poses used to generate images from the given airport
%      -        .offset := (integer) number of poses computed before the current ones

% For easier integration into an heterogenous dataset, the starting index
% of each file/key is offset + 1.

% Input :
% runways_data (runways_data struct) : runways data
% coord_type (string) : coordinates system used for specifying cameras locations ('spherical'|'cylindrical')
% param1 (1-d double array) : set of first components cameras coordinates
% param2 (1-d double array) : set of second components cameras coordinates
% param3 (1-d double array) : set of third components cameras coordinates
% calibration_data (calibration_data struct) : calibration setting
% preDatasetFolder (string) : path to the pre-dataset folder
% render_times (3 1-d double array) : render times
% pad_value (integer) : padding value for files indexing
% offset (integer) : offset used for indexing
% check_dir (boolean) : specifies if a folder needs to be created

% Output :
% labels_data (labels_data struct) : labels data
% poses_data (poses_data struct) : poses data
% dataset_size (integer) : dataset size

function [labels_data, poses_data, dataset_size] = generate_homogenous_predataset(runways_data,...
                                                    coord_type, param1, param2, param3,...
                                                    calibration_data,...
                                                    preDatasetFolder,...
                                                    render_times, pad_value, offset, check_dir)

if isempty(preDatasetFolder)
    preDatasetFolder = "Pre_Dataset";
end

if check_dir && ~mkdir(".", preDatasetFolder)
    error("Unable to create " + preDatasetFolder);
end

% Generates poses
disp("Generating poses...")
[poses_data, dataset_size] = generate_poses(runways_data, coord_type, param1, param2, param3, offset);
% range = string(offset+1) + "_" + string(offset+dataset_size);
% save(fullfile(preDatasetFolder, "poses_data_" + range +".mat"), "poses_data"); % Debug
disp("... done")

% Generates labels
disp("Generating labels...")
labels_data = generate_labels(runways_data, poses_data, calibration_data, pad_value);
%save(fullfile(preDatasetFolder, "labels_data_" + range + ".mat"), "labels_data"); % Debug
disp("... done")

% Generates pdf images
disp("Generating pdf images...")
pdfImagesFolder = get_pdfImagesFolder(preDatasetFolder);
if check_dir && ~mkdir(".", pdfImagesFolder)
    error("Unable to create " + pdfImagesFolder);
end
generate_pdf_images(poses_data, render_times, pdfImagesFolder, pad_value, check_dir)
disp("... done")

end

