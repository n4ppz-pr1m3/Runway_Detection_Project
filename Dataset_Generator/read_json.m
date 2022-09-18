function data = read_json(filename)
fileId = fopen(filename); 
raw_data = fread(fileId, inf); 
string_data = char(raw_data'); 
fclose(fileId); 
data = jsondecode(string_data);
end
