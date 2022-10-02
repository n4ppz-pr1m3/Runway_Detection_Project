% function [x_bbox, y_bbox] = bbox2bbox_plot(bbox)

% Computes the xy-coordinates of a set of bounding boxes required for drawing
% them.

% Each input bounding box is specified by its top-left/bottom right corners
% in the form of the 4-vector [xMin, yMin, xMax, yMax].

% Input :
% bbox (Nx4 2-d double array) : bounding boxes vectors

% Output :
% x_bbox (Nx5 1-d double array) : bounding boxes x-coordinates
% y_bbox (Nx5 1-d double array) : bounding boxes y-coordinates

function [x_bbox, y_bbox] = bbox2bbox_plot(bbox)

if (numel(size(bbox)) ~= 2) || (size(bbox, 2) ~= 4)
    error("bbox is expected to be Nx4")
end

xMin = bbox(:, 1);
yMin = bbox(:, 2);
xMax = bbox(:, 3);
yMax = bbox(:, 4);
x_bbox = [xMin, xMin, xMax, xMax, xMin];
y_bbox = [yMin, yMax, yMax, yMin, yMin];
end

