function dataset_size = generate_dataset(airports_data,...
                                        param1, param2, param3, coord_type,...
                                        calibrationData,...
                                        preDatasetFolder, pdfImagesFolder,...
                                        imagesFolder, annotationFolder, masksFolder,...
                                        basename, offset)


if isempty(preDatasetFolder)
    preDatasetFolder = "Pre_Dataset";
end
   
if ~mkdir(".", preDatasetFolder)
    error("Unable to create " + preDatasetFolder);
end

if isempty(pdfImagesFolder)
    pdfImagesFolder = preDatasetFolder + "/PDF_Images";
end

% Generates poses
disp("Generating poses...")
[poses_data, dataset_size] = generate_poses(airports_data, param1, param2, param3, coord_type);
range = string(offset+1) + "_" + string(offset+dataset_size);
save(preDatasetFolder + "/poses_data_" + range +".mat", "poses_data");
disp("... done")

% Generates labels
disp("Generating labels...")
labels_data = generate_labels(airports_data, poses_data, calibrationData, basename, offset);
save(preDatasetFolder + "/labels_data_" + range + ".mat");
disp("... done")

% Generates pdf images
disp("Generating pdf images...")
generate_pdf_images(poses_data, labels_data, pdfImagesFolder)
disp("... done")

% Generate PASCAL VOC dataset
disp("Converting dataset to PASCAL VOC...")
cropValue = calibrationData.cropValue;
imageFormat = calibrationData.imageFormat;
dpi = calibrationData.dpi;
to_PASCAL_VOC(labels_data, pdfImagesFolder, imagesFolder, annotationFolder, masksFolder, cropValue, imageFormat, dpi)
disp("... done")

end

