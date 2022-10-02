
% function data = read_json(filename)

% Converts json data to matlab struct data.

% Input :
% filename (string) : path to json file

% Output :
% data (struct) : converted json data

function data = read_json(filename)
fileId = fopen(filename); 
raw_data = fread(fileId, inf); 
string_data = char(raw_data'); 
fclose(fileId); 
data = jsondecode(string_data);
end
