%% Initialize
clc;
clear;

%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part3_gui;  

%% Calculate homography matrix
disp('Computing homography matrix and output.');
A = zeros(8,9);
row = 1;
for i = 1:4
    x1 = mat1(1,i);
    y1 = mat1(2,i);
    x2 = mat2(1,i);
    y2 = mat2(2,i);
    A(row,:) = [x1, y1, 1, 0, 0, 0, -x2*x1, -y1*x2, -x2];
    A(row+1,:) = [0, 0, 0, x1, y1, 1, -x1*y2, -y1*y2, -y2];
    row = row + 2;
end

[U , S, V] = svd(A);
% h is the last row of V'
Vt = V';
h = Vt(end, :);
h = reshape(h, [3,3])';
disp(h);

%% Get output image
transform_matrix = projective2d(h.');
output = imwarp(img1, transform_matrix);
imshow(output); xlabel("Picture 1 after homography");