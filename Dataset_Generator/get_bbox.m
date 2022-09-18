function [bbox_plot, bbox_corners, bbox_center_size] = get_bbox(points)

% Compute the bounding box coordinates of a set of 2d points

if (numel(size(points)) ~= 2) || (size(points, 1) ~= 2)
    error("points is expected to have size 2xN")
end

xMin = min(points(1, :));
xMax = max(points(1, :));
yMin = min(points(2, :));
yMax = max(points(2, :));

bbox_corners = [xMin, yMin, xMax, yMax];
bbox_center_size = [(xMin+xMax)/2, (yMin+yMax)/2, xMax-xMin, yMax-yMin];

bbox_plot = [xMin, xMax, xMax, xMin;...
        yMin, yMin, yMax, yMax];

end

