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

best_acc = 0;
best_C = 0;
best_G = 0;
%% Kernel part
for C = [100,200,300,400]
    for G_sigma = [15,18,20,23,25,30]
        % Mercer condition check
        td_num=size(train_data,2);
        gram_m=zeros(td_num,td_num);
        for i=1:td_num
            for j=1:td_num
                gram_m(i,j)=exp(-1/(2*G_sigma*G_sigma)*sum((norm_train(:,i)-norm_train(:,j)).^2));
            end
        end
        eigenvalue=eig(gram_m);
        flag = true;
        if min(eigenvalue)<-1e-4
            flag = false;
            fprintf('This kernel candidate(G_sigma = %d, C=%d) is not through Mercer''s condition\n',G_sigma,C)
        end
        % Training
        if flag == true

            f = -1.*ones(td_num,1); 
            A = [];
            b = [];
            Aeq = train_label';
            beq = 0;
            lb = zeros(td_num,1);
            ub = C.*ones(td_num,1);
            x0 = [];
            H=zeros(td_num,td_num);
            for i=1:td_num
                for j=1:td_num
                    kernel=exp(-1/(2*G_sigma*G_sigma)*sum((norm_train(:,i)-norm_train(:,j)).^2));
                    dd=train_label(i)*train_label(j);
                    H(i,j)=dd.*kernel;
                end
            end
            options=optimset('LargeScale','off','MaxIter',1000);
            % Quadratic Programming
            Alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
            idx = find(Alpha>1e-4);
            num_SVM=length(idx);    
            g=train_label(idx);
            bN=zeros(num_SVM,1);
            for i=1:num_SVM
                a_d_k=Alpha.*train_label.*exp(-1/(2*G_sigma*G_sigma)*sum((norm_train-norm_train(:,idx(i))).^2,1)');
                bN(i)=g(i)-sum(a_d_k);
            end
            bo=mean(bN);
            % Accuracy on train set and test set
            %   train
            acc_train = Acc(Alpha,bo,norm_train,train_label,norm_train,train_label,G_sigma);
            fprintf('acc_train:%.2f%% when G_sigma=%f C=%.1f\n ',acc_train*100,G_sigma,C)
            %   test
            acc_test = Acc(Alpha,bo,norm_train,train_label,norm_test,test_label,G_sigma);
            if acc_test>best_acc
                best_acc = acc_test;
                best_G = G_sigma;
                best_C = C;
            end
            fprintf('acc_test:%.2f%% when G_sigma=%f C=%.1f\n ',acc_test*100,G_sigma,C)
        end
    end
end
fprintf('best_test:%.2f%% when G_sigma=%f C=%.1f\n ',best_acc*100,best_G,best_C)
%% functions
function accuracy = Acc(alpha,bo,train_data,train_label,data,label,G_sigma)
    g=zeros(length(label),1);
    for i=1:length(label)
        a_d_K=alpha.*train_label.*exp(-1/(2*G_sigma*G_sigma)*sum((train_data-data(:,i)).^2,1)');
        g(i)=sum(a_d_K)+bo;
    end
    pred_label=sign(g);
    accuracy = mean(pred_label == label,'all');
end