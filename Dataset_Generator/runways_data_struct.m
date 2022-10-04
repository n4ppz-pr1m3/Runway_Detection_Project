% RUNWAYS DATA STRUCT

% For each airport APT :
% runways_data.APT.origin := (3-vector) airport origin for cameras views
%        -        .runways := (Nx8 2-d double array) airport runways infos. Each row provides
%                                information on a specific runway in the form:
%                                [latLTP1, lonLTP1, htLTP1, latLTP2, lonLTP2, htLTP2, runway_length, runway_width]
%        -        .names := (Nx2 2-d string array) runways names associated to each LTP.