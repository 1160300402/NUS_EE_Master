%% preprocess
clc
clear

%% get MLP and plot
train_x = -1.6:0.05:1.6;
train_y = 1.2*sin(pi*train_x) - cos(2.4*pi*train_x);

for i = [1:10,20,50,100]
    % get net
    net = feedforwardnet(i,'trainlm');
    net.trainparam.lr=0.03;
    net.trainparam.epochs=10000;
    net.trainparam.goal=1e-5;
    % train the net
    [net,tr]=train(net,train_x,train_y);
    % test
    test_x = -3:0.01:3;
    test_y = 1.2*sin(pi*test_x) - cos(2.4*pi*test_x);
    y = net(test_x);
    y_3 = net([-3,3]);
    fprintf('When hiddenLayer is %d, when x=-3 and +3,output value is\n',i)
    disp(y_3)
    % plot
    fig = figure();
    hold on
    plot(test_x,test_y,'-','LineWidth',2)
    scatter(train_x,train_y)
    plot(test_x,y,'--','LineWidth',2)
    ylim([-2.5 2.5])
    legend('Groundtruth','Train Points','Approximation Line')
    title(sprintf('Mode:Batch with trainlm ,HiddenLayer:%d ',i))
    ylabel('Y')
    xlabel('X')
    hold off
    % save image
    saveas(fig,sprintf('HiddenLayer%02d.png',i));
end