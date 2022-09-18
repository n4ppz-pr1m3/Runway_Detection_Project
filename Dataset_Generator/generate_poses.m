function [poses_data, poses_count] = generate_poses(airports_data, param1, param2, param3, coord_type)

airports = string(fieldnames(airports_data));
nAirports = numel(airports);
poses_count = nAirports * numel(param1) * numel(param2) * numel(param3);
poses_data = [];
offset = 0;
for i=1:nAirports
    airport = airports(i);
    airport_data = airports_data.(airport);
    airport_origin = airport_data{1};
    cameraPoses = coord2poses(param1, param2, param3, coord_type, airport_origin);
    poses_data.(airport) = cameraPoses;
    offset = offset + size(cameraPoses, 1);
end
end

