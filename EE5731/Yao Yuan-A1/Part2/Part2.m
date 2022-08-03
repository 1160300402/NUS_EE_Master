%% Initialize
clc;
clear;

%% read image
img = imread('..\assg1\im01.jpg');
imshow(img); hold on; 
title('Part 2.SIFT Features and Descriptors')

%% run SIFT use VLFeat

run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m');
I1 = single(rgb2gray(img));
[f1,d1] = vl_sift(I1);
col = randperm(size(f1,2),100) ;
pf1 = vl_plotframe(f1(:,col)) ;
pf2 = vl_plotframe(f1(:,col)) ;
pf3 = vl_plotsiftdescriptor(d1(:,col),f1(:,col)) ;
set(pf1,'color','k','linewidth',2) ;
set(pf2,'color','g','linewidth',2) ;
set(pf3,'color','y') ;