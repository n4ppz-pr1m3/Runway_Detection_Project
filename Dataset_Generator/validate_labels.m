function validate_labels(validationFolder, validation_ratio, ...
                        full_labels_data, full_calibration_data,...
                        imagesFolder)

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
    for i=1:numel(full_labels_data)
        imageFormat = full_calibration_data{i}.imageFormat;
        labels_data = full_labels_data{i};
        images_names = string(fieldnames(labels_data));
        nImages = numel(images_names);
        sample_size = min([nImages, max([1, round(validation_ratio*nImages)])]);
        sample_indices = randperm(nImages, sample_size);
        for j=sample_indices
            image_name = images_names(j);
            image_path = fullfile(imagesFolder, image_name  + "." + imageFormat);
            airport = labels_data.(image_name).airport;
    
            % Draw borders
            save_path = fullfile(validationFolder, "val_img_borders_" + string(index) + "." + imageFormat);
            runways_corners = labels_data.(image_name).corners;
            draw_borders(airport, image_path, save_path, fig, colors, runways_corners)
    
            % Draw bounding boxes
            runways_bounding_boxes = labels_data.(image_name).boxes;
            save_path = fullfile(validationFolder, "val_img_bbox_" + string(index) + "." + imageFormat);
            draw_bounding_boxes(airport, image_path, save_path, fig, colors, runways_bounding_boxes)
    
            % Draw segmentation masks
            runways_segmentation_masks = labels_data.(image_name).masks;
            save_path = fullfile(validationFolder, "val_img_seg_masks_" + string(index) + "." + imageFormat);
            draw_segmentation_masks(airport, image_path, save_path, fig, colors, runways_segmentation_masks)
    
            index = index + 1;
        end
    end
    close(fig);
    disp("... done." + newline + "Validation data successfully created at " + fullfile(validationFolder));
end

end

