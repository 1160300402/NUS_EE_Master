%% Part 2
clc;
clear;
addpath(genpath('../GCMex/'));

%% Read images
img1 = double(imread('im2.png'));
img2 = double(imread('im6.png'));
[Height, Width, Depth] = size(img1);

img1 = flip(flip(img1, 1), 2);
img1 = reshape(img1, 1, [], 3);
img2 = flip(flip(img2, 1), 2);
img2 = reshape(img2, 1, [], 3);
%% Begin code
number_labels = 50;
number_pixel = Width * Height;
unary = [];

for i = 1:number_labels
    t = Height * i;
    im1 = img1;im1(:, (number_pixel - t + 1):number_pixel, :) = [];
    im2 = img2;im2(:, 1:t, :) = [];
    M = sqrt(sum((im2 - im1).^2, 3));
    M = [M, 3 * zeros(1, t)];
    unary = [unary; M];
end

% get the sparse matrix
r = img1(:, :, 1);
g = img1(:, :, 2);
b = img1(:, :, 3);

E = get_4edges(Height,Width);

r_dist = sqrt((r(E(:, 1))-r(E(:, 2))).^2);
g_dist = sqrt((g(E(:, 1))-g(E(:, 2))).^2);
b_dist = sqrt((b(E(:, 1))-b(E(:, 2))).^2);
dist = r_dist + g_dist + b_dist;

pairwise = sparse(E(:, 1),E(:, 2),double(dist), number_pixel, number_pixel, 4*number_pixel);
unary = unary./max(unary(:));

% Find the best lambda
lambda_list = [0.0005, 0.001, 0.002, 0.003, 0.005, 0.01];
labelcost = pdist2((1:number_labels)', (1:number_labels)');
labelcost( labelcost > 1) = 1;
class = ones(1, number_pixel);

for lambda = lambda_list
    
    [labels, ~, ~] = GCMex(class, single(unary), pairwise*lambda, single(labelcost));
    
    result = mat2gray(reshape(labels+1, Height, Width));
    result = flip(flip(result ,1), 2);

    % display and store the depth map with different lambda value
    fprintf('Depth map for lambda=%f \n', lambda);
    figure;
    imshow(result)
    name = sprintf('result=%f.jpg', lambda);
    imwrite(result, name);

end