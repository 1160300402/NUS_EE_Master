%% preprocess
clc
clear

%% Start SOM
X = randn(800,2);
s2 = sum(X.^2,2);
trainX = (X.*repmat(1*(gammainc(s2/2,1).^(1/2))./sqrt(s2),1,2))'; % 2x800 matrix
w = rand(2, 8, 8);

for epoch = 1:500
    sample_idx = randi(800);
    x = trainX(:, sample_idx);
    distance = zeros(8, 8);
    for i = 1:8
        for j=1:8
            distance(i, j) = norm(x-w(:, i, j));
        end
    end 
    
    [min_y, idx_hang] = min(distance);
    [minx, min_lie] = min(min_y);
    min_hang = idx_hang(min_lie);
    
    d = zeros(8,8);
    for i=1:8
        for j=1:8
            d(i, j) = norm([i,j]-[min_hang,min_lie]);
        end
    end
    h = exp(-d.^2/(2 * sigma(epoch)^2));
    lr = 0.1 * exp(-epoch / 500);
    for i = 1:8
        for j=1:8
            w(:, i, j) = w(:, i, j) + lr * h(i, j) * (x - w(:, i, j));
        end
    end 
end

fig = figure;
hold on
plot(trainX(1,:),trainX(2,:),'+r');
w1 = squeeze(w(1,:,:));
w2 = squeeze(w(2,:,:));
for i = 1:8
    plot(w1(i, :),w2(i, :),'bo-');
    plot(w1(:, i),w2(:, i),'bo-');
end
title("SOM:circle")
filename = ['q3b.png'];
saveas(fig,filename)

function s = sigma(n)
    N = 500;
    sigma_0 = sqrt(8^2 + 8^2)/2; %sqrt(M^2 + N^2)/2
    T1 = N / log(sigma_0);
    
    s = sigma_0 * exp(-n/T1);
end