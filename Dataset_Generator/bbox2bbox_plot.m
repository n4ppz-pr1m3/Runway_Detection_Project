function bbox_plot = bbox2bbox_plot(bbox)
xMin = bbox(1);
yMin = bbox(2);
xMax = bbox(3);
yMax = bbox(4);
bbox_plot = [xMin, xMin, xMax, xMax, xMin;...
             yMin, yMax, yMax, yMin, yMin];
end

