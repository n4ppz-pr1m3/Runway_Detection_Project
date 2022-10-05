
% function runways_data = get_runways_data(raw_airports_data, filter_list)

% Extracts runways data.

% raw_airports_data should provide airports data in a tabular form :
% The following fields are expected :
% - Airport (string)
% - Runway (string)
% - LatitudeLTP (string)
% - LongitudeLTP (string)
% - HeightLTP (numerical)
% - LatitudeFPAP (string)
% - LongitudeFPAP (string)
% - Length (numerical - International Feet)
% - Width (numerical - International Feet)
% - Elevation (numerical)
% - MagBearing (numerical)

% Runway lengths from a given airport should be unique.

% Latitudes and longitudes should be given in the form : cardinal direction + d.m.s. angle
% Example : "N12-34-56.78"

% If filter_list is provided, runways data will be extracted exclusively
% from airports on that list.

% runways_data is a runways data struct. For each airport APT :
% runways_data.APT.origin := (3-vector) airport origin for cameras views
%        -        .runways := (Nx8 2-d double array) airport runways infos. Each row provides
%                                information on a specific runway in the form:
%                                [latLTP1, lonLTP1, htLTP1, latLTP2, lonLTP2, htLTP2, runway_length, runway_width]
%        -        .names := (Nx2 2-d string array) runways names associated to each LTP.

% Input :
% raw_airports_data (tabular airports data) : airports data
% [Optional] filter_list (1-d string array) : airports filtering list

% Output :
% runways_data (runways data struct) : runways data

function runways_data = get_runways_data(raw_airports_data, filter_list)

table = readtable(raw_airports_data, 'sheet', 1);

strData = string(table{:, ["Airport", "Runway", "LatitudeLTP", "LongitudeLTP", "LatitudeFPAP", "LongitudeFPAP"]});
numData = [double(string(table{:, "HeightLTP"})), table{:, ["Length", "Width", "Elevation"]}, double(string(table{:, "MagBearing"}))];

airports = unique(strData(:, 1));
if exist("filter_list", "var")
    airports = sort(intersect(airports, filter_list));
end
disp(string(numel(airports)) + " airports found.")

runways_data = [];
for i=1:numel(airports)
    airport = airports(i);
    indices = find(strData(:, 1) == airport);
    lengths = numData(indices, 2);
    uniqueLengths = unique(lengths);
    nRunways = 0;
    runways = zeros(numel(indices), 8);
    names = strings(numel(indices), 2);
    for j=1:numel(uniqueLengths)
        length = uniqueLengths(j);
        runwayLength = 0.3048 * length;
        idxL = find(lengths == length);
        n = numel(idxL);
        switch n
            % Not ideal
            case 1
                nRunways = nRunways + 1;
                iLTP = indices(idxL(1));
                warning("Single LTP for " + strData(iLTP, 1) + "-" + strData(iLTP, 2))
                % LTP1
                name1 = strData(iLTP, 2);
                latLTP1 = string2angle(strData(iLTP, 3));
                lonLTP1 = string2angle(strData(iLTP, 4));
                htLTP1 = numData(iLTP, 1);
                % No LTP2 / Use FPAP
                latLTP2 = string2angle(strData(iLTP, 5));
                lonLTP2 = string2angle(strData(iLTP, 6));
                htLTP2 = htLTP1;
                % Runway size
                runwayWidth = 0.3048 * numData(iLTP, 3);
                % Runway data
                runways(nRunways, :) = [latLTP1, lonLTP1, htLTP1, ...
                    latLTP2, lonLTP2, htLTP2, runwayLength, runwayWidth];
                names(nRunways, :) = [name1, ""];

            % Nominal case
            case 2
                nRunways = nRunways + 1;
                iLTP1 = indices(idxL(1));
                iLTP2 = indices(idxL(2));
                % LTP1
                name1 = strData(iLTP1, 2);
                latLTP1 = string2angle(strData(iLTP1, 3));
                lonLTP1 = string2angle(strData(iLTP1, 4));
                htLTP1 = numData(iLTP1, 1);
                % LTP2
                name2 = strData(iLTP2, 2);
                latLTP2 = string2angle(strData(iLTP2, 3));
                lonLTP2 = string2angle(strData(iLTP2, 4));
                htLTP2 = numData(iLTP2, 1);
                % Runway size
                runwayWidth = 0.3048 * numData(iLTP1, 3);
                % Runway data
                runways(nRunways, :) = [latLTP1, lonLTP1, htLTP1, ...
                    latLTP2, lonLTP2, htLTP2, runwayLength, runwayWidth];
                names(nRunways, :) = [name1, name2];

            % Investigate
            otherwise
                disp("Issue with " + airport + " and length " + string(length))
        end  
    end
    if nRunways > 0
        names = names(1:nRunways, :);
        runways = runways(1:nRunways, :);
        [latA, lonA, htA] = geo_centroid([runways(:, 1:3); runways(:, 4:6)]);
        runways_data.(airport).origin = [latA, lonA, htA];
        runways_data.(airport).runways = runways;
        runways_data.(airport).names = names;
    else
        warning("Unable to recover runway data for " + airport)
    end  
end
save("runways_data.mat", "runways_data")
disp(newline + "Runways data saved at 'runways_data.mat'")

end
