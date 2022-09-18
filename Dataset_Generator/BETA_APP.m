%% Intrinsic estimation
clc; clear; close all;

load("./Calibration/Intrinsic/calibrationIntrinsic.mat")

load("runwayData.mat");

detect_runway_v2(runwayData, calibrationIntrinsic, 'manual')

%% Zhang estimation
clc; clear; close all;

load("./Calibration/Zhang/calibrationZhang.mat")
intrinsicMatrix = calibrationZhang.intrinsicMatrix;
%intrinsicMatrix = calibrationZhang.intrinsicMatrixMatlab;

load("runwayData.mat");

detect_runway_v2(runwayData, intrinsicMatrix, 'manual')