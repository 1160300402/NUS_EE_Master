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

%% Sequential mode MLP and test the result
X_train_c = num2cell(X_train, 1);
y_train_c = num2cell(y_train, 1);
X_val_c = num2cell(X_val, 1);
y_val_c = num2cell(y_val, 1);
% 2. Construct and configure the MLP
epochs = 20;
func = "traingdx";
n = 9;
net = patternnet(n,char(func));
net.divideFcn = 'dividetrain'; % input for training only
net.performParam.regularization = 0.01; 
net.trainParam.epochs = epochs;
acc_train = zeros(epochs,1); 
acc_val = zeros(epochs,1); 
% 3. Train the network in sequential mode
for i = 1 : epochs
    display(['Epoch: ', num2str(i)])
    idx = randperm(900); % shuffle the input
    net = adapt(net, X_train_c(:,idx), y_train_c(:,idx));
    pred_train = round(net(X_train)); 
    acc_train(i) = 1 - mean(abs(pred_train-y_train));
    pred_val = round(net(X_val)); 
    acc_val(i) = 1 - mean(abs(pred_val-y_val));
end
% plot
fig = figure();
hold on
plot((1:epochs),acc_train,'--','LineWidth',2)
plot((1:epochs),acc_val,'--','LineWidth',2)
ylim([0 1])
legend('Train','Val')
title(sprintf('Mode:seq ,Epochs:%d ',epochs))
ylabel('Accuracy')
xlabel('Epochs')
hold off