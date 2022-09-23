function [labels_data, poses_data, dataset_size] = generate_homogenous_predataset(airports_data,...
                                                    coord_type, param1, param2, param3,...
                                                    calibrationData,...
                                                    preDatasetFolder, pdfImagesFolder,...
                                                    render_times, pad_value, offset, check_dir)

if isempty(preDatasetFolder)
    preDatasetFolder = "Pre_Dataset";
end
   
if isempty(pdfImagesFolder)
    pdfImagesFolder = fullfile(preDatasetFolder, "PDF_Images");
end

if check_dir && ~mkdir(".", preDatasetFolder)
    error("Unable to create " + preDatasetFolder);
end

% Generates poses
disp("Generating poses...")
[poses_data, dataset_size] = generate_poses(airports_data, coord_type, param1, param2, param3, offset);
% range = string(offset+1) + "_" + string(offset+dataset_size);
% save(fullfile(preDatasetFolder, "poses_data_" + range +".mat"), "poses_data"); % Debug
disp("... done")

% Generates labels
disp("Generating labels...")
labels_data = generate_labels(airports_data, poses_data, calibrationData, pad_value);
%save(fullfile(preDatasetFolder, "labels_data_" + range + ".mat"), "labels_data"); % Debug
disp("... done")

% Generates pdf images
disp("Generating pdf images...")
generate_pdf_images(poses_data, render_times, pdfImagesFolder, pad_value, check_dir)
disp("... done")

end

