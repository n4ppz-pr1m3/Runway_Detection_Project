function extrinsics = extrinsicMatrix2extrinsics(extrinsicMatrix)
rotationMatrix = extrinsicMatrix(1:3, 1:3);
rotationVector = rotationMatrixToVector(rotationMatrix)';
translationVector = extrinsicMatrix(:, 4);
extrinsics = [rotationVector; translationVector];
end
