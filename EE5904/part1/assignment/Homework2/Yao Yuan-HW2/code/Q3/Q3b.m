%% pre-process
clc;
clear;

%% load data
X_train = [];
y_train = [];
X_val = [];
y_val = [];

Data_0 = './group_0/airplane/';
Data_1 = './group_0/cat/';
paths_0 = dir(fullfile(Data_0,'*.jpg'));
paths_1 = dir(fullfile(Data_1,'*.jpg')); 
for i = 1:numel(paths_0)
    file0 = fullfile(Data_0,paths_0(i).name);
    img0 = imread(file0);
    img_g0 = rgb2gray(img0); 
    x0 = reshape(img_g0, [], 1);
    x0 = double(x0(:));
    file1 = fullfile(Data_1,paths_1(i).name);
    img1 = imread(file1);
    img_g1 = rgb2gray(img1); 
    x1 = reshape(img_g1, [], 1);
    x1 = double(x1(:));
    if i<=450
        X_train = [X_train, x0];
        X_train = [X_train, x1];
        y_train = [y_train, 0];
        y_train = [y_train, 1];
    else
        X_val = [X_val, x0];
        y_val = [y_val, 0];
        X_val = [X_val, x1];
        y_val = [y_val, 1];
    end
end

%% preprocess with the mean and standard deviation
X_mean = mean(X_train, 2);
X_std = std(X_train.', 1);
X_std = X_std.';
X_train = (X_train - X_mean)./ X_std;
X_val = (X_val - X_mean)./ X_std;

%% get single layer perceptron and test the result
net = perceptron;
net.trainparam.lr=0.0001;
net.trainparam.epochs=10000;
% net.trainparam.goal=0.1;
% Train the MLP
net=train(net,X_train,y_train);
% accuracy
pred_train = net(X_train);
acc_train = 1 - mean(abs(pred_train-y_train));
pred_val = net(X_val);
acc_val = 1 - mean(abs(pred_val-y_val));
fprintf('acc_train: %.02f%%\n',acc_train*100)
fprintf('acc_val: %.02f%%\n',acc_val*100)