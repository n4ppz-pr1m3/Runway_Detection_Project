%% Intrinsic estimation
clc; clear; close all;

load("calibrationData.mat")

load("runwayData.mat");

detect_runway(runwayData, calibrationData, 'manual')

%% Zhang estimation
clc; clear; close all;

load("./Calibration/Zhang/calibrationZhang.mat")
intrinsicMatrix = calibrationZhang.intrinsicMatrix;
%intrinsicMatrix = calibrationZhang.intrinsicMatrixMatlab;

load("runwayData.mat");

detect_runway(runwayData, intrinsicMatrix, 'manual')