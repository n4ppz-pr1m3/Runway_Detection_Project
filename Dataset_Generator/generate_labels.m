function labels_data = generate_labels(airports_data, poses_data, current_labels_data, calibrationData)

airports = string(fieldnames(airports_data));
intrinsicMatrix = calibrationData.intrinsicMatrix;
imageSize = calibrationData.imageSize;
wgs84 = wgs84Ellipsoid;
labels_data = current_labels_data;
for i=1:numel(airports)
    airport = airports(i);
    
    % Images names
    images_names = poses_data.(airport){1};

    % Camera poses
    cameraPoses = poses_data.(airport){2};
    nPoses = size(cameraPoses, 1);

    % Runways poses
    runways = airports_data.(airport){2};
    nRunways = size(runways, 1);
    
    % LTP1s
    latLTP1 = runways(:, 1);
    lonLTP1 = runways(:, 2);
    htLTP1 = runways(:, 3);

    % LTP2s
    latLTP2 = runways(:, 4);
    lonLTP2 = runways(:, 5);
    htLTP2 = runways(:, 6);

    [headingRunway, pitchRunway, dLTP] = geodetic2aer(latLTP2, lonLTP2, htLTP2, ...
            latLTP1, lonLTP1, htLTP1, wgs84);
    runwaysPoses = [latLTP1, lonLTP1, htLTP1, headingRunway, pitchRunway, zeros(nRunways, 1)];

    % Runways sizes
    runwaysLengths = runways(:, 7);
    runwaysWidths = runways(:, 8);
    
    for j=1:nPoses
        % Labels generation
        cameraPose = cameraPoses(j, :);
        runways_corners = zeros(2, 4, nRunways);
        runways_bbox = zeros(nRunways, 4);
        runways_masks = zeros([imageSize(1:2), nRunways], "uint8");
        
        for k=1:nRunways
            runwayPose = runwaysPoses(k, :);
            cameraMatrix = intrinsicMatrix * z_extrinsic_matrix(cameraPose, runwayPose);

            % Runway corners cartesian coordinates
            m = dLTP(k) / 2; % LTPs midpoint
            L = runwaysLengths(k);
            W = runwaysWidths(k);
            cornerPoints = [m-L/2, m+L/2, m+L/2, m-L/2;...
                            -W/2, -W/2, W/2, W/2;...
                            0, 0, 0, 0];

            % Runway corners image coordinates
            cornerPoints = world2image(cameraMatrix, cornerPoints);
            runways_corners(:, :, k) = cornerPoints;

            % Runway bounding box
            [~, runways_bbox(k, :), ~] = get_bbox(cornerPoints);

            % Runway mask
            mask = interior_mask(cornerPoints, imageSize(1:2));
            runway_mask = zeros(size(mask), "uint8");
            runway_mask(mask) = k;
            runways_masks(:, :, k) = runway_mask;
            
        end
        % Update labels data
        image_name = images_names(j);
        labels_data.(image_name) =  {runways_corners, runways_bbox, runways_masks, airport};
    end
end
end

