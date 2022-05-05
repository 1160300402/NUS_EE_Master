%% preprocess
clc
clear

%% get RBFN and design
train_x = -1.6:0.08:1.6;
train_y = 1.2*sin(pi*train_x) - cos(2.4*pi*train_x)+ 0.3 * randn(1, 41);
test_x = -1.6:0.01:1.6;
test_y = 1.2*sin(pi*test_x) - cos(2.4*pi*test_x);

M = 20;
idx = randsample(41,M);
x_center = train_x(idx);
y_center = train_y(idx);
sigma = (max(x_center) - min(x_center)) / sqrt(2 * M);

distance = abs(x_center - reshape(train_x, [41, 1]));
train_fi = exp(-distance.^2/(2* sigma^2));

w = train_fi \ train_y'; % fi¡¤w = train_y'

distance_test = abs(x_center - reshape(test_x, [321, 1]));
test_fi = exp(-distance_test.^2/(2* sigma^2));

y_pred = test_fi * w;
error_mean = mean((y_pred' - test_y).^2);
fprintf('Mean squared error is %.2f',error_mean);
% plot
fig = figure();
hold on
plot(test_x,test_y,'-','LineWidth',2)
scatter(x_center,y_center)
plot(test_x,y_pred','--','LineWidth',2)
ylim([-3 3])
legend('Ground Truth','Train Centers','Approximation Line')
title(sprintf('Exact Interpolation'))
ylabel('Y')
xlabel('X')
hold off