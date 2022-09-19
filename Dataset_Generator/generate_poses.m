function [poses_data, poses_count] = generate_poses(airports_data, coord_type, param1, param2, param3,...
                                                   basename, offset)

airports = string(fieldnames(airports_data));
nAirports = numel(airports);
poses_count = nAirports * numel(param1) * numel(param2) * numel(param3);
poses_data = [];
for i=1:nAirports
    % Camera poses
    airport = airports(i);
    airport_data = airports_data.(airport);
    airport_origin = airport_data{1};
    cameraPoses = coord2poses(coord_type, param1, param2, param3, airport_origin);

    % Poses names
    nPoses = size(cameraPoses, 1);
    poses_names = basename + pad(string(offset+1:offset+nPoses), 8, "left", "0");
    offset = offset + nPoses;

    poses_data.(airport) = {poses_names, cameraPoses};
end
end

