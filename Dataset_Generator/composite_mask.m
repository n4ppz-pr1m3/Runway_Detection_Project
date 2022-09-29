% function mask = composite_mask(masks)

% Computes a matrix with the same filling pattern as a logical OR of a set
% of masks (logical 2-d matrix) such that the non zeros locations of the ith
% mask are set to i in the new matrix if they were null in all the previous masks.

% Example :
% Input masks:
% [1, 0, 0;  , [0, 0, 1; , [0, 0, 0;
%  0, 1, 0;  ,  0, 1, 0; ,  0, 0, 0;
%  0, 0, 1]  ,  1, 0, 0] ,  1, 1, 1]

% Output composite mask:
% [1, 0, 2;
%  0, 1, 0;
%  2, 3, 1]

% Input :
% masks (MxNxP 3-d logical array) : P input masks

% Output :
% mask (MxN 2-d integer array) : output mask

function mask = composite_mask(masks)
mask = zeros(size(masks, 1:2), "uint8");
filled_indices = [];
nMasks = size(masks, 3);
for i=1:nMasks
    indices = setdiff(find(masks(:, :, i)), filled_indices);
    mask(indices) = i;
    filled_indices = union(indices, filled_indices);
end

