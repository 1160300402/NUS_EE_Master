%% preprocess
clc
clear

%%
% A0232893X: Omit class 3 and 4
% load data
load('Digits.mat')
% training data, 784x1000 matrix
% train_classlabel, 1x1000 vector
% test_data, 784x100 matrix
% test_classlabel, 1x100 vector

% find the location of classes not 3,4
trainIdx = find(train_classlabel~=3 & train_classlabel~=4); 
TrLabel = train_classlabel(trainIdx); 
Train_Data = train_data(:,trainIdx); % 784x600 matrix

%% Start SOM
w = rand(784, 10, 10);
for epoch = 1:10000
    sample_idx = randi(600);
    x = Train_Data(:, sample_idx);
    distance = zeros(10, 10);
    for i = 1:10
        for j=1:10
            distance(i, j) = norm(x-w(:, i, j));
        end
    end 
    
    [min_y, idx_hang] = min(distance);
    [minx, min_lie] = min(min_y);
    min_hang = idx_hang(min_lie);
    
    d = zeros(10, 10);
    for i=1:10
        for j=1:10
            d(i, j) = norm([i,j]-[min_hang,min_lie]);
        end
    end
    h = exp(-d.^2/(2 * sigma(epoch)^2));
    lr = 0.1 * exp(-epoch / 10000);
    for i = 1:10
        for j=1:10
            w(:, i, j) = w(:, i, j) + lr * h(i, j) * (x - w(:, i, j));
        end
    end 
end

% show the image of weights.
figure;
for i = 1:10
    for j = 1:10
        subplot(10,10,(i-1)*10+j);
        imshow(reshape(w(:, i, j), [28,28]));
    end
end
save('Q3c_w.mat','w');

% show the corresponding semantic map
winner_input = zeros(10, 10);
for i = 1:10
    for j = 1:10
        weight = w(:, i, j);
        distance = zeros(1, 600);
        for input_idx = 1:600
            x = Train_Data(:, input_idx);
            distance(input_idx) = norm(x-weight);
        end
        [~, win] = min(distance);
        winner_input(i, j) = TrLabel(win);
    end
end
save('Q3c_semanticmap.mat','winner_input');
figure;
im = imagesc(winner_input);
colorbar
textStrings = int2str(winner_input(:));       % Create strings from the matrix values
[x, y] = meshgrid(1:10);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), 'HorizontalAlignment', 'center');

function s = sigma(n)
    N = 1000;
    sigma_0 = sqrt(10^2 + 10^2)/2; %sqrt(M^2 + N^2)/2
    T1 = N / log(sigma_0);
    
    s = sigma_0 * exp(-n/T1);
end