%% preprocess
clc
clear

% initialization
x = rand;
y = rand;
count = 1;
coords_h = [x,y;]; % record x,y
cost = (1-x)^2 + 100*(y-x^2)^2;
cost_h = [cost]; % record cost

while cost >= 1e-4
    count = count + 1;
    % update weights
    g = [(2*(x - 1) + 400*(x^3 - x*y)); 200*(y-x^2)];
    H = [1200*x^2 - 400*y + 2,-400*x; -400*x,200];
    w = [x;y]-H^(-1)*g; % w(k+1) = w(k) - H-1(k)g(k) 
    x = w(1);
    y = w(2);
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