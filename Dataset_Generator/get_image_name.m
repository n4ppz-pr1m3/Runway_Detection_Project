function image_name = get_image_name(basename, image_index)
image_name  = basename + pad(string(image_index), 8, "left", "0");
end

