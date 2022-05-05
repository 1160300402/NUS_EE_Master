function [alpha_di,bo,flag] = GetDiscriminant(train_data,train_label,ker_type,P,C)

% This function is used to get the discriminant function
%#############################
% Input Args 
% train_data: training data after pre-processing (m*N)
% train_label: training label (N*1) 
% ker_type = (kernel type) 
%   'linear'  Linear Kernel      x1'*x2
%   'poly'    Polynomial Kernal (x1'*x2+1)^p
% P = degree of polynomial kernel
% C = cost of violating error
%#############################

% ######## Output Args ########
% alpha_di = alpha multiplied to train_label
% bo = bias
% flag : True of False. True means through Mercer condition check
% #############################


switch ker_type
    case 'linear'
        kernal = train_data'*train_data; 
        
    case 'poly'
        kernal  = (train_data'*train_data + 1).^P;
end

%% Mercer condition check
eigenvalues = eig(kernal);
flag = true;
if min(eigenvalues) < -1e-4
    flag = false;
    alpha_di = [];
    bo = [];
    fprintf('This kernel candidate(P = %d, C=%d) is not through Mercer''s condition\n',P,C)
end

%% Get the discriminant parameters
if flag==true
    td_num=size(train_data,2);

    H = (train_label*train_label').*kernal;
    f = -1.*ones(td_num,1); 
    A = [];
    b = [];
    Aeq = train_label';
    beq = 0;
    lb = zeros(td_num,1);
    ub = C.*ones(td_num,1);
    x0 = [];

    options = optimset('LargeScale','off','MaxIter',1000);
    alpha = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);

    alpha_di = alpha.*train_label;
    temp = kernal*alpha_di;
    SV = find(alpha>1e-4); % find support vertors
    bo = mean(train_label(SV) - temp(SV));
end