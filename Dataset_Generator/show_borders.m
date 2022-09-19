function show_border(image_path, corners)

imshow(image_path);
hold on;
plot([corners(1, :), corners(1, 1)], [corners(2, :), corners(2, 1)]);
hold off;

end

