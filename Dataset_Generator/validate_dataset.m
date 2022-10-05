
% function validate_dataset(validationFolder, validation_ratio, ...
%                                 full_labels_data, imagesFolder)

% Validates a dataset by sampling a random set of images and drawing labels
% on them.

% For each sub-homogenous dataset, a 100 * validation_ratio percent of the
% images will be sampled (or 1 if the percentage is < 1).

% Input :
% validationFolder (string) : validation folder path
% validation_ratio (double) : validation proportion
% full_labels_data (1-d cell array of labels data struct) : labels data used for the dataset creation
% imagesFolder (string) : dataset images path

function validate_dataset(validationFolder, validation_ratio, ...
                                full_labels_data, imagesFolder)

% Validate labels
if validation_ratio
    disp(newline + "Validating labels...")
    if isempty(validationFolder)
        validationFolder = "Validation";
    end
    if ~mkdir(".", validationFolder)
        error("Unable to create " + validationFolder);
    end
    index = 1;
    fig = figure;
    fig.Visible = "off";
    colors = linspecer(10, 'sequential');
    [~, images_names, extensions] = get_names(imagesFolder);
    for i=1:numel(full_labels_data)
        labels_data = full_labels_data{i};
        labels_names = fieldnames(labels_data);

        nImages = numel(labels_names);
        sample_size = min([nImages, max([1, round(validation_ratio*nImages)])]);
        sample_indices = randperm(nImages, sample_size);
        for j=sample_indices
            label_name = labels_names{j};
            image_index = str2double(label_name(4:end));
            image_name = images_names{image_index};
            ext = extensions{image_index};
            image_path = fullfile(imagesFolder, strcat(image_name, ext));
            airport = labels_data.(label_name).airport;
            image_id = image_name + " [" + airport + "]";

            % Draw borders
            save_path = fullfile(validationFolder, "val_img_borders_" + string(index) + ext);
            runways_corners = labels_data.(label_name).corners;
            draw_borders(image_id, image_path, save_path, fig, colors, runways_corners)
    
            % Draw bounding boxes
            runways_bounding_boxes = labels_data.(label_name).boxes;
            save_path = fullfile(validationFolder, "val_img_bbox_" + string(index) + ext);
            draw_bounding_boxes(image_id, image_path, save_path, fig, colors, runways_bounding_boxes)
    
            % Draw segmentation masks
            runways_segmentation_masks = labels_data.(label_name).masks;
            save_path = fullfile(validationFolder, "val_img_seg_masks_" + string(index) + ext);
            draw_segmentation_masks(image_id, image_path, save_path, fig, colors, runways_segmentation_masks)
    
            index = index + 1;
        end
    end
    close(fig);
    disp("... done." + newline + "Validation data successfully created at " + fullfile(validationFolder));
end

end

