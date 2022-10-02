
% function [imagePoints, imageLines, imageLinesEndpoints] = mark_image(filename, n1, n2, colors, saveFolder)

% Manually identify (n1 x n2) points on an image laying on a grid-like
% pattern and return their coordinates. The points coordinates are computed
% as the intersections between the first set of n1 lines and the second set
% of n2 lines drawn by the user. The marked image is then saved in saveFolder.

% Usage : The first coordinates computed are the intersections of the first
% set's first line with the second set's lines. The last coordinates
% computed are the intersections of the first set's last line with the
% second set's lines.

% To draw a line :
% Click two times on the image to specify two points belonging to the line
% (Optionnal) Drag either of the two previous points to adjust the line
% Press ENTER to validate

% Colors:
% colors(1) : first set's regular line color
% colors(2) : first set's first line color
% colors(3) : first set's last line color
% colors(4) : second set's regular line color
% colors(5) : second set's first line color
% colors(6) : second set's last line color

% Example : (3x4) grid 

% To get the following ordering, n1=3 horizontal lines should be drawn from
% top to bottom followed by n2=4 vertical lines drawn from left to rignt.
%        (1)         (n2) 
%         |   |   |   |
%  (1)  - 1 - 2 - 3 - 4 -
%         |   |   |   |
%       - 5 - 6 - 7 - 8 -
%         |   |   |   |
% (n1)  - 9 -10 -11 -12 -
%         |   |   |   |

% To get the following ordering, n1=4 vertical lines should be drawn from
% left to right followed by n2=3 horizontal lines drawn from top to bottom.
%        (1)         (n1) 
%         |   |   |   |
%  (1)  - 1 - 4 - 7 -10 -
%         |   |   |   |
%       - 2 - 5 - 8 -11 -
%         |   |   |   |
% (n2)  - 3 - 6 - 9 -12 -
%         |   |   |   |

% Each row of imageLinesEndpoints specifies a line set of endpoints in the
% form [x1, y1, x2, y2].

% Input :
% filename (string) : name of the image file
% n1 (integer) : number of lines in the first set
% n2 (integer) : number of lines in the second set
% colors (6 1-d string array) : lines'colors
% saveFolder (string) : name of the save folder

% Output :
% imagePoints ((n1*n2)x2 2-d array double) : 2d coordinates of the marked points
% imageLines ((n1+n2)x3 2-d double array) : lines homogenous coordinates
% imageLinesEndpoints ((n1+n2)x4 2-d double array) : lines endpoints

function [imagePoints, imageLines, imageLinesEndpoints] = mark_image(filename, n1, n2, colors, saveFolder)

% Pattern's image
fig = imshow(filename);
hold on;

if isempty(colors)
    colors = ["black", "black", "black", "black", "black", "black"];
end

% First set's lines
lines1 = zeros(n1, 3);
endpoints1 = zeros(n1, 4);
for i=1:n1
    disp("Draw line " + string(i) + " from the first set and press ENTER.")
    color = colors(1);
    if i == 1
        color = colors(2);
    elseif i == n1
        color = colors(3);
    end
    [lines1(i, :), endpoints1(i, [1, 3]), endpoints1(i, [2, 4])] = drawline(color);
    
end

% Second set's lines
lines2 = zeros(n2, 3);
endpoints2 = zeros(n2, 4);
for i=1:n2
    disp("Draw line " + string(i) + " from the second set and press ENTER.")
    color = colors(4);
    if i == 1
        color = colors(5);
    elseif i == n2
        color = colors(6);
    end
    [lines2(i, :), endpoints2(i, [1, 3]), endpoints2(i, [2, 4])] = drawline(color);
end

hold off;

% Lines
imageLines = [lines1; lines2];

% Lines endpoints
imageLinesEndpoints = [endpoints1; endpoints2];

% Compute intersections between the lines from the two sets
imagePoints = zeros(n1*n2, 2);
for i=1:n1
    line1 = lines1(i, :);
    for j=1:n2
        line2 = lines2(j, :);
        index = (i-1)*n2 + j;
        [imagePoints(index, 1), imagePoints(index, 2)] = ...
            line_intersection(line1, line2);
    end
end

if ~isempty(saveFolder)
    % Save the image with the drawn lines
    [~, name, extension] = fileparts(filename);
    saveas(fig, saveFolder + "/lines_" + name + extension);
    
    % Save the image with the computed intersection points
    fig = imshow(filename);
    hold on;
    plot(imagePoints(:, 1), imagePoints(:, 2), 'g+');
    hold off;
    legend('Intersection points')
    saveas(fig, saveFolder + "/keypoints_" + name + extension);
end

end

