% Antonio Fernandez
% 301393610
% Assignment 2 - Driver

fast_thresh(1) = 0.2;
fast_thresh(2) = 0.1;
fast_thresh(3) = 0.15;
fast_thresh(4) = 0.05;
harris_thresh(1) = 0.00001;
harris_thresh(2) = 0.000001;
harris_thresh(3) = 0.000001;
harris_thresh(4) = 0.000001; 

% Part 1: Take and load photos
s1i1 = im2double(imresize(imread('s1_left.jpg'), 0.25));
s1i2 = im2double(imresize(imread('s1_right.jpg'), 0.25));
s1i1 = s1i1(:, 151:900, :);
s1i2 = s1i2(:, 151:900, :);

s2i1 = im2double(imresize(imread('blu1.jpg'), 0.25));
s2i2 = im2double(imresize(imread('blu2.jpg'), 0.25));
s2i1 = s2i1(:, 151:900, :);
s2i2 = s2i2(:, 151:900, :);

s3i1 = im2double(imresize(imread('street1.jpg'), 0.25));
s3i2 = im2double(imresize(imread('street2.jpg'), 0.25));
s3i3 = im2double(imresize(imread('street3.jpg'), 0.25));
s3i4 = im2double(imresize(imread('street4.jpg'), 0.25));
s3i1 = s3i1(:, 151:900, :);
s3i2 = s3i2(:, 151:900, :);
s3i3 = s3i3(:, 151:900, :);
s3i4 = s3i4(:, 151:900, :);

s4i1 = im2double(imresize(imread('sfu3.jpg'), 0.25));
s4i2 = im2double(imresize(imread('sfu4.jpg'), 0.25));
s4i3 = im2double(imresize(imread('sfu1.jpg'), 0.25));
s4i4 = im2double(imresize(imread('sfu2.jpg'), 0.25));
s4i1 = s4i1(:, 151:900, :);
s4i2 = s4i2(:, 151:900, :);
s4i3 = s4i3(:, 151:900, :);
s4i4 = s4i4(:, 151:900, :);

s1_rgb = {s1i1, s1i2};
s2_rgb = {s2i1, s2i2};
s3_rgb = {s3i1, s3i2, s3i3, s3i4};
s4_rgb = {s4i1, s4i2, s4i3, s4i4};

imwrite(s1i1, 'S1-im1.png');
imwrite(s1i2, 'S1-im2.png');

imwrite(s2i1, 'S2-im1.png');
imwrite(s2i2, 'S2-im2.png');

imwrite(s3i1, 'S3-im1.png');
imwrite(s3i2, 'S3-im2.png');
imwrite(s3i3, 'S3-im3.png');
imwrite(s3i4, 'S3-im4.png');

imwrite(s4i1, 'S4-im1.png');
imwrite(s4i2, 'S4-im2.png');
imwrite(s4i3, 'S4-im3.png');
imwrite(s4i4, 'S4-im4.png');

s1 = cat(3, rgb2gray(s1i1), rgb2gray(s1i2));
s2 = cat(3, rgb2gray(s2i1), rgb2gray(s2i2));
s3 = cat(3, rgb2gray(s3i1), rgb2gray(s3i2), rgb2gray(s3i3), rgb2gray(s3i4));
s4 = cat(3, rgb2gray(s4i1), rgb2gray(s4i2), rgb2gray(s4i3), rgb2gray(s4i4));


% Part 2: FAST Feature Detector
s1_fast = my_fast_detector(s1, fast_thresh(1));
s2_fast = my_fast_detector(s2, fast_thresh(2));
s3_fast = my_fast_detector(s3, fast_thresh(3));
s4_fast = my_fast_detector(s4, fast_thresh(4));

s1i1_fast_bin = visualizeFeatures(s1(:,:,1), s1_fast{1});
fastvis = s1(:,:,1);
fastvis(s1i1_fast_bin > 0) = 1;
imwrite(fastvis, 'S1-fast.png');

s2i1_fast_bin = visualizeFeatures(s2(:,:,1), s2_fast{1});
fastvis = s2(:,:,1);
fastvis(s2i1_fast_bin > 0) = 1;
imwrite(fastvis, 'S2-fast.png');


% Part 2.5: Robust FAST using Harris Cornerness
s1_fastr = fastr(s1, fast_thresh(1), harris_thresh(1));
s2_fastr = fastr(s2, fast_thresh(2), harris_thresh(2));
s3_fastr = fastr(s3, fast_thresh(3), harris_thresh(3));
s4_fastr = fastr(s4, fast_thresh(4), harris_thresh(4));

s1i1_fastr_bin = visualizeFeatures(s1(:,:,1), s1_fastr{1});
fastvis = s1(:,:,1);
fastvis(s1i1_fastr_bin > 0) = 1;
imwrite(fastvis, 'S1-fastr.png');

s2i1_fastr_bin = visualizeFeatures(s2(:,:,1), s2_fastr{1});
fastvis = s2(:,:,1);
fastvis(s2i1_fastr_bin > 0) = 1;
imwrite(fastvis, 'S2-fastr.png');


% Part 4: Point Description and Matching
% In createPanorama

% Part 5: RANSAC and Stitching
% Compute transformations between images for each set
s1_pano_fast = createPanorama(s1, s1_rgb, s1_fast);
saveas(gcf, 'S1-fastMatch.png');
s1_pano_fastr = createPanorama(s1, s1_rgb, s1_fastr);
saveas(gcf, 'S1-fastRMatch.png');

s2_pano_fast = createPanorama(s2, s2_rgb, s2_fast);
saveas(gcf, 'S2-fastMatch.png');
s2_pano_fastr = createPanorama(s2, s2_rgb, s2_fastr);
saveas(gcf, 'S2-fastRMatch.png');

s3_pano_fast = createPanorama(s3, s3_rgb, s3_fast);
s3_pano_fastr = createPanorama(s3, s3_rgb, s3_fastr);

s4_pano_fast = createPanorama(s4, s4_rgb, s4_fast);
s4_pano_fastr = createPanorama(s4, s4_rgb, s4_fastr);

imwrite(s1_pano_fastr, 'S1-panorama.png');
imwrite(s2_pano_fastr, 'S2-panorama.png');
imwrite(s3_pano_fastr, 'S3-panorama.png');
imwrite(s4_pano_fastr, 'S4-panorama.png');
