%% Part 3
clc;
clear;
addpath(genpath('../GCMex/'));

%% Read images and camera matirces
img1 = double(imread('test00.jpg'));
img2 = double(imread('test09.jpg'));
[Height, Width, Depth] = size(img1);
img1 = reshape(permute(img1,[2,1,3]),1,[],3);
img2 = reshape(permute(img2,[2,1,3]),1,[],3);

cam_matrices = dlmread('cameras.txt');
K1 = cam_matrices(1:3, 1:3);
R1 = cam_matrices(4:6, 1:3);
T1 = cam_matrices(7, 1:3)';
K2 = cam_matrices(8:10, 1:3);
R2 = cam_matrices(11:13, 1:3);
T2 = cam_matrices(14, 1:3)';

%% Parameters based on "Consistent Depth Maps Recovery from a Video Sequence"
disparity = 0:0.0001:0.01;
ws = 50 / (disparity(end) - disparity(1));
eta = 0.05 * (disparity(end) - disparity(1));
epsilon = 50;
sigma_c = 10;

% get img2 cooresponding epipolar line
number_pixel = Height * Width;
Xh = [repmat(1:Width, 1, Height); reshape(repmat(1:Height, Width, 1), 1, number_pixel); ones(1, number_pixel)];
formula1 = K2 * R2' * (T1-T2) * disparity;
formula2 = K2 * R2' * R1 * inv(K1) * Xh;

projected = [];
for i=1:length(disparity)
    img2_coord = formula2 + repmat(formula1(:,i),1,number_pixel);
    img2_coord(1,:) = img2_coord(1,:)./img2_coord(3,:);
    img2_coord(2,:) = img2_coord(2,:)./img2_coord(3,:);
    img2_coord = round(img2_coord);
    img2_coord(2,img2_coord(2,:) <1) = 1;
    img2_coord(2,img2_coord(2,:)>Height) = Height;
    img2_coord(1,img2_coord(1,:) <1) = 1;
    img2_coord(1,find(img2_coord(1,:)>Width)) = Width;
    projected = [projected; img2_coord(1,:)+(img2_coord(2,:)-1)*Width;]; 
end

class = size(disparity, 2);
im1 = repmat(img1, class, 1);
im2 = reshape(img2(1, projected, :), class, number_pixel, []);

% get the unary
unary = sqrt(sum((im2 - im1).^2, 3));
unary = sigma_c./(sigma_c + unary);
maximum = max(unary);
max_unary = repmat(maximum, class, 1);
unary = 1 - unary./max_unary;

% get lambda
img = permute(img1,[2 1 3]);
[H, W] = size(img(:, :, 1));
E = get_4edges(H, W);
lambda = get_lambda(epsilon, ws, number_pixel, img, E);

pairwise = sparse(E(:, 1),E(:, 2), double(lambda), number_pixel, number_pixel, 4 * number_pixel);
labelcost = pdist2(disparity', disparity');
labelcost(labelcost > eta) = eta;
[~, index] = min(unary); 
class = index - 1;
[labels, ~, ~] = GCMex(class, single(unary), pairwise, single(labelcost),1);

%% get the depth map and save
result = mat2gray(reshape(disparity(labels+1), Width, Height)');
figure
imshow(result);
imwrite(result, 'DepthFromStereo.png');