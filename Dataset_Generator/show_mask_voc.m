
% function show_mask_voc(mask_file)

% Visualize masks in Pascal VOC format.

% Input :
% mask_file (string) : mask image filename

function show_mask_voc(mask_file)

img_mask = double(imread(mask_file));
class_mask = img_mask ~= 0;
figure;
imshow(class_mask);
title("Class mask")
height = size(img_mask, 1);
width = size(img_mask, 2);
instance_masks = zeros(height, width, 3);
n_colors = max(img_mask, [], 'all');
colors = linspecer(n_colors, 'sequential');
for i=1:n_colors
    sub_mask = img_mask == i;
    redMask = zeros([height, width, 3], "logical"); redMask(:, :, 1) = sub_mask;
    greenMask = zeros([height, width, 3], "logical"); greenMask(:, :, 2) = sub_mask;
    blueMask = zeros([height, width, 3], "logical"); blueMask(:, :, 3) = sub_mask;
    instance_masks(redMask) = colors(i, 1);
    instance_masks(greenMask) = colors(i, 2);
    instance_masks(blueMask) = colors(i, 3);
end
figure;
imshow(instance_masks);
title("Instance masks")

end

