function mask = composite_mask(masks)
mask = zeros(size(masks, 1:2), "uint8");
filled_indices = [];
nMasks = size(masks, 3);
for i=1:nMasks
    indices = setdiff(find(masks(:, :, i)), filled_indices);
    mask(indices) = i;
    filled_indices = union(indices, filled_indices);
end

