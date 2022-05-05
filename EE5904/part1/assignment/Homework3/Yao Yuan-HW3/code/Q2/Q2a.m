%% preprocess
clc
clear

%% load data and start
load('mnist_m.mat');
% train_data ? training data, 784x1000 matrix
% train_classlabel ? the labels of the training data, 1x1000 vector
% test_data ? test data, 784x250 matrix
% test_classlabel ? the labels of the test data, 1x250 vector

tmp=reshape(train_data(:,9),28,28);
imshow(tmp);

% find the location of classes 9,3
trainIdx1 = find(train_classlabel==9 | train_classlabel==3); 
TrLabel = zeros(1,1000);
TrLabel(trainIdx1) = 1;

testIdx1 = find(test_classlabel==9 | test_classlabel==3); 
TeLabel = zeros(1,250);
TeLabel(testIdx1) = 1;

sigma = 100;
distance = zeros(1000, 1000);
for i = 1:1000
    for j = 1:1000
        distance(j, i) = norm(train_data(:, j) - train_data(:, i));
    end
end
train_fi = exp(-distance.^2/(2* sigma^2));
distance_test = zeros(250, 1000);
for i = 1:1000
    for j = 1:250
        distance_test(j, i) = norm(test_data(:, j) - train_data(:, i));
    end
end
test_fi = exp(-distance_test.^2/(2* sigma^2));

for reg_lambda = [0, 0.001, 0.1, 0.5, 1, 10, 100]
    w = (train_fi'*train_fi + reg_lambda*eye(1000)) \ train_fi'*TrLabel'; % fi'fi+lamdaI¡¤w = fi'd
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
    title(["Regular lambda = " num2str(reg_lambda)])
end