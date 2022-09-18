function angle = string2angle(str)
new_str = convertStringsToChars(str);
angle = str2angle([new_str(2:end), new_str(1)]);
end