
% function marked_point = mark_point(filename, step)

% Returns the image coordinates of a user specified point

% Usage:
% Click on the image to set two orthogonal axes near the point of interest.
% Move the axes using arrow keys to refine the position.
% Press "Return" to get the coordinates of the intersection point. 

% Input :
% filename (string) : name of the image file
% step (double) : axes displacement on key press

% Output :
% marked_point (2 1-d array double) : 2d coordinates of the marked point

function marked_point = mark_point(filename, step)

if ~exist("step", "var")
    step = 1;
end

fig = figure;
imshow(filename);
hold on;
[x, y] = ginput(1);
ver_line = xline(x, 'LineWidth', 0.1);
hor_line = yline(y, 'LineWidth', 0.1);
hold off

persistent point

fig.set('KeyPressFcn', @(src, event) myfun(src, event, hor_line, ver_line, step));
waitfor(fig);
marked_point = point;

    function myfun(src, event, hor_line, ver_line, step)
    %disp(event.Key)
    switch event.Key
        case "uparrow"
            hor_line.Value = hor_line.Value - step;
    
        case "downarrow"
            hor_line.Value = hor_line.Value + step;
    
        case "leftarrow"
            ver_line.Value = ver_line.Value - step;
            
        case "rightarrow"
            ver_line.Value = ver_line.Value + step;
    
        case "return"
            point = [ver_line.Value, hor_line.Value];
            close(src);
    end
end

end

