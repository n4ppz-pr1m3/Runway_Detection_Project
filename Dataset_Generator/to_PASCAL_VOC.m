function to_PASCAL_VOC(full_calibration_data, full_labels_data, pdfImagesFolder,...
                    datasetName, datasetFolder, imagesFolder, annotationsFolder, masksFolder)


annotationsFolder = fullfile(datasetFolder, annotationsFolder);
if ~mkdir(".", annotationsFolder)
    error("Unable to create " + annotationsFolder);
end

masksFolder = fullfile(datasetFolder, masksFolder);
if ~mkdir(".", masksFolder)
    error("Unable to create " + masksFolder);
end

% Images generation
disp("Generating images...")
imagesFolder = fullfile(datasetFolder, imagesFolder);
nSubDatasets = numel(full_calibration_data);
for i=1:nSubDatasets
    calibration_data = full_calibration_data{i};
    check_dir = (i == 1);
    generate_images(pdfImagesFolder, imagesFolder, calibration_data, check_dir);
end
disp("... done" + newline)

% Labels generation
disp("Generating labels...")
for id_subdataset=1:nSubDatasets
    
    % Subdataset labels
    labels_data = full_labels_data{id_subdataset};

    % Subdataset images parameters
    images_names = string(fieldnames(labels_data));
    imageFormat = full_calibration_data{id_subdataset}.imageFormat;
    image_path = fullfile(imagesFolder, images_names(1) + "." + imageFormat);
    tmp_image = imread(image_path);
    height = size(tmp_image, 1);
    width = size(tmp_image, 2);
    channels = size(tmp_image, 3);

    for i=1:numel(images_names)
        image_name = images_names(i);
        labels = labels_data.(image_name);

        % Annotation files
        annotation_file = fullfile(annotationsFolder, image_name + ".txt");
        fileId = fopen(annotation_file, 'w');

        fprintf(fileId, '# Compatible with PASCAL Annotation Version 1.00\r\n');
        image_path = fullfile(imagesFolder, image_name + "." + imageFormat);
        fprintf(fileId, 'Image filename : "%s"\r\n', image_path);
        fprintf(fileId, 'Image size (X x Y x C) : %u x %u x %u\r\n', width, height, channels);
        fprintf(fileId, 'Database : "%s"\r\n', datasetName);

        bbox = labels.boxes;
        nRunways = size(bbox, 1);
        objects = strings(1, nRunways);
        objects(:) = "PASrunway";
        objects = strjoin(objects);
        fprintf(fileId, "Objects with ground truth : %u { " + objects + " }\r\n\r\n", nRunways);

        mask_image = fullfile(masksFolder, image_name + "_mask." + imageFormat);
        complete_mask = composite_mask(labels.masks);
        imwrite(complete_mask, mask_image);

        for j=1:nRunways
            fprintf(fileId, '# Details for runway %u ("PASrunway")\r\n', j);
            fprintf(fileId, 'Original label for object %u "PASrunway" : "Runway"\r\n', j);
            xMin = max([0, bbox(j, 1)]);
            yMin = max([0, bbox(j, 2)]);
            xMax = min([width, bbox(j, 3)]);
            yMax = min([height, bbox(j, 4)]);
            fprintf(fileId, 'Bounding box for object %u "PASrunway" (Xmin, Ymin) - (Xmax, Ymax) : (%u, %u) - (%u, %u)\r\n', j, xMin, yMin, xMax, yMax);
            fprintf(fileId, 'Pixel mask for object %u "PASrunway" : "%s"\r\n\r\n', j, mask_image);
        end
        fclose(fileId);

    end
end
disp("... done")


end
