%% Clear the terminal
clear
clc

%% Load data
load('train.mat')
load('test.mat')

%% Preprocessing input data
mu = mean(train_data,2); %get the mean of train data
sigma = std(train_data,0,2); % get the standard deviation of train data
norm_train = (train_data - mu)./sigma;
norm_test = (test_data - mu)./sigma;
C = 1e6; % Hard linear
P = 1;
%% Linear part
[alpha_di,bo,flag] = GetDiscriminant(norm_train,train_label,'linear',P,C);

%hard linear train
acc_train = Acc_linear(alpha_di,bo,norm_train,norm_train,train_label);
fprintf('acc_train:%.2f%% when C=%.1f\n ',acc_train*100,C)
%hard linear test
acc_test = Acc_linear(alpha_di,bo,norm_train,norm_test,test_label);
fprintf('acc_test:%.2f%% when C=%.1f\n ',acc_test*100,C)

%% Kernal part
for C = [1e6,0.1,0.6,1.1,2.1]
    for P = [1,2,3,4,5]
        [alpha_di,bo,flag] = GetDiscriminant(norm_train,train_label,'poly',P,C);
        if flag==false
            fprintf('acc_train:NA when p=%d C=%.1f\n ',P,C)
            fprintf('acc_test:NA when p=%d C=%.1f\n ',P,C)
        else
            %train
            acc_train = Acc_kernal(alpha_di,bo,norm_train,norm_train,train_label,P);
            fprintf('acc_train:%.2f%% when p=%d C=%.1f\n ',acc_train*100,P,C)
            %test
            acc_test = Acc_kernal(alpha_di,bo,norm_train,norm_test,test_label,P);
            fprintf('acc_test:%.2f%% when p=%d C=%.1f\n ',acc_test*100,P,C)
        end
    end
end

%% functions
function accuracy = Acc_linear(alpha_di,bo,train_data,data,label)
    w = sum(alpha_di'.*train_data, 2);
    pred_label = sign(w'*data+bo)';
    accuracy = mean(pred_label == label,'all');
end

function accuracy = Acc_kernal(alpha_di,bo,train_data,data,label,P)
    alpha_di_K = alpha_di.*(train_data'*data+1).^P; % (num_spport x s_dim)
    a_d_K = sum(alpha_di_K,1)'; %(1 x s_dim)'
    pred_label = sign(a_d_K + bo);
    accuracy = mean(pred_label == label,'all');
end