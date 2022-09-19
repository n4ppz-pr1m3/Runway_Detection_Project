function [poses_data, poses_count] = generate_poses(airports_data, coord_type, param1, param2, param3)

airports = string(fieldnames(airports_data));
nAirports = numel(airports);
poses_count = nAirports * numel(param1) * numel(param2) * numel(param3);
poses_data = [];
for i=1:nAirports
    airport = airports(i);
    airport_data = airports_data.(airport);
    airport_origin = airport_data{1};
    cameraPoses = coord2poses(coord_type, param1, param2, param3, airport_origin);
    poses_data.(airport) = cameraPoses;
end
end

