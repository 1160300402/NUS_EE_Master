%% Initialize
clc;
clear;

%% Read image and set SIFT
run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m');
img_1 = imread('..\assg1\im01.jpg');
img_2 = imread('..\assg1\im02.jpg');
img_3 = imread('..\assg1\im03.jpg');
img_4 = imread('..\assg1\im04.jpg');
img_5 = imread('..\assg1\im05.jpg');
imgs = {img_3,img_2,img_4,img_1,img_5};

%% Stitch images
img2 = img_3;
for img_idx = 2:length(imgs)
    img1 = imgs{img_idx};
    I1 = single(rgb2gray(img1));
    I2 = single(rgb2gray(img2));

    [f1,d1] = vl_sift(I1);
    [f2,d2] = vl_sift(I2);
    [matches, scores] = vl_ubcmatch(d1, d2, 1.5);
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

    [best_mat1,best_mat2,best_h,inliners] = Ransac(points1,points2);
    disp(best_h)
    figure(); ax = axes;
    showMatchedFeatures(img1, img2, points1(inliners,:), points2(inliners,:),'montage','Parent', ax);
    title(ax, 'Inlier matches ');
    legend(ax, 'Matched points 1','Matched points 2');


    transform_matrix = projective2d(best_h.');
    Rfixed = imref2d(size(img2));
    [registered2, Rregistered] = imwarp(img1, transform_matrix);
    figure()
    imshowpair(img2,Rfixed,registered2,Rregistered,'blend');
    result = imshowpair(img2,Rfixed,registered2,Rregistered,'blend');
    img2 = result.CData;
end

