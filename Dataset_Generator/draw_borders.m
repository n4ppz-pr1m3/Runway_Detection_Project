function draw_borders(image_path, corners, save_path)

fig = imshow(image_path);
hold on;
plot([corners(1, :), corners(1, 1)], [corners(2, :), corners(2, 1)]);
hold off;
saveas(fig, save_path);
close(fig);

end

