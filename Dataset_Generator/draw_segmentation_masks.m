
% function draw_segmentation_masks(image_id, image_path, save_path, fig, colors, runways_segmentation_masks)

% Applies segmentation masks on an airport image.

% Input :
% image_id (string) : image identifier
% image_path (string) : path to the image file
% save_path (string) : save path of the edited image
% fig (figure handle) : figure object used to display the image
% colors (Nx3 2-d double array) : set of RGB colors
% runways_segmentation_masks (HxWxN 3-d logical array) : segmentation masks of the airport's runways

function draw_segmentation_masks(image_id, image_path, save_path, fig, colors, runways_segmentation_masks)

image = imread(image_path);
height = size(image, 1);
width = size(image, 2);
nRunways = size(runways_segmentation_masks, 3);
for i=1:nRunways
    mask = (runways_segmentation_masks(:, :, i) == i);
    R = uint8(255 * colors(i, 1));
    G = uint8(255 * colors(i, 2));
    B = uint8(255 * colors(i, 3));
    redMask = zeros([height, width, 3], "logical"); redMask(:, :, 1) = mask;
    greenMask = zeros([height, width, 3], "logical"); greenMask(:, :, 2) = mask;
    blueMask = zeros([height, width, 3], "logical"); blueMask(:, :, 3) = mask;
    image(redMask) = R;
    image(greenMask) = G;
    image(blueMask) = B;
end
imshow(image);
title(image_id + " Segmentation", "Interpreter", "none");
drawnow;
saveas(fig, save_path);

end