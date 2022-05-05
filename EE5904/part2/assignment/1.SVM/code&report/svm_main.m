%% Load data
load('train.mat')
%load('eval.mat')

%% Preprocessing input data
mu = mean(train_data,2); %get the mean of train data
sigma = std(train_data,0,2); % get the standard deviation of train data
norm_train = (train_data - mu)./sigma;
norm_eval = (eval_data - mu)./sigma;
C = 200;
G_sigma = 30;
td_num = 2000;

%% Train function

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
       D=train_label(i)*train_label(j);
       H(i,j)=D.*kernel;
   end
end
options=optimset('LargeScale','off','MaxIter',1000);

Alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
SV = find(Alpha>1e-4);
% Calculate disciminant parameters
num_SVM=length(SV);    
g=train_label(SV);
bN=zeros(num_SVM,1);
for i=1:num_SVM
   a_d_k=Alpha.*train_label.*exp(-1/(2*G_sigma*G_sigma)*sum((norm_train-norm_train(:,SV(i))).^2,1)');
   bN(i)=g(i)-sum(a_d_k);
end
bo=mean(bN);

%% Predict eval
ev_num=size(norm_eval,2);
g=zeros(ev_num,1);
for i=1:ev_num
    a_d_K=Alpha.*train_label.*exp(-1/(2*G_sigma*G_sigma)*sum((norm_train-norm_eval(:,i)).^2,1)');
    g(i)=sum(a_d_K)+bo;
end
eval_predicted=sign(g);
%accuracy = mean(eval_predicted == eval_label,'all');