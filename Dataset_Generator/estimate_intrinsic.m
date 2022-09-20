function calibrationData = estimate_intrinsic(currentCalibrationData)

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

end

