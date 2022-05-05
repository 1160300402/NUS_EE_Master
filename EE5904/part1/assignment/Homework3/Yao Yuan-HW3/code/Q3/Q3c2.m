%% preprocess
clc
clear

% load data
load('Digits.mat')
load('Q3c_semanticmap.mat')
load('Q3c_w.mat')
% find the location of classes not 3,4
testIdx = find(test_classlabel~=3 & test_classlabel~=4); 
TeLabel = test_classlabel(testIdx); 
Test_Data = test_data(:,testIdx); % 784x60 matrix

w_new = reshape(w, 784, 100);
w_i_new = reshape(winner_input, 1, 100);
test_winner = zeros(1, 60);
test_pred = zeros(1, 60);
for idx = 1:60
    x = Test_Data(:, idx);
    distance = zeros(1, 100);
    for i = 1:100
        weight = w(:, i);
        distance(i) = norm(x-weight);
    end
    [~, win] = min(distance);
    test_pred(idx) = w_i_new(win);
end
tr_acc = sum(test_pred == TeLabel)/ 60;
display(tr_acc)