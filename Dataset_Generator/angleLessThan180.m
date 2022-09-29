% function bool = angleLessThan180(v1, v2, orientation)

% Check if the angle between 2 vectors measured according to the specified
% orientation is less than 180 degrees.

% angleLessThan180(v1, v2, "direct") returns true if 0 <= (v1, v2) <= 180.
% angleLessThan180(v1, v2, "indirect") returns true if 0 <= (v2, v1) <= 180.

% Input :
% v1 (2 1-d double array) : first 2-vector
% v2 (2 1-d double array) : second 2-vector
% orientation (string) : specify how the angle between v1 and v2 is measured ("direct"|"indirect")

% Output :
% bool (boolean) : test result

function bool = angleLessThan180(v1, v2, orientation)

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
bool = isvector(v) && (numel(v) == 2);
end