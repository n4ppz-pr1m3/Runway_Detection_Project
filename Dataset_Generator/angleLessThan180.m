function bool = angleLessThan180(v1, v2, orientation)

% Check if the angle between 2 vectors measured according to the specified
% orientation is less than 180 degrees.

if ~isVector2(v1) || ~isVector2(v2)
    error("v1 and v2 must length 2 vectors")
end

if ~exist("orientation", "var")
    orientation = "direct";
end

zCrossProduct = v1(1)*v2(2)-v1(2)*v2(1);
if orientation == "direct"
    bool = sign(zCrossProduct) >= 0;
elseif orientation == "indirect"
    bool = sign(-zCrossProduct) >= 0;
else
    error("Unknown orientation " + string(orientation) + ". Valid values are 'direct' or 'indirect'")
end

end

function bool = isVector2(v)
bool = (numel(size(v)) == 2) && ...
    ((size(v, 1) == 2 && size(v, 2) == 1) || (size(v, 1) == 1 && size(v, 2) == 2));
end