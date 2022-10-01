% function draw_bounding_boxes(airport, image_path, save_path, fig, colors, runways_bounding_boxes)

% Draws the runways bounding boxes on an airport image.

% The bounding boxes are specified by their top-left/bottom-right corners
% in the format [xMin, yMin, xMax, yMax].

% Input :
% airport (string) : airport name
% image_path (string) : path to the image file
% save_path (string) : save path of the edited image
% fig (figure handle) : figure object used to display the image
% colors (Nx3 2-d double array) : set of RGB colors
% runways_bounding_boxes (Nx4 2-d double array) : bounding boxes of the airport's runways

function draw_bounding_boxes(airport, image_path, save_path, fig, colors, runways_bounding_boxes)

imshow(image_path);
hold on;
nRunways = size(runways_bounding_boxes, 1);
for i=1:nRunways
    runway_bbox = runways_bounding_boxes(i, :);
    runway_bbox_plot = bbox2bbox_plot(runway_bbox);
    plot(runway_bbox_plot(1, :), runway_bbox_plot(2, :), "LineWidth", 2, "Color", colors(i, :));
end
hold off;
title(airport + " Bounding boxes")
saveas(fig, save_path);

end

