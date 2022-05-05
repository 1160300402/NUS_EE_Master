%% load the data
%load('qeval.mat');

% Dis_factor, N, initial_S, end_S, Lr_type, Lr_min, Q_threshold
N = 3000;
initial_S = 1;
end_S = 100;
Lr_min = 0.005;
Q_threshold = 0.01;

% Variables used to store results
path_store = zeros(0, 100); 
rt_store = []; 
optplicy_store = zeros(0, 100);

for Dis_factor = [0.9]
    for Lr_type = [6]
        goal_reached_num = 0;
        Execution_times = [];
        for run = 1:10
            tic;
            Q_values = Q_learning(qevalreward, Dis_factor, N, initial_S, end_S, Lr_type, Lr_min, Q_threshold);
            toctime = toc;
            [path, R_t] = get_trajectory(Q_values, qevalreward, Dis_factor);
            if ismember(end_S, path)
                goal_reached_num = goal_reached_num + 1;
                Execution_times(end + 1) = toctime;    
            end
            
            optical_policy = get_optpolicy(Q_values);
            path_store(end + 1, :) = path';
            rt_store(end + 1) = R_t;
            optplicy_store(end + 1, :) = optical_policy';
        end
        Avg_extime = 0;
        if ~isempty(Execution_times)
            Avg_extime = mean(Execution_times);
        end
        fprintf('When lr_type = %d, dis_factor = %f. The sucessful run time is %d, avg_extime is %f. sec\n',Lr_type,Dis_factor,goal_reached_num,Avg_extime);
    end
end

%% Display trajectory and maximum reward and path
[max_Rt, idx] = max(rt_store);
disp(['Max total reward: ' num2str(max_Rt)]);
best_path = path_store(idx, :);
best_path = (best_path(best_path ~= 0))';
plot_trajectory(best_path, max_Rt);
best_policy = optplicy_store(idx, :);
best_policy
plot_best_policy(best_policy);
qevalstates = best_path';
qevalstates

function plot_best_policy(best_policy)
    
    figure;
    axis([0 10 0 10]);
    grid on
    set(gca,'xtick',[0:10]);
    set(gca,'ytick',[0:10]);
    set(gca,'xticklabel',[]);
    set(gca,'yticklabel',[]);
    set(gca, 'YDir', 'reverse');
    hold on
    pbaspect([1 1 1]);

    for i = 1:(length(best_policy) -1)

        x = fix((i + 9)/10);
        y = mod(i - 1, 10) + 1;
    
        switch best_policy(i)
            case 1
                plot(x - 0.5, y - 0.5, '^r');
            case 2
                plot(x - 0.5, y - 0.5, '>r');
            case 3
                plot(x - 0.5, y - 0.5, 'vr');
            case 4
                plot(x - 0.5, y - 0.5, '<r');
        end
        plot(10 - 0.5, 10 - 0.5, '*');

    end
end

function plot_trajectory(path, max_Rt)
    
    figure;
    axis([0 10 0 10]);
    title(['Execution of optimal policy with associated reward = ' num2str(max_Rt)])
    grid on
    set(gca,'xtick',[0:10]);
    set(gca,'ytick',[0:10]);
    set(gca,'xticklabel',[]);
    set(gca,'yticklabel',[]);
    set(gca, 'YDir', 'reverse');
    hold on
    pbaspect([1 1 1]);

    for i = 1:(length(path) - 1)
        x = fix((path(i) + 9)/10);
        y = mod(path(i) - 1, 10) + 1;
    
        switch path(i + 1) - path(i)
            case -1
                plot(x - 0.5, y - 0.5, '^r');
            case 10
                plot(x - 0.5, y - 0.5, '>r');
            case 1
                plot(x - 0.5, y - 0.5, 'vr');
            case -10
                plot(x - 0.5, y - 0.5, '<r');
        end
    
        if path(i+1) == 100
            plot(10 - 0.5, 10 - 0.5, '*');
        end
    end
end

function [path, R_t] = get_trajectory(Q_values, reward, Dis_factor)
    path = zeros(100, 1);
    R_t = 0;
    cur_state = 1; 
    path(1) = 1;
    k = 0;

    while cur_state ~= 100 && k < 99
        [~, opt_action] = max(Q_values(cur_state, :));    
        R_t = R_t + Dis_factor^k * reward(cur_state, opt_action);
        cur_state = get_sk1(cur_state, opt_action);    
        k = k + 1;
        path(k+1) = cur_state;
    end
end

function sk1 = get_sk1(sk, action)
    switch action
        case 1
            sk1 = sk - 1;
        case 2
            sk1 = sk + 10;
        case 3
            sk1 = sk + 1;
        case 4
            sk1 = sk - 10;
    end
end

function opt_policy = get_optpolicy(Q_functions)
    opt_policy = [];
    cur_state = 1;
    opt_a = 0;
    while cur_state ~= 101
        Q_temp = Q_functions(cur_state, :);
        [~, opt_a] = max(Q_temp);
        switch opt_a
            case 1
                opt_policy = [opt_policy;1];
            case 2
                opt_policy = [opt_policy;2];
            case 3
                opt_policy = [opt_policy;3];
            case 4
                opt_policy = [opt_policy;4];
        end
        cur_state = cur_state + 1;
    end
end