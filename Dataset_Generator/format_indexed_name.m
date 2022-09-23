function name = format_indexed_name(basename, index, pad_value)
name  = strcat(basename, pad(int2str(index), pad_value, "left", '0'));
end