
% function [worldPoints, rePoint, reImage, residuals] = image2world(imagePoints, homographies)

% TO DO : reprojection errors are incorrect

% Compute the world coordinates of a set of points given their image
% coordinates on multiple images. The points are assumed to be coplanar and
% to lie on the plane Z=0 of the world reference frame.

% Input :
% imagePoints (P*2*N 3-d double array) : image coordinates of P points from N images
% homographies (3*3*N 3-d double array) : homographies between each of the
% N images and the planar world

% Output :
% worldPoints (P*2 2-d double array) : world coordinates of the P points
% rePoint (P 1-d double array) : mean reprojection error of each point across all images
% reImage (N 1-d double array) : mean reprojection error of all points for each image
% residuals (P*2*N 3-d double array) : residuals between image coordinates and projected world points

function [worldPoints, rePoint, reImage, residuals] = image2world(imagePoints, homographies)

if size(imagePoints, 3) ~= size(homographies, 3)
    error("Camera matrices and images count mismatch")
elseif size(imagePoints, 2) ~= 2
    error("Points are expected to have 2 image coordinates")
elseif size(homographies, 1) ~= 3 || size(homographies, 2) ~= 3
    error("Homographies are expected to be 3x3")
end

nPoints = size(imagePoints, 1);
worldPoints = zeros(nPoints, 2);
residuals = zeros(size(imagePoints));
rePoint = zeros(nPoints, 1);
nHomographies = size(homographies, 3);
for i=1:nPoints
    H = homographies;
    xI = imagePoints(i, 1, :);
    yI = imagePoints(i, 2, :);
    H(1, :, :) = H(1, :, :) - xI.*H(3, :, :);
    H(2, :, :) = H(2, :, :) - yI.*H(3, :, :);

    A = zeros(2*nHomographies, 2);
    b = zeros(2*nHomographies, 1);
    for j=1:nHomographies
        indices = 1+2*(j-1):2*j;
        A(indices, :) = H(1:2, 1:2, j);
        b(indices) = -H(1:2, 3, j);
    end
    wP = A \ b;
    worldPoints(i, :) = wP';
    residual = A*wP - b;
    rePoint(i) = sqrt(sum(residual.^2) / nHomographies);
    residual = reshape(residual, 2, nHomographies);
    residuals(i, :, :) = residual;

end
reImage = squeeze(sqrt(sum(residuals.^2, [1 2]) / nPoints));

end

