function imagePointsHat = image2image(homography, imagePoints)

nPoints = size(imagePoints, 2);
imagePointsHat = homography * [imagePoints; ones(1, nPoints)];
imagePointsHat = imagePointsHat ./ imagePointsHat(3, :);
imagePointsHat = imagePointsHat(1:2, :);
end

