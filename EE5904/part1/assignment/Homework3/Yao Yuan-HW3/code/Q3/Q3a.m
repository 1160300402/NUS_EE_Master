%% preprocess
clc
clear

%Start SOM
x = linspace(-pi,pi,400);
trainX = [x; sinc(x)]; % 2x400 matrix
w = rand(2, 40);

for epoch = 1:500
    sample_idx = randi(400);
    x = trainX(:, sample_idx);
    distance = zeros(1, 40);
    for i = 1:40
        distance(i) = norm(x-w(:, i));
    end 
    [~, idx_winner] = min(distance);
    
    d = abs([1:40]-idx_winner);
    h = exp(-d.^2/(2 * sigma(epoch)^2));
    lr = 0.1 * exp(-epoch / 500);
    for j = 1:40
        w(:,j) = w(:,j) + lr * h(j) * (x - w(:,j));
    end
end
fig = figure;
hold on
plot(trainX(1,:),trainX(2,:),'+r'); 
plot(w(1,:),w(2,:),'o-');
filename = ['q3a.png'];
saveas(fig,filename)

function s = sigma(n)
    N = 500;
    sigma_0 = sqrt(40^2 + 2^2)/2; %sqrt(M^2 + N^2)/2
    T1 = N / log(sigma_0);
    
    s = sigma_0 * exp(-n/T1);
end