% function M = interior_mask(polygon, imageSize)

% Computes the mask associated with the interior of a convex polygon drawn
% on an image by use of a scanline algorithm.

% The polygon does not have to lie partially or entirely in the image.

% Input :
% polygon (2xN 2-d double array) : polygon vertices cartesian coordinates
% imageSize (2 1-d double array) : image size

% Output :
% M (2-d double array) : interior mask

function M = interior_mask(polygon, imageSize)

if ~is_convex(polygon)
    error("polygon is expected to be convex")
end

height = imageSize(1);
width = imageSize(2);
M = zeros(height, width, "logical");

xMin = min(polygon(1, :));
xMax = max(polygon(1, :));
xRange = common_range(round(xMin), round(xMax), 1, width);
if isempty(xRange)
    return
end

yMin = min(polygon(2, :));
yMax = max(polygon(2, :));
yRange = common_range(round(yMin), round(yMax), 1, height);
if isempty(yRange)
    return
end
    
nEdges = size(polygon, 2);

% Range values for each edge
lines = [polygon; polygon(:, 2:end), polygon(:, 1)];
lines = lines';

% Lines with edges direction
homogenous_lines = zeros(nEdges, 3);
for i=0:nEdges-1
    iCur = mod(i, nEdges) + 1;
    iNext = mod(i + 1, nEdges) + 1;
    curPoint = polygon(:, iCur);
    nextPoint = polygon(:, iNext);
    homogenous_lines(iCur, :) = points2line(curPoint, nextPoint);
end
    

xyIntersect = zeros(1, nEdges);
idx = zeros(size(xyIntersect), "logical");

if abs(xRange(2)-xRange(1)) < abs(yRange(2)-yRange(1))
    for x=xRange(1):xRange(2)
        vertical_line = [-1; 0; x];
        for i=1:nEdges 
            [~, xyIntersect(i)] = line_intersection(...
                vertical_line, homogenous_lines(i, :));
            %[~, xyIntersect(i)] = line_intersection(x, lines(i, :));
            idx(i) = (lines(i, 2) <= xyIntersect(i) && xyIntersect(i) <= lines(i, 4)) ...
                || (lines(i, 4) <= xyIntersect(i) && xyIntersect(i) <= lines(i, 2));
        end

        valid_y = xyIntersect(idx);
        if ~isempty(valid_y)
            yInt1 = max([min(round(valid_y)), 1]);
            yInt2 = min([max(round(valid_y)), height]);
            M(yInt1:yInt2, x) = 1;
        end
    end

else
    for y=yRange(1):yRange(2)
        horizontal_line = [0; -1; y];
        for i=1:nEdges
            [xyIntersect(i), ~] = line_intersection(...
                horizontal_line, homogenous_lines(i, :));
            %[xyIntersect(i), ~] = line_intersection([0, y], lines(i, :));
            idx(i) = (lines(i, 1) <= xyIntersect(i) && xyIntersect(i) <= lines(i, 3)) ...
                || (lines(i, 3) <= xyIntersect(i) && xyIntersect(i) <= lines(i, 1));
        end

        valid_x = xyIntersect(idx);
        if ~isempty(valid_x)
            xInt1 = max([min(round(valid_x)), 1]);
            xInt2 = min([max(round(valid_x)), width]);
            M(y, xInt1:xInt2) = 1;
        end
    end
end

end


function range = common_range(x1min, x1max, x2min, x2max)

if x1min > x1max
    tmp = x1min;
    x1min = x1max;
    x1max = tmp;
end

if x2min > x2max
    tmp = x2min;
    x2min = x2max;
    x2max = tmp;
end

if (x1max < x2min) || (x2max < x1min)
    range = [];
else
    range = [max([x1min, x2min]), min([x1max, x2max])];
end

end

