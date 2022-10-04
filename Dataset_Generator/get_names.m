
% function [folder, names, ext] = get_names(folder)

% Returns the parent folder, name and extension of each file contained in an input folder. 

% Input :
% folder (string) : folder path

% Output :
% folder (1-d string array) : parent folders
% names (1-d string array) : file names (without extension)
% ext (1-d string array) : file extensions

function [folder, names, ext] = get_names(folder)

listing = dir(folder);

not_empty = cellfun(@not_zero, {listing.bytes});
not_dir = cellfun(@is_file, {listing.isdir});
valid = ~cellfun("isempty", {listing.date});

[folder, names, ext] = fileparts(string({listing(not_empty & not_dir & valid).name}));

    function bool = not_zero(bytes)
        bool = (bytes ~= 0);
    end

    function bool = is_file(is_dir)
        bool = ~is_dir;
    end

end

