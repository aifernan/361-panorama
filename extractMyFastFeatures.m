% Antonio Fernandez
% 301393610
% extractMyFastFeatures.m

% Can only take double, grayscaled images.
% Takes my fast points, converts it to SURFPoint objects in order to use
% the extractFeatures function to get the descriptors for my fast points.
function [features, valid_points] = extractMyFastFeatures(image, fast_points)
    surfd_points = SURFPoints(fast_points);
    [features, valid_points] = extractFeatures(image, surfd_points);
end