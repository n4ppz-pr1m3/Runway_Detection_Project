% function omega = estimate_iac(homographies)

% Estimates the image of the absolute conic (3x3 spd matrix) with a set of
% homographies.

% We assume here an imaging camera with square pixels such that:
% omega(1, 1) = omega(2, 2) (unit aspect ratio)
% omega(1, 2) = omega(2, 1) = 0 (no skew)

% Input :
% homographies (3x3xN 3-d double array) : homographies

% Output :
% omega (3x3 2-d double array) : image of the absolute conic under the imaging camera

function omega = estimate_iac(homographies)

n = size(homographies, 3);
B = zeros(2*n, 4);
for i=1:n
    h1 = homographies(:, 1, i);
    h2 = homographies(:, 2, i);
    B(1+2*(i-1):2*i, :) = [rowB(h1, h2);...
                           rowB(h1, h1) - rowB(h2, h2)];
end
[~, ~, V] = svd(B);
p = V(:, end);
omega = [p(1), 0,    p(2);...
         0,    p(1), p(3);...
         p(2), p(3), p(4)];

    function row = rowB(u, v)
        row = [u(1)*v(1)+u(2)*v(2), u(1)*v(3)+u(3)*v(1), u(2)*v(3)+u(3)*v(2), u(3)*v(3)];
    end
end
