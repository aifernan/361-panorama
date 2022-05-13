% Antonio Fernandez
% 301393610
% visualizeFeatures.m

% Creates image-sized binary matrix of detected features given a 2-column
% matrix of (x, y) points
function vis = visualizeFeatures(image, points)
    vis = zeros(size(image));
    for feature_point = 1:size(points, 1)
        feature_point_x = points(feature_point, 1);
        feature_point_y = points(feature_point, 2);
        
        vis(feature_point_y, feature_point_x) = 1;
    end
end