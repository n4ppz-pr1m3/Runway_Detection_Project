% function weights = wachspress_coordinates(p, polygon)

% Compute the wachspress coordinates of a point w.r.t. the vertices of a
% convex polygon.

% "Rational Finite Element Basis" (1975, Eugene Wachspress)

% The weight w_i associated to vertex i is computed as follows:
% w_i = A(V_{i-1}V_{i}V_{i+1}) / ( A(V_{i-1}V_{i}P) * A(V_{i}V_{i+1}P) )
% where A(abc) is the signed area of the triangle abc.

% Input :
% p (2 1-d double array) : coordinates of the point
% polygon (2xN 2-d double array) : polygon vertices cartesian coordinates

% Output :
% weights (1-d double array) : computed weights

function weights = wachspress_coordinates(p, polygon)

if (numel(size(p)) ~= 2) || (size(p, 2) ~= 1)
    error("p is expected to be a length 2 column vector")
elseif ~is_convex(polygon)
    error("polygon is expected to be convex")
end

v = polygon - p;
nVertices = size(polygon, 2);
trianglesAreas = zeros(1, nVertices);
for i=0:nVertices-1
    iCur = mod(i, nVertices) + 1;
    iNext = mod(i+1, nVertices) + 1;
    trianglesAreas(iCur) = 0.5 * (v(1, iNext)*v(2, iCur) - v(2, iNext)*v(1, iCur));
end


weigths = zeros(1, nVertices);
weightsSum = 0;

for i=0:nVertices-1
    iPrev = mod(i-1, nVertices) + 1;
    iCur = mod(i, nVertices) + 1;
    iNext = mod(i+1, nVertices) + 1;
    vPrev = polygon(:, iPrev) - polygon(:, iCur);
    vNext = polygon(:, iNext) - polygon(:, iCur);
    weigths(iCur) = 0.5*(vPrev(1)*vNext(2) - vPrev(2)*vNext(1)) / ...
        (trianglesAreas(iPrev) * trianglesAreas(iCur) + eps);
    weightsSum = weightsSum + weigths(iCur);
end

weights = weigths / weightsSum;
