function [poses, names] = coord2poses(...
    coordinates1, coordinates2, coordinates3, coordinatesType, origin)

% Compute poses of an object based on its locations expressed in
% the specified coordinates system w.r.t. the specified origin.

% The locations of the object and the origin are expressed in geodetic
% coordinates (WGS84). The orientations of the object are such that the
% object is always aiming at the origin. Each set of orientation angles are
% w.r.t the ENU reference frame at the object's location.

% Input :
% origin (3 1-d double array) : origin's geodetic coordinates
% Object's coordinates
% coordinates1 (1-d double array) : first set of coordinates
% coordinates2 (1-d double array) : second set of coordinates
% coordinates3 (1-d double array) : third set of coordinates
% coordinatesType (string) : coordinates system
% coordinatesType = 'cylindrical'|'spherical'

% Output :
% poses (Nx6 2-d double array) : object's poses
% names (1-d string array) : names associated with each pose

% Notes :
% The number of output poses is : numel(coordinates1) * numel(coordinates2) * numel(coordinates3)

% Each pose is a 6-elements vector such that :
% latitudeObject = pose(1)
% longitudeObject = pose(2)
% heightObject = pose(3)
% headingObject = pose(4)
% pitchObject = pose(5)
% rollObject = pose(6)

% Only cylindrical and spherical coordinates systems are supported.

if coordinatesType == "cylindrical"
    theta = coordinates1;
    r = coordinates2;
    h = coordinates3;
    poses = cylindrical2poses(theta, r, h, origin);
    
elseif coordinatesType == "spherical"
    theta = coordinates1;
    phi = coordinates2;
    r = coordinates3;
    poses = spherical2poses(theta, phi, r, origin);
    
else
    poses = [];
    names = [];
    error(coordinatesType + " is not a supported coordinates system")
end

end



