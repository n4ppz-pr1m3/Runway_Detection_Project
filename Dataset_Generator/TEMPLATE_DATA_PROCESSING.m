clc; clear; close all;

raw_airports_data = "SAMPLE_AIRPORT_DATA.xlsx";

filter_list = curated_airports;

runways_data = get_runways_data(raw_airports_data, filter_list);