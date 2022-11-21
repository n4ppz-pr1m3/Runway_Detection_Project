clc; clear; close all;

load("calibration_data.mat")

load("runways_data.mat");

detect_runway(runways_data, calibration_data, 'manual')
