
% function write_json(data, filename)

% Converts matlab struct to json.

% Input:
% data (struct) : input struct
% filename (string) : json file output path

function write_json(data, filename)
fileId = fopen(filename, 'w');
json_data = jsonencode(data);
fprintf(fileId, json_data);
fclose(fileId);
end