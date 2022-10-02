
% function M = ned2ned(newOrigin, oldOrigin)

% Compute the transformation matrix between two NED reference frames

% Input :
% newOrigin (3 1-d double array) : origin of the new NED frame
% oldOrigin (3 1-d double array) : origin of the old NED frame

% Output :
% M (3*4 2-d double array) : rigid body transformation matrix

% Notes
% M = [R t]
% R := [xNorthOld; yEastOld; zDownOld]: old NED basis vectors expressed in
% the new NED reference frame, rotation part of the transformation
% t : translation part of the transformation

% origin := [lat, lon, ht]
% lat (double) : geodetic coordinates of the NED origin
% lon (double) :                    -
% ht (double) :                     -

function M = ned2ned(newOrigin, oldOrigin)

wgs84 = wgs84Ellipsoid;

% New NED's origin
latNew = newOrigin(1); lonNew = newOrigin(2); htNew = newOrigin(3);

% Old NED's origin
latOld = oldOrigin(1); lonOld = oldOrigin(2); htOld = oldOrigin(3);

% components of the old ENU's basis vectors
xLocal = [1, 0, 0];
yLocal = [0, 1, 0];
zLocal = [0, 0, 1];

% conversion of vector components in global ECEF
[xECEF, yECEF, zECEF] = ned2ecefv(xLocal, yLocal, zLocal, latOld, lonOld);

% conversion of vector components in new NED
[xNew, yNew, zNew] = ecef2nedv(xECEF, yECEF, zECEF, latNew, lonNew);

% rotation component
R = [xNew; yNew; zNew];

% cartesian coordinates w.r.t the new NED of old NED's origin
[xOldOrigin, yOldOrigin, zOldOrigin] = geodetic2ned(latOld, lonOld, htOld, ...
    latNew, lonNew, htNew, wgs84);

% translation component
t = [xOldOrigin; yOldOrigin; zOldOrigin];

% final matrix
M = [R t];

end