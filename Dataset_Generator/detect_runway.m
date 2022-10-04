
% function detect_runway_v2(runwayData, intrinsicMatrix, mode)

% TO DO : UPDATE DOC

function detect_runway(runwayData, calibrationData, mode)

if ~exist("mode", "var")
    mode = "manual";
end

% Main app
fig = uifigure;
fig.WindowState = 'maximized';

% Check Earth Explorer to download local terrain data
% https://www.mathworks.com/help/map/ref/addcustomterrain.html
g = geoglobe(fig); 

% Rendered image
% scrSize = get(0, "screensize");
% scrW = scrSize(3);
% scrH = scrSize(4);
% scale = 0.75;
% imW = floor(scale * scrW);
% imH = floor(scale * scrH);
fig2 = figure;
%fig2.Position = [(scrW-imW)/2, (scrH-imH)/2, imW, imH];
fig2.Visible = "off";
%fig2.WindowState = "minimized";

fig.DeleteFcn = @(src, event) close(fig2);
fig2.DeleteFcn = @(src, event) close(fig);

airports = sort(string(fieldnames(runwayData)));

if mode == "manual"

    % UI buttons
    % Airport button
    airport = "LFBO";
    if isempty(find(airports == airport, 1))
        airport = airports(1);
    end
    airportBtn = uidropdown(fig, ...
        "Items", airports, ...
        "Value", airport, ...
        "Position", [225, 225, 70, 25], ...
        "CreateFcn", @(airportBtn, event) update(g, runwayData.(airportBtn.Value), ...
        string(airportBtn.Value)), ...
        "ValueChangedFcn", @(airportBtn, event) update(g, runwayData.(airportBtn.Value), ...
        string(airportBtn.Value)));

    % Label button
    labelBtn = uidropdown(fig, ...
        "Items", {'Border', 'Segmentation', 'Bounding Box'}, ...
        "Position", [295, 225, 110, 25]);
    
    % Render button
    renderBtn = uibutton(fig, "push", ...
        "Text", "Render", ...
        "Position", [405, 225, 60, 25], ...
        "ButtonPushedFcn", @(renderBtn, event) render(fig, fig2, g, ...
        runwayData.(airportBtn.Value), calibrationData, ...
        string(airportBtn.Value), [airportBtn, labelBtn, renderBtn]));
    
    disp("Select an airport with the dropdown button then press " + renderBtn.Text);

elseif mode == "auto"
    if mkdir(".", "Gallery")
        for i=1:numel(airports)
            airport = airports(i);
            update(g, runwayData.(airport), airport);
            render(fig, fig2, g, runwayData.(airport), calibrationData, airport, []);
        end
        close(fig);
    else
        disp("Unable to create gallery folder")
    end
else
    error("Valid modes are 'manual' or 'auto'")
end

end


% Callback functions ------------------------------------------------------
function update(g, localData, newAirport)

% Updates camera

persistent airport

if isempty(airport)
    airport = "";
end

if airport ~= newAirport
    airport = newAirport;
    airportRef = localData{1};
    lat0 = airportRef(1); lon0 = airportRef(2); ht0 = airportRef(3);
    wgs84 = wgs84Ellipsoid;
    [latCam, lonCam, htCam] = aer2geodetic(0, 90, 10000, lat0, lon0, ht0, wgs84);
    campos(g, latCam, lonCam, htCam);
    campitch(g, -90);
    drawnow
    pause(2)
end

end

function render(fig, fig2, g, localData, calibrationData, newAirport, uiButtons)

% Renders labelled image

persistent airport
persistent runwaysPoses
persistent dLTP

%nVarargin = nargin + nargin("render") + 1;

% Image generation
dpi = calibrationData.dpi;
cropValue = calibrationData.cropValue;
ext = calibrationData.imageFormat;
tmp_img = "tmp." + ext;
cmd = "convert -density " + dpi + " -depth 8 -quality 100 -gravity South -chop 0x" + cropValue + " tmp.pdf " + tmp_img;

% Mode
manualMode = ~isempty(uiButtons);

% Manual mode
if manualMode
    save = false;
    for i=1:numel(uiButtons)
        btn = uiButtons(i);
        btn.Visible = "off";
    end
    exportapp(fig, 'tmp.pdf');
    for i=1:numel(uiButtons)
        btn = uiButtons(i);
        btn.Visible = "on";
    end

    % Linux
    if isunix
        status = system(cmd);
    % Windows
    elseif ispc
        status = system("magick " + cmd);
    end

    if status
        disp('Conversion error')
    else
        disp('Conversion done')
    end
% Auto mode
else
    save = true;
    drawnow
    pause(5)
    exportapp(fig, 'tmp.pdf');
    % Linux
    if isunix
        status = system(cmd);
    % Windows
    elseif ispc
        status = system("magick " + cmd);
    end

    if status
        disp('Conversion error')
    else
        disp('Conversion done')
    end
end


runways = localData.runways;
names = localData.names;
nRunways = size(runways, 1);

if isempty(airport)
    airport = "";
end

if airport ~=  newAirport
    airport = newAirport;
    
    % LTP1s
    latLTP1 = runways(:, 1);
    lonLTP1 = runways(:, 2);
    htLTP1 = runways(:, 3);
    
    % LTP2s
    latLTP2 = runways(:, 4);
    lonLTP2 = runways(:, 5);
    htLTP2 = runways(:, 6);
    
    % Runways poses
    wgs84 = wgs84Ellipsoid;
    [headingRunway, pitchRunway, dLTP] = geodetic2aer(latLTP2, lonLTP2, htLTP2, ...
        latLTP1, lonLTP1, htLTP1, wgs84);
    runwaysPoses = [latLTP1, lonLTP1, htLTP1, headingRunway, pitchRunway, zeros(nRunways, 1)];

    % LTP2 
%     names = localData{3};
%     nameLTP2 = names(1, 2);
%     if nameLTP2 == ""
%         warning("Bad LTP2 detected")
%         %dLTP = runway(7);
%     end

end
[latCam, lonCam, htCam] = campos(g);
headingCam = camheading(g);
pitchCam = campitch(g);
rollCam = camroll(g);
cameraPose = [latCam, lonCam, htCam, headingCam, pitchCam, rollCam];

% Images coordinates
allBorderPoints = zeros(2, 4*nRunways);
bbox = zeros(2, 4*nRunways);
allLTP1 = zeros(2, nRunways);
allLTP2 = zeros(2, nRunways);

% Intrinsic matrix
intrinsicMatrix = calibrationData.intrinsicMatrix;

for i=1:nRunways
    % Camera matrix
    cameraMatrix = intrinsicMatrix * z_extrinsic_matrix(...
        cameraPose, runwaysPoses(i, :));

    % LTP1
    ltp1 = [0; 0; 0];
    allLTP1(:, i) = world2image(cameraMatrix, ltp1);
    
    % LTP2
    ltp2 = [dLTP(i); 0; 0];
    allLTP2(:, i) = world2image(cameraMatrix, ltp2);
   
    % Border
    m = dLTP(i) / 2;
    L = runways(i, 7);
    W = runways(i, 8);
    borderPoints = [m-L/2, m+L/2, m+L/2, m-L/2;...
                    -W/2, -W/2, W/2, W/2;...
                    0, 0, 0, 0];

    allBorderPoints(:, 1+4*(i-1):4*i) = world2image(cameraMatrix, borderPoints);

    % Bounding box
    bbox(:, 1+4*(i-1):4*i) = get_bbox(allBorderPoints(:, 1+4*(i-1):4*i));
        
end

% Image
image = imread(tmp_img);

% Colors
colors = linspecer(nRunways+2, 'sequential');

% Label type
% TMP FIX AUTO MODE
if manualMode
    labelBtn = uiButtons(2);
    labelMask = (string(labelBtn.Items) == string(labelBtn.Value));
else
    labelMask = [1, 0, 0];
end

if labelMask(2)
    height = size(image, 1);
    width = size(image, 2);
    for i=1:nRunways
        mask = interior_mask(...
            allBorderPoints(:, 1+4*(i-1):4*i), [height, width]);
        R = uint8(255 * colors(i, 1));
        G = uint8(255 * colors(i, 2));
        B = uint8(255 * colors(i, 3));
        redMask = zeros([height, width, 3], "logical"); redMask(:, :, 1) = mask;
        greenMask = zeros([height, width, 3], "logical"); greenMask(:, :, 2) = mask;
        blueMask = zeros([height, width, 3], "logical"); blueMask(:, :, 3) = mask;
        image(redMask) = R; image(greenMask) = G; image(blueMask) = B;
    end
end

% Labels
names = reshape(names', 2*nRunways, 1);

% Single LTP runways
indices = find(names == "");
names(indices) = names(indices-1) + "-OP";

labels = strings(3*nRunways, 1);
labels(1:3:end) = "Runway " + string(1:nRunways)';
labels(2:3:end) = names(1:2:end);
labels(3:3:end) = names(2:2:end);

% Plot
%clf(fig2, "reset")
%figure(fig2)
fig2.Visible = "off";
imshow(image);
hold on;

for i=1:nRunways
    idx = [4*i, 1+4*(i-1):4*i];
    if labelMask(1) || labelMask(2)
        plot(allBorderPoints(1, idx), allBorderPoints(2, idx), 'LineWidth', 2, "Color", colors(i, :));
    elseif labelMask(3)
        plot(bbox(1, idx), bbox(2, idx), 'LineWidth', 3, "Color", colors(i, :));
    end
    plot(allLTP1(1, i), allLTP1(2, i), 'o', 'MarkerSize', 6, ...
        'MarkerFaceColor', colors(end-1, :), ...
        'MarkerEdgeColor', colors(end-1, :));
    plot(allLTP2(1, i), allLTP2(2, i), 'o', 'MarkerSize', 6, ...
        'MarkerFaceColor', colors(end, :), ...
        'MarkerEdgeColor', colors(end, :));
end

hold off;
legend(labels)

% TMP FIX AUTO MODE
if manualMode
    labelName = string(labelBtn.Items(labelMask));
else
    labelName = "Border";
end
title(labelName + " " + airport)

drawnow
fig2.WindowState = "minimized";
fig2.WindowState = "normal";
fig2.Visible = "on";

if save
    saveas(fig2, fullfile("Gallery", airport + "." + ext));
end

end

