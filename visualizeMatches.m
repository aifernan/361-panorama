function [im1_matches, im2_matches] = getMatches(im1_pts, im2_pts, im1_features, im2_features)
    indexPairs = matchFeatures(im1_features, im2_features);
    im1_matches = im1_pts(indexPairs(:,1),:);
    im2_matches = im2_pts(indexPairs(:,2),:);
end