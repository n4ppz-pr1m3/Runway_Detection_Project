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

