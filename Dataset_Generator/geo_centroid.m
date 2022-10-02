% function [latC, lonC, htC] = geo_centroid(geoData)

% Compute the geodetic coordinates of a set of points's centroid.

% Input :
% geoData (N*3 2-d double array) : geodetic coordinates of input points

% Output :
% latC (double) : centroid latitude
% lonC (double) : centroid longitude
% htC (double) : centroid height

function [latC, lonC, htC] = geo_centroid(geoData)

% Input points cartesian coordinates
wgs84 = wgs84Ellipsoid;
[x, y, z] = geodetic2enu(geoData(:, 1), geoData(:, 2), geoData(:, 3), ...
    geoData(1, 1), geoData(1, 2), geoData(1, 3), wgs84);

% Centroid cartesian coordinates
centroid = mean([x, y, z]);

% Centroid geodetic coordinates
[latC, lonC, htC] = enu2geodetic(centroid(1), centroid(2), centroid(3), ...
    geoData(1, 1), geoData(1, 2), geoData(1, 3), wgs84);

end

