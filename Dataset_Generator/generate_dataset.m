function generate_dataset(full_airports_data,...
                        full_camera_locations,...
                        full_calibration_data,...
                        preDatasetFolder, pdfImagesFolder,...
                        render_times, basename,...
                        imagesFolder, annotationsFolder, masksFolder,...
                        validationFolder, validation_ratio)

% Pre dataset
tic                               
disp("Generating pre-dataset..." + newline)                      
[dataset_size, full_labels_data] = generate_heterogenous_predataset(full_airports_data,...
                                                        full_camera_locations,...
                                                        full_calibration_data,...
                                                        preDatasetFolder, pdfImagesFolder,...
                                                        render_times, basename);
disp("Pre-dataset done. " + string(dataset_size) + " pdf images generated.");
toc

% Conversion to PASCAL VOC
tic
disp(newline + "Converting pre-dataset to PASCAL VOC...");
to_PASCAL_VOC(full_calibration_data, full_labels_data, pdfImagesFolder,...
                imagesFolder, annotationsFolder, masksFolder)
disp("Conversion done");
toc

% Validate labels
if validation_ratio
    tic
    disp(newline + "Validating labels...")
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
        sample_size = max([1, round(validation_ratio*nImages)]);
        for j=1:sample_size
            image_name = images_names(randi(nImages));
            image_path = imagesFolder + "/" + image_name  + "." + imageFormat;
            airport = labels_data.(image_name){4};

            % Draw borders
            save_path = fullfile(validationFolder, "val_img_borders_" + string(index) + "." + imageFormat);
            runways_corners = labels_data.(image_name){1};
            draw_borders(airport, image_path, save_path, fig, colors, runways_corners)

            % Draw bounding boxes
            runways_bounding_boxes = labels_data.(image_name){2};
            save_path = fullfile(validationFolder, "val_img_bbox_" + string(index) + "." + imageFormat);
            draw_bounding_boxes(airport, image_path, save_path, fig, colors, runways_bounding_boxes)

            % Draw segmentation masks
            runways_segmentation_masks = labels_data.(image_name){3};
            save_path = fullfile(validationFolder, "val_img_seg_masks_" + string(index) + "." + imageFormat);
            draw_segmentation_masks(airport, image_path, save_path, fig, colors, runways_segmentation_masks)

            index = index + 1;
        end
    end
    close(fig);
    disp("... done")
    toc
end
end

