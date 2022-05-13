% Antonio Fernandez
% 301393610
% my_fast_detector.m

% Can only take double, grayscaled inputs
% Returns matrix of coordinates of detected features
% Recommended threshold: 0.3
function features = my_fast_detector(images, threshold)
    % For all pixels in the image
        % Select a pixel (p) as the center of the ring
        % Set a threshold (t)
        % Create a circle of radius 3 around the pixel
        % Check around this circle:
            % p is a corner if say 12 pixels on the ring (x) follows:
            % I_x > I_p + t or I_x < I_p - t
            % I_x - I_p > t or I_x - I_p < -t equivalently

    % Instead of having a ring around each pixel
    % Shift the image around (the same distances as the ring)
    % 16 separate shifts?

    for a = 1:size(images, 3)
        image = images(:, :, a);

        % Create image-sized matrix of zeros that will keep count of the pixels of
        % the ring that pass
        brighter_pass = zeros(size(image));
        darker_pass = zeros(size(image));
        N = 12;
        
        % High-Speed Test
        % Create the ring around these pixels again
        % Check 12 and 6 o'clock, then 3 and 9 o'clock
        % Accept the ones where 3 out of the four points pass the test
        hs_translations = [0 3; 3 0; 0 -3; -3 0];
        for i=1:(size(hs_translations, 1))
            trans = hs_translations(i,:); 
            ring = imtranslate(image, [trans(1), trans(2)]);
    
            % Subtract the two photos
            compound = ring - image;
    
            % Check where it passes the threshold
            brighter = compound > threshold;
            darker = compound < -threshold;
    
            % This matrix keeps track of how many pixels on the ring that
            % passed the threshold
            brighter_pass = brighter_pass + brighter;
            darker_pass = darker_pass + darker;
        end
    
        [bright_features_y, bright_features_x] = find(brighter_pass >= 3);
        [dark_features_y, dark_features_x] = find(darker_pass >= 3);
        
        features_y = [bright_features_y; dark_features_y];
        features_x = [bright_features_x; dark_features_x];
    
        % Now for the real test
        % Do the same thing, but with the whole ring and with the points that
        % passed the high-speed test
        image_features = [0 0];
        num_features = 0;
        
        for i = 1:size(features_y)
            test_pixel = image(features_y(i), features_x(i));
            num_passes = 0;
            
            translations = [0 3; 1 3; 2 2; 3 1; 3 0; 3 -1; 2 -2; 1 -3; 0 -3; -1 -3; -2 -2; -3 -1; -3 0; -3 1; -2 2; -1 3];
            for j = 1:(size(translations, 1))
                trans = translations(j,:);
                ring_y = features_y(i)+trans(2);
                ring_x = features_x(i)+trans(1);
                
                % Out of bounds check
                if ring_y > 0 && ring_y < size(image, 1) && ring_x > 0 && ring_x < size(image, 2)
                    ring = image(ring_y, ring_x);
                    compound = ring - test_pixel;
    
                    if (compound > threshold) || (compound < -threshold)
                        num_passes = num_passes + 1;
                    end
                end
            end
            
            if num_passes >= N
               % Enter cooridinates into features array if we get 12 passes
               image_features(num_features+1, 1) = features_x(i);
               image_features(num_features+1, 2) = features_y(i); 
               num_features = num_features + 1;
            end    
        end
        
        features{a} = image_features;
    end
end