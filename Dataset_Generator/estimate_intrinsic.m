
% function calibrationData = estimate_intrinsic(currentCalibrationData)

% Computes the intrinsic parameters of a camera with the provided calibration data

% On top of the intrinsic parameters, the calibration data is updated with
% the following information:
% - Reprojection residuals
% - Mean reprojection error
% - Camera field of view

% Input :
% currentCalibrationData (calibration struct) : calibration data

% Output :
% calibrationData (calibration struct) : updated calibration data

function calibrationData = estimate_intrinsic(currentCalibrationData)

disp("Estimating intrinsic parameters")

calibrationData = currentCalibrationData;

imagesPoints = calibrationData.imagesPoints;
cameraPoints = calibrationData.cameraPoints;

[intrinsicMatrix0, aspectRatio, skew, mre0, lmx, lmy] = robust_linreg_estimate(imagesPoints, cameraPoints);
[intrinsicMatrix, residuals, mre] = least_squares_estimate(imagesPoints, cameraPoints, aspectRatio, skew);


calibrationData.intrinsicMatrix = intrinsicMatrix;
calibrationData.residuals = residuals;
calibrationData.meanReprojectionError = mre;

imageSize = calibrationData.imageSize;
fx = intrinsicMatrix(1, 1);
fy = intrinsicMatrix(2, 2);
[fov_hor, fov_ver] = fov(fx, fy, imageSize(2), imageSize(1));
calibrationData.fov = [fov_hor, fov_ver];

save(calibrationData.file, "calibrationData");
disp("Estimation done" + newline)

end

