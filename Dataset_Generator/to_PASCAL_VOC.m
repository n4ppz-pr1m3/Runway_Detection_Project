function to_PASCAL_VOC(full_calibration_data, full_labels_data,...
                       pdfImagesFolder, imagesFolder, annotationsFolder, masksFolder)

if ~mkdir(".", annotationsFolder)
    error("Unable to create " + annotationsFolder);
end

if ~mkdir(".", masksFolder)
    error("Unable to create " + masksFolder);
end

% Images generation
disp("Generating images...")
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
    imageFormat = full_calibration_data{i}.imageFormat;
    labels_data = full_labels_data{id_subdataset};
    airports = string(fieldnames(labels_data));
    for i=1:numel(airports)
        airport = airports(i);
        labels = labels_data.(airport);
        images_names = labels{4};
        if i==1
            image_path = imagesFolder + "/" + images_names(1) + "." + imageFormat;
            tmp_image = imread(image_path);
            height = size(tmp_image, 1);
            width = size(tmp_image, 2);
            channels = size(tmp_image, 3);
        end
        for j=1:numel(images_names)
            image_name = images_names(j);

            % Annotation files
            annotation_file = annotationsFolder + "/" + image_name + ".txt";
            fileId = fopen(annotation_file, 'w');

            fprintf(fileId, '# Compatible with PASCAL Annotation Version 1.00\r\n');
            image_path = imagesFolder + "/" + image_name + "." + imageFormat;
            fprintf(fileId, 'Image filename : "%s"\r\n', image_path);
            fprintf(fileId, 'Image size (X x Y x C) : %u x %u x %u\r\n', width, height, channels);
            fprintf(fileId, 'Database : "T.B.D"\r\n');

            bbox = labels{2};
            nRunways = size(bbox, 1);
            objects = strings(1, nRunways);
            objects(:) = "PASrunway";
            objects = strjoin(objects);
            fprintf(fileId, "Objects with ground truth : %u { " + objects + " }\r\n\r\n", nRunways);

            mask_image = masksFolder + "/" + image_name + "_mask." + imageFormat;
            complete_mask = composite_mask(labels{3});
            imwrite(complete_mask, mask_image);
            for k=1:nRunways
                fprintf(fileId, '# Details for runway %u ("PASrunway")\r\n', k);
                fprintf(fileId, 'Original label for object %u "PASrunway" : "Runway"\r\n', k);
                xMin = max([0, bbox(k, 1)]);
                yMin = max([0, bbox(k, 2)]);
                xMax = min([width, bbox(k, 3)]);
                yMax = min([height, bbox(k, 4)]);
                fprintf(fileId, 'Bounding box for object %u "PASrunway" (Xmin, Ymin) - (Xmax, Ymax) : (%u, %u) - (%u, %u)\r\n', k, xMin, yMin, xMax, yMax);
                fprintf(fileId, 'Pixel mask for object %u "PASrunway" : "%s"\r\n\r\n', k, mask_image);
            end
            fclose(fileId);
        end
    end
end
disp("... done" + newline)
end
