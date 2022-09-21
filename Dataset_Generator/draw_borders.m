function draw_borders(airport, image_path, save_path, fig, colors, runways_corners)

imshow(image_path);
hold on;
nRunways = size(runways_corners, 3);
for i=1:nRunways
    runway_corners = runways_corners(:, :, i);
    plot([runway_corners(1, :), runway_corners(1, 1)],...
        [runway_corners(2, :), runway_corners(2, 1)],...
        "LineWidth", 1, "Color", colors(i, :));
end
hold off;
title(airport + " Borders")
saveas(fig, save_path);

end
