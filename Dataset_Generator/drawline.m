% function [line, xdata, ydata] = drawline(color)

% Draws a line of a specified color.

% Input :
% color (color) : line color

% Output :
% line (3 1-d double array) : line homogenous coordinates
% xdata (2 1-d double array) : line endpoints X coordinates
% ydata (2 1-d double array) : line endpoints Y coordinates

function [line, xdata, ydata] = drawline(color)

if ~exist("color", "var")
    color = "black";
end

hline = gline;
moveplot(hline);
pause;
set(hline, 'Color', color, 'LineWidth', 0.1);
point1 = [hline.XData(1); hline.YData(1)];
point2 = [hline.XData(2); hline.YData(2)];
line = points2line(point1, point2)';

if nargout > 1
    xdata = [hline.XData(1), hline.XData(2)];
    ydata = [hline.YData(1), hline.YData(2)];
end