function [intrinsicMatrix, extrinsics] = zhang_params2matrices(p)

intrinsicMatrix = [p(1), 0,    p(2);...
                   0,    p(1), p(3);...
                   0,    0,    1];
               
extrinsics = reshape(p(4:end), 6, []);
end

