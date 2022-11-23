clc; clear; close all;

% PREREQUISITE: Run TEMPLATE_CALIBRATION.m and TEMPLATE_DATA_PROCESSING.m

load("calibration_data.mat")

load("runways_data.mat");

detect_runway(runways_data, calibration_data, 'manual')
