
% function K = estimate_intrinsic_iac(omega, method)

% Computes the intrinsic parameters of a camera from the image of the
% absolute conic.

% The camera is assumed to have square pixels.

% Two computation strategies are available, one based on a closed-form extraction of
% the parameters (method='direct') and the other based on a Cholesky
% factorization (method='cholesky');

% Input :
% omega (3x3 2-d double array) : image of the absolute conic
% method (string) : computation method ('direct'|'cholesky')

% Output :
% K (3x3 2-d double array) : camera intrinsic matrix

function K = estimate_intrinsic_iac(omega, method)

assert(all(size(omega) == [3, 3]), "omega is expected to be 3x3")
assert(issymmetric(omega), "omega is expected to be symmetric")

if ~exist("method", "var")
    method = "direct";
end
assert(method == "direct" || method == "cholesky", "method is expected to be 'direct'|'cholesky'")

if method == "cholesky"
    if omega(1, 1) < 0 || omega(3, 3) < 0
        omega = -omega;
    end
    R = chol(omega);
    K = inv(R); 
    K = K ./ K(end);
    
elseif method == "direct"
    o1 = omega(1, 1); o2 = omega(1, 3); o3 = omega(2, 3); o4 = omega(3, 3);
    v0 = -o3 / o1;
    lambda = o4 - o2^2/o1 + v0*o3;
    f = sqrt(lambda/o1);
    u0 = -o2*f^2 / lambda;
    
    K = [f, 0, u0;...
         0, f, v0;...
         0, 0, 1];
end

end

