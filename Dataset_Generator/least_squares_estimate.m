% function [K, residuals, mre] = least_squares_estimate(imagePoints, cameraPoints, aspectRatio, skew)

% Estimate the intrinsic parameters of a camera with known skew and aspect
% ratio using least squares with a set of control points with known image
% and camera coordinates. At least 2 points are required.

% Input :
% imagePoints (N*2 2-d double array) : control points image coordinates
% cameraPoints (N*3 2-d double array) : control points camera coordinates
% aspectRatio (double) : camera aspect ratio
% skew (double) : camera skew

% Output :
% K (3*3 2-d array double) : intrinsic parameters matrix
% residual (
% mre (double) : mean reprojection error

function [K, residuals, mre] = least_squares_estimate(imagePoints, cameraPoints, aspectRatio, skew)

if size(imagePoints, 1) ~= size(cameraPoints, 1)
    error("Image points and camera points number mismatch")
elseif size(imagePoints, 2) ~= 2
    error("Image points must have 2 coordinates (" + string(size(imagePoints, 2)) + ")")
elseif size(cameraPoints, 2) ~= 3
    error("Camera points must have 3 coordinates (" + string(size(cameraPoints, 2)) + ")")
elseif sum(abs(cameraPoints(:, 3)) <= 1e-3) ~= 0
    error("Camera points can't have null Z coordinate")
end

xzC = cameraPoints(:, 1) ./ cameraPoints(:, 3);
yzC = cameraPoints(:, 2) ./ cameraPoints(:, 3);

n = size(imagePoints, 1);

% % Design matrix
% X = zeros(2*n, 3);
% X(1:2:end, 1) = aspectRatio * xzC;
% X(2:2:end, 1) = yzC;
% X(1:2:end, 2) = 1;
% X(2:2:end, 3) = 1;
% 
% % Response vector
% Y = imagePoints';
% Y = reshape(Y, [], 1);
% Y(1:2:end) = Y(1:2:end) - skew*yzC;

% Design matrix
X = zeros(2*n, 3);
X(1:n, 1) = aspectRatio * xzC;
X(n+1:end, 1) = yzC;
X(1:n, 2) = 1;
X(n+1:end, 3) = 1;

% Response vector
Y = imagePoints(:);
Y(1:n) = Y(1:n) - skew*yzC;

p = (X'*X) \ (X'*Y);

K = [p(1), 0, p(2);...
      0, p(1), p(3);...
      0, 0, 1];

% RMSE
res = X*p - Y;
mre = sqrt(sum(res.^2) / n);

% Residual
residuals = (reshape(res, 2, []))';

end

