function image_name = get_image_name(basename, image_index, pad_value)
image_name  = strcat(basename, pad(int2str(image_index), pad_value, "left", '0'));
end

