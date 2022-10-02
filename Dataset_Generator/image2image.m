% function imagePointsHat = image2image(homography, imagePoints)

% Computes the image coordinates of a set of points of an input image under an homography.

% Input :
% homography (3x3 2-d double array) : homography
% imagePoints (2xN 2-d double array) : points coordinates in the input image

% Output :
% imagePointsHat (2xN 2-d double array) : points coordinates in the transformed image

function imagePointsHat = image2image(homography, imagePoints)

if ~all(size(homography) == [3, 3])
    error("homography is expected to be 3x3")
end

if (numel(size(imagePoints)) ~= 2) || (size(imagePoints, 1) ~= 2)
    error("imagePoints is expected to be 2xN")
end

nPoints = size(imagePoints, 2);
imagePointsHat = homography * [imagePoints; ones(1, nPoints)];
imagePointsHat = imagePointsHat(1:2, :) ./ imagePointsHat(3, :);
end

