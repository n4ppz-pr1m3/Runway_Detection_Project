%% Intrinsic estimation
clc; clear; close all;

load("calibration_data.mat")

load("runways_data.mat");

detect_runway(runways_data, calibration_data, 'manual')

%% Zhang estimation
clc; clear; close all;

load("./Calibration/Zhang/calibrationZhang.mat")
intrinsicMatrix = calibrationZhang.intrinsicMatrix;
%intrinsicMatrix = calibrationZhang.intrinsicMatrixMatlab;

load("runwayData.mat");

detect_runway(runwayData, intrinsicMatrix, 'manual')