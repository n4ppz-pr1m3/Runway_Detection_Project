% function [K, aspectRatio, skew, mre, lmx, lmy] = estimate(imagePoints, cameraPoints)

% Estimate the intrinsic parameters of a camera with a set of control points
% with known image and camera coordinates. At least 2 points are required.

% Method:
% Given the following:
% - An intrinsic matrix with focal lengths fx, fy, skew s and principal point (ppx, ppy)
% - A point P with image coordinates [xI; yI] and camera coordinates [xC; yC; zC]
% The point P is projected onto the image plane such that:
% [xI; yI; 1] = ([fx s ppx; 0 fy ppy; 0 0 1] * [xC; yC; zC]) ./ zC
% We then derive 2 regression models to estimate the unknown parameters.

% Input :
% imagePoints (N*2 2-d double array) : control points image coordinates
% cameraPoints (N*3 2-d double array) : control points camera coordinates

% Output :
% K (3*3 2-d array double) : estimated intrinsic parameters matrix
% aspectRatio (double) : camera aspect ratio
% skew (double) : camera skew value
% mre (double) : mean reprojection error
% lmx (linear model object) : linear model of the estimation of fx, s and ppx
% lmy (linear model object) : linear model of the estimation of fy and ppy

function [K, aspectRatio, skew, mre, lmx, lmy] = estimate_intrinsic(imagePoints, cameraPoints)

if size(imagePoints, 1) ~= size(cameraPoints, 1)
    error("Image points and camera points number mismatch")
elseif size(imagePoints, 2) ~= 2
    error("Image points must have 2 coordinates (" + string(size(imagePoints, 2)) + ")")
elseif size(cameraPoints, 2) ~= 3
    error("Camera points must have 3 coordinates (" + string(size(cameraPoints, 2)) + ")")
elseif sum(abs(cameraPoints(:, 3)) <= 1e-3) ~= 0
    error("Camera points can't have null Z coordinate")
end

xI = imagePoints(:, 1);
yI = imagePoints(:, 2);
xzC = cameraPoints(:, 1) ./ cameraPoints(:, 3);
yzC = cameraPoints(:, 2) ./ cameraPoints(:, 3);

% Estimates the focal length, skew and principal point along the X-axis
figure
lmx = custom_fit([xzC, yzC], xI, "fx, ppx and s estimation");
ppx = lmx.Coefficients.Estimate(1);
fx = lmx.Coefficients.Estimate(2);
s = lmx.Coefficients.Estimate(3);

% Significance of estimated skew
if lmx.Coefficients.pValue(3) <= 5e-2
    skew = s;
else
    skew = 0;
end

% Estimates the focal length and principal point along the Y-axis
figure
lmy = custom_fit(yzC, yI, "fy and ppy estimation");
ppy = lmy.Coefficients.Estimate(1);
fy = lmy.Coefficients.Estimate(2);

aspectRatio = fx / fy;
if abs(aspectRatio - 1) <= 1e-3, aspectRatio = 1; end

% Intrinsic matrix
K = [fx, s, ppx;...
     0, fy, ppy;...
     0, 0, 1];

% Mean reprojection error
n = size(imagePoints, 1);
mre = sqrt((sum(lmx.Residuals.Raw.^2) + sum(lmy.Residuals.Raw.^2)) / n);

% Plot
figure
subplot(1, 2, 1)
plot(lmx)
title("X focal length and x-principal point")
xlabel("xCamera / zCamera")
ylabel("xImage (pixels)")

subplot(1, 2, 2)
plot(lmy)
title("Y focal length and y-principal point")
xlabel("yCamera / zCamera")
ylabel("yImage (pixels)")

sgtitle("Mean reprojection error (pixels) : " + string(mre))

% Helper function
    function lmr = custom_fit(X, y, str)
    lm = fitlm(X, y);
    lmr = fitlm(X, y, "RobustOpts", "on");
    
    % Normality of residuals for regular and robust fit
    t = tiledlayout(1,2);
    nexttile
    plotResiduals(lm,'probability')
    title('Linear Fit')
    nexttile
    plotResiduals(lmr,'probability')
    title('Robust Fit')
    title(t, "Normality of residuals (" + str + ")")

    % Observations weights
    figure
    b = bar(lmr.Robust.Weights);
    b.FaceColor = 'flat';
    outlier = find(isoutlier(lmr.Residuals.Raw));
    if outlier
        b.CData(outlier,:) = repmat([.5 0 .5], numel(outlier), 1);
    end
    xticks(1:length(lmr.Residuals.Raw))
    xlabel('Observations')
    ylabel('Weights')
    title("Robust Fit Weights (" + str + ")")     
    end
end

