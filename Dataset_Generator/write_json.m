function write_json(data, filename)
fileId = fopen(filename, 'w');
json_data = jsonencode(data);
fprintf(fileId, json_data);
fclose(fileId);
end