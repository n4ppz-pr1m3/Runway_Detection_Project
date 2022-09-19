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
title(airport)
saveas(fig, save_path);

end

