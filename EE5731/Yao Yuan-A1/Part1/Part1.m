%% Initialize
clc;
clear;

%% Build kernel
%Sobel Kernel
Sobel_gx = [-1,0,1; -2,0,2; -1,0,1];
Sobel_gy = [1,2,1; 0,0,0; -1,-2,-1];

%Gaussian Kernel
Gaussian3 = fspecial('gaussian',3,1);
Gaussian5 = fspecial('gaussian',5,1);
Gaussian7 = fspecial('gaussian',7,1);

%5 Haar-like masks
scale = 5; %Can change the scale of Haar here
x = scale;

Haar_1 = ones(2*x, x);
Haar_1(x+1:2*x,:) = Haar_1(x+1:2*x,:).*(-1);

Haar_2 = ones(x, 2*x);
Haar_2(:,x+1:2*x) = Haar_2(:,x+1:2*x).*(-1);

Haar_3 = ones(3*x, x);
Haar_3(x+1:2*x,:) = Haar_3(x+1:2*x,:).*(-1);

Haar_4 = ones(x, 3*x);
Haar_4(:,x+1:2*x) = Haar_4(:,x+1:2*x).*(-1);

Haar_5 = ones(2*x, 2*x);
Haar_5(1:x,x+1:2*x) = Haar_5(1:x,x+1:2*x).*(-1);
Haar_5(x+1:2*x,1:x) = Haar_5(x+1:2*x,1:x).*(-1);

%% Input image
img = imread('GuGong.jpg'); % you can change picture here
% get gray image
if size(size(img),2) == 3
    img = rgb2gray(img);
end
[img_hit, img_wid] = size(img);

%% Get 2D convolution result
kernel = Gaussian55;  % Sobel_gx, Sobel_gy, Gaussian3, Gaussian5, Gaussian7, Haar_1, Haar_2, Haar_3, Haar_4, Haar_5
[k_hit, k_wid] = size(kernel);
result = [];

for i = 1:img_hit - k_hit + 1
    for j = 1:img_wid - k_wid + 1
        overlap = img(i:i + k_hit - 1, j:j + k_wid - 1);
        result(i, j) = sum(sum(double(overlap).* kernel));
    end
end
result = uint8(result);
figure();
imshow(result);