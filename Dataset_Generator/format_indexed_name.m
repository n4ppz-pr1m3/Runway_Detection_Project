
% function name = format_indexed_name(basename, index, pad_value)

% Composes a string and a number to form an indexed string with set padding
% value.

% Example : format_indexed_name("image", 5, 3) = "image005".

% Input :
% basename (string) : base string
% index (integer) : string index
% pad_value (integer) : padding value

% Output :
% name (string) : composed string

function name = format_indexed_name(basename, index, pad_value)
name  = strcat(basename, pad(int2str(index), pad_value, "left", '0'));
end