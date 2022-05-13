% Antonio Fernandez
% 301393610
% harris.m

% Can only take double, grayscaled inputs
% Returns image-sized matrix of harris cornerness scores
function harris_scores = harris(image)
    sob_kern_x = [-1 0 1; -2 0 2; -1 0 1];
    gaussian_kern = fspecial('gaussian', 5, 1);
    dog_kern_x = conv2(gaussian_kern, sob_kern_x);
    
    % Step 1: Image derivatives
    i_x = imfilter(image, dog_kern_x);
    i_y = imfilter(image, dog_kern_x');
    
    % Step 2: Square of derivatives
    i_x_squared = i_x .* i_x;
    i_y_squared = i_y .* i_y;
    i_x_i_y = i_x .* i_y;
    
    % Step 3: Gaussian filter
    gaus_i_x_squared = imfilter(i_x_squared, gaussian_kern);
    gaus_i_y_squared = imfilter(i_y_squared, gaussian_kern);
    gaus_i_x_i_y = imfilter(i_x_i_y, gaussian_kern);
    
    % Step 4: Cornerness function
    alpha = 0.05;
    harris_scores = (gaus_i_x_squared.*gaus_i_y_squared) - (gaus_i_x_i_y.*gaus_i_x_i_y) - (alpha*(gaus_i_x_squared+gaus_i_y_squared).^2);
    
    % Non-maxima suppression?
end