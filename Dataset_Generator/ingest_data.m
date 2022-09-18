clc; close all; clear;

% TO DO : Check bearings / get single LTP

rawData = "airports.xlsx";
sample = 1:20;
T1 = readtable(rawData, 'sheet', 1);

strData = string(T1{:, ["Airport", "Runway", "LatitudeLTP", "LongitudeLTP", "LatitudeFPAP", "LongitudeFPAP"]});
numData = [double(string(T1{:, "HeightLTP"})), T1{:, ["Length", "Width", "Elevation"]}, double(string(T1{:, "MagBearing"}))];

airports = unique(strData(:, 1));
disp(string(numel(airports)) + " airports")

runwayData = [];
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
        runwayData.(airport) = {[latA, lonA, htA], runways, names};
    else
        warning("Unable to recover runway data for " + airport)
    end   
end
save("runwayData.mat", "runwayData")
