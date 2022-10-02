% function [poses_data, poses_count] = generate_poses(airports_data, coord_type, param1, param2, param3, offset)

% Generates poses data from camera coordinates.

% Input :
% airports_data (airports data struct) : airports data
% coord_type (string) : coordinates system ('cylindrical'|'spherical')
% param1 (1-d double array) : set of first components coordinates
% param2 (1-d double array) : set of second components coordinates
% param3 (1-d double array) : set of third components coordinates
% offset (integer) : initial offset value

% Output :
% poses_data (poses data struct) : poses data
% poses_count (integer) : number of poses generated

function [poses_data, poses_count] = generate_poses(airports_data, coord_type, param1, param2, param3, offset)

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
    poses_data.(airport).poses = cameraPoses;

    % Poses offset
    poses_data.(airport).offset = offset;
    offset = offset + size(cameraPoses, 1);  
end
end

