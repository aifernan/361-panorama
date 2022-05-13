% Antonio Fernandez
% 301393610
% createPanorama.m

% Heavy influence from the Feature Based Panoramic Image Stitching tutorial
% by Math Works
% Stitches a set of images to create a panorama
% Note that images are the gray-scaled versions
function panorama = createPanorama(images, images_rgb, my_fast_points)
    % Calculate descriptors for initial image
    image = images(:,:,1);
    points = my_fast_points{1};
    [features, points] = extractMyFastFeatures(image, points);
    
    % Initialize all transforms to the identity matrix
    numImages = size(images, 3);
    tforms(numImages) = projective2d(eye(3));
    % Initialize variable to hold image sizes
    imageSize = zeros(numImages, 2);

    % Iterate over rest of image pairs
    for a = 2:numImages
        % Store values of I(a-1)
        prev_image = image;
        prev_points = points;
        prev_features = features;

        % Get values for I(a)
        image = images(:,:,a);
        % Save image size
        imageSize(a,:) = size(image);

        % Extract features detected by my_fast_detector for I(a)
        points = my_fast_points{a};
        [features, points] = extractMyFastFeatures(image, points);
    
        % Find correspondences between I(a) and I(a-1)
        index_pairs = matchFeatures(features, prev_features);
        matched_pts = points(index_pairs(:,1),:);
        prev_matched_pts = prev_points(index_pairs(:,2),:);
        % Display the matches between I(a) and I(a-1) (save if you want)
        showMatchedFeatures(prev_image, image, matched_pts, prev_matched_pts);
        
        % Estimate transformation between I(a) and I(a-1)
        tforms(a) = estimateGeometricTransform2D(matched_pts, prev_matched_pts, 'projective');
        % Compute T(n) * ... * T(1)
        tforms(a).T = tforms(a).T * tforms(a-1).T;
    end
    
    % Compute the output limits for each transform.
    for i = 1:numel(tforms)           
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
    end

    avgXLim = mean(xlim, 2);
    [~,idx] = sort(avgXLim);
    centerIdx = floor((numel(tforms)+1)/2);
    centerImageIdx = idx(centerIdx);

    Tinv = invert(tforms(centerImageIdx));
    for i = 1:numel(tforms)    
        tforms(i).T = tforms(i).T * Tinv.T;
    end

    for i = 1:numel(tforms)           
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
    end

    % Find minimum and maximum output limits
    for i = 1:numImages
        image = images(:,:,i);
        [xlim(i, :), ylim(i, :)] = outputLimits(tforms(i), [1 size(image, 2)], [1 size(image, 1)]);
        imageSize(i,:) = size(image);
    end
    
    maxImageSize = max(imageSize);
    
    xMin = min([1; xlim(:)]);
    xMax = max([maxImageSize(2); xlim(:)]);

    yMin = min([1; ylim(:)]);
    yMax = max([maxImageSize(1); ylim(:)]);
    
    % Width and height of panorama
    width = round(xMax - xMin);
    height = round(yMax - yMin);
    
    % Init empty panorama
    panorama = zeros([height width 3], 'like', image(:,:,1));
    blender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');
    
    % Create 2D spatial reference object defining the size of the panorama
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView =  imref2d([height width 3], xLimits, yLimits);
    
    % Create panorama
    for i = 1:numImages
        image = images_rgb{i};
        % Transform I into the pano
        warpedImage = imwarp(image, tforms(i), 'OutputView', panoramaView);
        % Generate a binary mask
        mask = imwarp(true(size(image, 1), size(image, 2)),  tforms(i), 'OutputView', panoramaView);
        % Overlay warpedImage onto the pano
        panorama = step(blender, panorama, warpedImage, mask);
    end
end