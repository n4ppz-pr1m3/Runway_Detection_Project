function p = zhang_matrices2params(intrinsicMatrix, extrinsics)

f = intrinsicMatrix(1, 1);
u0 = intrinsicMatrix(1, 3);
v0 = intrinsicMatrix(2, 3);
p = [f; u0; v0; extrinsics(:)];

end

