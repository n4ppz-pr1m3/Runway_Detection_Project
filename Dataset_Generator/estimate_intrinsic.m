
% function calibration_data = estimate_intrinsic(currentCalibrationData)

% Computes the intrinsic parameters of a camera with the provided calibration data

% On top of the intrinsic parameters, the calibration data is updated with
% the following information:
% - Reprojection residuals
% - Mean reprojection error
% - Camera field of view

% Input :
% currentCalibrationData (calibration struct) : calibration data

% Output :
% calibration_data (calibration struct) : updated calibration data

function calibration_data = estimate_intrinsic(currentCalibrationData)

disp("Estimating intrinsic parameters")

calibration_data = currentCalibrationData;

imagesPoints = calibration_data.imagesPoints;
cameraPoints = calibration_data.cameraPoints;

[intrinsicMatrix0, aspectRatio, skew, mre0, lmx, lmy] = robust_linreg_estimate(imagesPoints, cameraPoints);
[intrinsicMatrix, residuals, mre] = least_squares_estimate(imagesPoints, cameraPoints, aspectRatio, skew);


calibration_data.intrinsicMatrix = intrinsicMatrix;
calibration_data.residuals = residuals;
calibration_data.meanReprojectionError = mre;

imageSize = calibration_data.imageSize;
fx = intrinsicMatrix(1, 1);
fy = intrinsicMatrix(2, 2);
[fov_hor, fov_ver] = fov(fx, fy, imageSize(2), imageSize(1));
calibration_data.fov = [fov_hor, fov_ver];

save(calibration_data.file, "calibration_data");
disp("Estimation done" + newline)

end

