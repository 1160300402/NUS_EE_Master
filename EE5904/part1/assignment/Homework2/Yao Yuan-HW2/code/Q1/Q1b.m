%% preprocess
clc
clear

%% lr=0.001
x = rand;
y = rand;
count = 1;
lr = 0.001; %learning rate
coords_h = [x,y;]; % record x,y
cost = (1-x)^2 + 100*(y-x^2)^2;
cost_h = [cost]; % record cost

while cost >= 1e-4
    count = count + 1;
    % update weights
    x = x - lr*(2*(x-1)+400*x*(x^2-y));
    y = y - lr*(200*(y-x^2));
    % new cost
    cost = (1-x)^2 + 100*(y-x^2)^2;
    % record values
    coords_h = [coords_h;x,y;];
    cost_h = [cost_h;cost];
end

fprintf("The iteration times is %f.\n",count);
% plot
figure(1)
plot(coords_h(:,1),coords_h(:,2),'-->')
xlabel('x')
ylabel('y')

figure(2)
plot((1:count),cost_h,'-->')
xlabel('Iteration')
ylabel('Function value')

%% lr=1
x = rand;
y = rand;
count = 1;
lr = 1; %learning rate
coords_h = [x,y;]; % record x,y
cost = (1-x)^2 + 100*(y-x^2)^2;
cost_h = [cost]; % record cost

while ((cost >= 1e-4) || (count < 5))
    count = count + 1;
    % update weights
    x = x - lr*(2*(x-1)+400*x*(x^2-y));
    y = y - lr*(200*(y-x^2));
    % new cost
    cost = (1-x)^2 + 100*(y-x^2)^2;
    % record values
    coords_h = [coords_h;x,y;];
    cost_h = [cost_h;cost];
end

% plot
figure(3)
plot(coords_h(:,1),coords_h(:,2),'-->')
xlabel('x')
ylabel('y')

figure(4)
plot((1:count),cost_h,'-->')
xlabel('Iteration')
ylabel('Function value')