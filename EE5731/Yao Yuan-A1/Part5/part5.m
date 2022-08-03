%% Initialize
clc;
clear;

%% Read image and set SIFT
run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m');
img1 = imread('..\assg1\im02.jpg');
img2 = imread('..\assg1\im01.jpg');

I1 = single(rgb2gray(img1));
I2 = single(rgb2gray(img2));

[f1,d1] = vl_sift(I1);
[f2,d2] = vl_sift(I2);
[matches, scores] = vl_ubcmatch(d1, d2, 1.5);

%% show all the matches
match_nums = size(matches,2);
% get the match
points1 = zeros(match_nums, 2);
points2 = zeros(match_nums, 2);
for i = 1:match_nums
    points1(i, 1) = f1(1,matches(1,i));
    points1(i, 2) = f1(2,matches(1,i));
    points2(i, 1) = f2(1,matches(2,i));
    points2(i, 2) = f2(2,matches(2,i));
end

% get the matching graph
figure(1); ax = axes;
showMatchedFeatures(img1, img2, points1, points2,'montage','Parent', ax);
title(ax, 'All SIFT matches');
legend(ax, 'Matched points 1','Matched points 2');

%% Compute the best homography matrix using RANSAC
[best_mat1,best_mat2,best_h,inliners] = Ransac(points1,points2);
disp(best_h)
figure(2); ax = axes;
showMatchedFeatures(img1, img2, points1(inliners,:), points2(inliners,:),'montage','Parent', ax);
title(ax, 'Inlier matches ');
legend(ax, 'Matched points 1','Matched points 2');

transform_matrix = projective2d(best_h.');
Rfixed = imref2d(size(img2));
[registered2, Rregistered] = imwarp(img1, transform_matrix);
figure(3)
imshowpair(img2,Rfixed,registered2,Rregistered,'blend');
