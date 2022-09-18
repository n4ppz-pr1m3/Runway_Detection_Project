clc; clear; close all;

dataLTP = load_dataLTP;

% LTP
ltp = dataLTP(1, :);
latLTP = string2angle(ltp(2));
lonLTP = string2angle(ltp(3));
htLTP = double(ltp(4));

% Plot
fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig);

% Initial camera
wgs84 = wgs84Ellipsoid;
[latCam, lonCam, htCam] = aer2geodetic(0, 90, 500, ...
    latLTP, lonLTP, htLTP, wgs84);
campos(g, latCam, lonCam, htCam);
campitch(g, -90);

disp("Press Return to render the image")
pause
exportapp(fig, 'tmp.pdf');
cmd = "convert -density 96 -depth 8 -quality 100 -gravity South -chop 0x11 tmp.pdf tmp.png";

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
close(fig)
%%
clc;
colors = ["blue", "green"];
xVanishingPoint = zeros(1, 2);
yVanishingPoint = zeros(1, 2);
imshow("tmp.png")
hold on;
for i=1:2
    disp("Draw 2 parallel world lines")
    [line1, x1, y1] = drawline;
    [line2, x2, y2] = drawline;
    [xVanishingPoint(i), yVanishingPoint(i)] = line_intersection(line1, line2);
    plot([x1, xVanishingPoint(i)], [y1, yVanishingPoint(i)], "Color", colors(i));
    plot([x2, xVanishingPoint(i)], [y2, yVanishingPoint(i)], "Color", colors(i));
end
%plot(xVanishingPoint, yVanishingPoint, 'r');
title("Vanishing points")
xlim("auto")
ylim("auto")
hold off;

