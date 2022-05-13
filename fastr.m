% Antonio Fernandez
% 301393610
% fastr.m

% Can only take double, grayscaled inputs
% Robust FAST using Harris Cornerness metric
% Recommended thresholds: 0.3, 0.0001
function fastr_points = fastr(images, fast_thresh, harris_thresh)
    fast_points = my_fast_detector(images, fast_thresh);
    for a = 1:size(images, 3)
        image = images(:,:,a);
        fast_features = visualizeFeatures(image, fast_points{a});
        
        image_harris = harris(image);
        harris_corners = image_harris > harris_thresh;
        % Harris non-maxima suppression
        harris_localmax = imdilate(image_harris, ones(3));
        harris_features = (image_harris == harris_localmax) .* harris_corners;
        
        fastr_features = fast_features .* harris_features;
        [fastr_points_y, fastr_points_x] = find(fastr_features > 0);
        
        image_fastr_points = [0 0];
        for i = 1:size(fastr_points_x)
            image_fastr_points(i, 1) = fastr_points_x(i);
            image_fastr_points(i, 2) = fastr_points_y(i);
        end

        fastr_points{a} = image_fastr_points;
    end
end