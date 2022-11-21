
% function draw_borders(image_id, image_path, save_path, fig, colors, runways_corners)

% Draws the runways borders on an airport image.

% Input :
% image_id (string) : image identifier
% image_path (string) : path to the image file
% save_path (string) : save path of the edited image
% fig (figure handle) : figure object used to display the image
% colors (Nx3 2-d double array) : set of RGB colors
% runways_corners (2x4xN 2-d double array) : image coordinates of the 4 corners of the airport's runways

function draw_borders(image_id, image_path, save_path, fig, colors, runways_corners)

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
title(image_id + " Borders", 'Interpreter', 'none');
drawnow;
saveas(fig, save_path);

end
