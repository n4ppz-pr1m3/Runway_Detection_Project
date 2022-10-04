
% function K = vanishing_points_intrinsic

% Computes the intrinsic matrix from 3 mutually orthogonal vanishing
% points.

% Example :
% NYC
% lat = 40.7;
% lon = -74;
% ht = 1500;

% Input :
% Initial world location gps coordinates
% lat (double) : latitude
% lon (double) : longitude
% ht (double) : height

% Output :
% K (3x3 2-d double array) : intrinsic matrix

function K = vanishing_points_intrinsic(lat, lon, ht)

% Plot
fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig);

% Initial camera
wgs84 = wgs84Ellipsoid;
[latCam, lonCam, htCam] = aer2geodetic(0, 90, 500, ...
    lat, lon, ht, wgs84);
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

colors = ["red", "green", "blue"];
vanishingPoints = zeros(3, 3);
imshow("tmp.png")
hold on;
disp("Draw 3 sets of mutually orthogonal world lines")
for i=1:3
    disp("Draw 2 parallel world lines")
    [line1, x1, y1] = drawline;
    [line2, x2, y2] = drawline;
    vanishingPoint = homogenous_intersection(line1, line2);
    xVP = vanishingPoint(1) / vanishingPoint(3);
    yVP = vanishingPoint(2) / vanishingPoint(3);
    plot([x1, xVP], [y1, yVP], "Color", colors(i));
    plot([x2, xVP], [y2, yVP], "Color", colors(i));
    vanishingPoints(i, :) = vanishingPoint;
end
title("Vanishing points")
xlim("auto")
ylim("auto")
hold off;

A = zeros(3, 4);
for i=0:2
    iCur = mod(i, 3) + 1;
    iNext = mod(i+1, 3) + 1;
    x1 = vanishingPoints(iCur, 1);
    y1 = vanishingPoints(iCur, 2);
    w1 = vanishingPoints(iCur, 3);
    x2 = vanishingPoints(iNext, 1);
    y2 = vanishingPoints(iNext, 2);
    w2 = vanishingPoints(iNext, 3);
    % Linear constraint on the IAC
    % v1'*omgea*v2 = 0
    A(iCur, :) = [x1*x2 + y1*y2, x1*w2 + x2*w1, y1*w2 + y2*w1, w1*w2];
end

% IAC estimate
[~, ~, V] = svd(A);
p = V(:, end);
omega = [p(1), 0, p(2);...
         0, p(1), p(3);...
         p(2), p(3), p(4)];
[R, flag] = chol(omega);
if flag
    disp("Unsuccesful factorization")
else
    disp("Successful vanishing points intrinsic estimation")
    K = inv(R);
end

end