function extrinsics = homographies2extrinsics(homographies, intrinsicMatrix)

nHomographies = size(homographies, 3);
extrinsics = zeros(6, nHomographies);
for i=1:nHomographies
    RT = intrinsicMatrix \ homographies(:, :, i);
    RT = RT .* (2/(norm(RT(:, 1)) + norm(RT(:, 2))));
    r1 = RT(:, 1);
    r2 = RT(:, 2);
    r3 = cross(r1, r2);
    [U, ~, V] = svd([r1, r2, r3]);
    RV = rotationMatrixToVector(U*V')';
    T = RT(:, 3);
    extrinsics(:, i) = [RV; T];
end

end

