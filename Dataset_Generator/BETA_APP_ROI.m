%% Intrinsic estimation
clc; clear; close all;

load("./Calibration/Intrinsic/Calibration_Data/calibrationIntrinsic.mat")

load("./Debug/runwayData.mat");

detect_runway_v2(runwayData, calibrationIntrinsic, 'manual')

%% Zhang estimation
clc; clear; close all;

load("./Calibration/Zhang/Calibration_Data/calibrationZhang.mat")
intrinsicMatrix = calibrationZhang.intrinsicMatrix;
%intrinsicMatrix = calibrationZhang.intrinsicMatrixMatlab;

load("./Debug/runwayData.mat");

detect_runway_v2(runwayData, intrinsicMatrix, 'manual')