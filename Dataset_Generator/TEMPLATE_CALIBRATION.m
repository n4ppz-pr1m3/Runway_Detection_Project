clc; clear; close all; 

numImages = 5;
dpi = 94;
calibrationFolder = "Template_Calibration";
baseFilename = "calibration_image";
imageFormat = "png";
default_calibration = true;

calibration_data = intrinsic_calibration(numImages, dpi, calibrationFolder,...
                                 baseFilename, imageFormat, default_calibration);