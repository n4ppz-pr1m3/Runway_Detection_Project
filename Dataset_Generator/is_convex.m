% function [bool, verticesOrdering] = is_convex(polygon)

% Checks if a polygon is convex and non self-intersecting

% If the polygon is convex and non self-intersecting, specify also the
% vertices ordering. Otherwise, verticesOrdering is an empty string.

% Input :
% polygon (2xN 2-d double array) : polygon vertices cartesian coordinates 

% Output :
% bool (boolean) : polygon convexity test return value
% verticesOrdering (string) : "clockwise|counter-clockwise|"""

function [bool, verticesOrdering] = is_convex(polygon)

if (numel(size(polygon)) ~= 2) || (size(polygon, 1) ~= 2) || (size(polygon, 2) < 3)
    error("Polygon is expected to have size 2xN, N >= 3")
end

% shape_test_1 = numel(size(polygon)) == 2;
% shape_test_2 = size(polygon, 1) == 2;
% shape_test_3 = size(polygon, 2) >= 3;
% assert(shape_test_1 && shape_test_2 && shape_test_3, "Polygon is expected to have size 2xN, N >= 3");

nVertices = size(polygon, 2);

% Vertices ordering
verticesOrdering = "";

% Direct interior angles orientation | Clockwise vertices ordering
orientation = "direct";
v1 = polygon(:, end) - polygon(:, 1);
v2 = polygon(:, 2) - polygon(:, 1);
alt180 = angleLessThan180(v1, v2);
if ~alt180
    alt180 = true;
    orientation = "indirect";
end

vecSeq = zeros(2, nVertices);
xSignChange = 0;
ySignChange = 0;
i = 0;
while (i < nVertices) && alt180 && (xSignChange <= 2) && (ySignChange <= 2)
    iPrev = mod(i-1, nVertices) + 1;
    iCur = i + 1;
    iNext = mod(i+1, nVertices) + 1;
    v1 = polygon(:, iPrev) - polygon(:, iCur);
    v2 = polygon(:, iNext) - polygon(:, iCur);
    alt180 = angleLessThan180(v1, v2, orientation);

    % Tracks sign changes for non horizontal or vertical edges
    vecSeq(:, iCur) = v2;
    signs = sign(-v1) .* sign(v2);
    if signs(1) == -1
        xSignChange = xSignChange + 1;
    end
    if signs(2) == -1
        ySignChange = ySignChange + 1;
    end

    i = i + 1;
end

% Tracks sign changes for all edges
if alt180 && ((xSignChange < 2) || (ySignChange < 2))
    if xSignChange < 2
        xSignChange = sign_changes(vecSeq(1, :));
    end
    if ySignChange < 2
        ySignChange = sign_changes(vecSeq(2, :));
    end
end

bool = alt180 && (xSignChange == 2) && (ySignChange == 2);
if nargout > 1
    if bool && (orientation == "direct")
        verticesOrdering = "clockwise";
    elseif bool && (orientation == "indirect")
        verticesOrdering = "counter-clockwise";
    end
end

end


% function count = sign_changes(v)

% Counts the number of sign changes in a vector

function count = sign_changes(v)

if (numel(size(v)) ~= 2) || ((size(v, 1) ~= 1) && (size(v, 2) ~= 1))
    error("v must be a 1-d array")
end

signs = sign(v);
index = find(signs ~= 0, 1);
count = 0;
if isempty(index)
    return
end

curSign = signs(index);
n = numel(v);
for i=1:n
    nextIndex = mod(index - 1 + i, n) + 1;
    if signs(nextIndex) == -curSign
        curSign = -curSign;
        count = count + 1;
    end
end

end
