%% preprocess
clc
clear

%% load data and start
load('mnist_m.mat');
% train_data ? training data, 784x1000 matrix
% train_classlabel ? the labels of the training data, 1x1000 vector
% test_data ? test data, 784x250 matrix
% test_classlabel ? the labels of the test data, 1x250 vector

% find the location of classes 9,3
trainIdx1 = find(train_classlabel==9 | train_classlabel==3); 
TrLabel = zeros(1,1000);
TrLabel(trainIdx1) = 1;
testIdx1 = find(test_classlabel==9 | test_classlabel==3); 
TeLabel = zeros(1,250);
TeLabel(testIdx1) = 1;

k = 2;
idx = randsample(1000,2);
x_centers = zeros(784,2);
centers_new = train_data(:,idx);

j=0;
while abs(sum(sum(x_centers - centers_new))) > 0.0001
   x_centers = centers_new;
   j = j+1;
   display(j);
   train_label = zeros(1000, 1);
   for i = 1:1000
        x = train_data(:, i);
        dist_1 = norm(x - x_centers(:, 1));
        dist_2 = norm(x - x_centers(:, 2));

        if dist_1 < dist_2
            train_label(i) = 1;
        elseif dist_2 < dist_1
            train_label(i) = 2;
        end
    end
    centers_new(:, 1) = mean(train_data(:, train_label==1), 2);
    centers_new(:, 2) = mean(train_data(:, train_label==2), 2);
end

cluster1 = reshape(x_centers(:, 1),28,28);
cluster2 = reshape(x_centers(:, 2),28,28);
figure;
imshow(cluster1);
title("Cluster1");
figure;
imshow(cluster2);
title("Cluster2");
train_mean1 = mean(train_data(:, TrLabel==1),2);
train_mean0 = mean(train_data(:, TrLabel==0),2);
mean1 = reshape(train_mean1,28,28);
mean0 = reshape(train_mean0,28,28);
figure;
imshow(mean1);
title("Training mean of label 1");
figure;
imshow(mean0);
title("Training mean of label 0");

%%
sigma = norm(x_centers(:, 1) - x_centers(:, 2)) / sqrt(2 * k); 
distance = zeros(1000, 2);
for i = 1:2
    for j = 1:1000
        distance(j, i) = norm(train_data(:, j) - x_centers(:, i));
    end
end
train_fi = exp(-distance.^2/(2* sigma^2));
distance_test = zeros(250, 2);
for i = 1:2
    for j = 1:250
        distance_test(j, i) = norm(test_data(:, j) - x_centers(:, i));
    end
end
test_fi = exp(-distance_test.^2/(2* sigma^2));

w = train_fi \ TrLabel'; 
TrPred = train_fi * w;
TePred = test_fi * w;  

% evaluate
TrAcc = zeros(1,1000);
TeAcc = zeros(1,1000);
thr = zeros(1,1000);
TrN = length(TrLabel);
TeN = length(TeLabel);
for i = 1:1000
    t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
    thr(i) = t;
    
    TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
    TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
end
figure;
plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te');
title(["K-means"]);
