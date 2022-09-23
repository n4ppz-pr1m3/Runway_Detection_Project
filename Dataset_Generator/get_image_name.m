function image_name = get_image_name(basename, image_index, pad_value)
image_name  = strcat(basename, pad(int2str(image_index), pad_value, "left", '0'));
end



% function name = format_indexed_name(basename, index, pad_value)
% name  = strcat(basename, pad(int2str(index), pad_value, "left", '0'));
% end