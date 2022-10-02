
% function angle = string2angle(str)

% Computes an angle from a string representation.

% The input string should have the form 'cardinal_direction + d.m.s.' angle

% Example :
% angle = string2angle("N12-34-56.78")

function angle = string2angle(str)
new_str = convertStringsToChars(str);
angle = str2angle([new_str(2:end), new_str(1)]);
end