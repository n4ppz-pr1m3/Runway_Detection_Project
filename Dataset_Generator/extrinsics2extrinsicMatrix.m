function extrinsicMatrix = extrinsics2extrinsicMatrix(extrinsics)
rotationVector = extrinsics(1:3);
translationVector = extrinsics(4:6);
extrinsicMatrix = [rotationVectorToMatrix(rotationVector), translationVector];
end

