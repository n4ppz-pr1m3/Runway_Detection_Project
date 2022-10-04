
% function poses = cylindrical2poses(theta, r, h, origin)

% Computes poses of an object based on its locations expressed in
% cylindrical coordinates w.r.t. the specified origin.

% The locations of the object and the origin are expressed in geodetic
% coordinates (WGS84). The orientations of the object are such that the
% object is always aiming at the origin. Each set of orientation angles are
% w.r.t the ENU reference frame at the object's location.

% The number of output poses is : numel(theta) * numel(r) * numel(h)

% Each pose is a 6-elements vector such that :
% latitudeObject = pose(1)
% longitudeObject = pose(2)
% heightObject = pose(3)
% headingObject = pose(4)
% pitchObject = pose(5)
% rollObject = pose(6)

% Input :
% Object's cylindrical coordinates
% theta (1-d double array) : angular coordinates (degrees)
% r (1-d double array) : radial coordinates
% h (1-d double array) : elevation coordinates
% origin (3 1-d double array) : origin's geodetic coordinates

% Output :
% poses (Nx6 2-d double array) : object's poses

function poses = cylindrical2poses(theta, r, h, origin)

nR = numel(r);
nTh = numel(theta);
theta = reshape(theta, [], 1);
nH = numel(h);
nPoses = nR * nTh * nH;
poses = zeros(nPoses, 6);

% Origin's geodetic coordinates
latOrigin = origin(1);
lonOrigin = origin(2);
htOrigin = origin(3);

% Reference ellipsoid
wgs84 = wgs84Ellipsoid;

% Object poses
for i=1:nR
    for j=1:nH
        % Cartesian coordinates
        [x, y, z] = pol2cart(deg2rad(theta), r(i)*ones(size(theta)), h(j)*ones(size(theta)));

        % Geodetic coordinates
        [lat, lon, ht] = enu2geodetic(x, y, z, latOrigin, lonOrigin, htOrigin, wgs84);

        % Orientation
        [heading, pitch, ~] = geodetic2aer(latOrigin, lonOrigin, htOrigin, ...
            lat, lon, ht, wgs84);

        index = (i-1)*nH*nTh + (j-1)*nTh + 1;
        range = index:index+nTh-1;
        poses(range, 1:3) = [lat, lon, ht];
        poses(range, 4:5) = [heading, pitch];
    end
end

end
