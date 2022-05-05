function [Q_function] = Q_learning(reward, Dis_factor, N, initial_S, end_S, Lr_type, Lr_min, Q_threshold)

    % Initialize parameters 
    Q_function = zeros(100,4);
    trial = 1; 
    while trial <= N
        % Initialize trial parameters
        k = 1;
        s_k = initial_S;
        
        Q_k = Q_function;
        % no k_max every trial
        while Learning_rate(Lr_type, k) >= Lr_min && s_k ~= end_S
            allow_actions = get_actions(s_k);
            
            Q_temp = ones(4, 1) * -1000;
            for action = allow_actions
                Q_temp(action) = Q_k(s_k, action);
            end

            idxs = find(Q_temp == max(Q_temp)); % opt action may more than one
            opt_action = datasample(idxs, 1);
            
            % Exploration or exploitation
            explore_Pro = Learning_rate(Lr_type, k);
            if rand() < 1 - explore_Pro
                a_k = opt_action;
            else
                allow_actions = allow_actions(allow_actions ~= opt_action);
                a_k = datasample(allow_actions, 1);
            end
            s_k1 = get_sk1(s_k, a_k);

            % Update Q_value
            Q_k1 = Q_k;
            max_Q = max(Q_k(s_k1, :));
            lr = explore_Pro;
            Q_k1(s_k, a_k) = Q_k(s_k, a_k) + lr * (reward(s_k, a_k) + Dis_factor * max_Q - Q_k(s_k, a_k));
            s_k = s_k1;
            k = k + 1;
            Q_k = Q_k1;
        end
        
        % Check convergence of Q_function
        if max(max(abs(Q_function - Q_k1))) < Q_threshold
            break;
        else
            Q_function = Q_k1;
            trial = trial + 1; 
        end
    end
end

function lr = Learning_rate(type, k)
    switch type
        case 1
            lr = 1/k;
        case 2
            lr = 100 / (100 + k);
        case 3
            lr = (1 + log(k)) / k;
        case 4
            lr = (1 + 5*log(k)) / k;
        case 6
            lr = 2^(-0.002*k);
        otherwise
            lr = 1/k;
    end
end

function actions = get_actions(S)
    actions = [];

    if mod(S, 10) ~= 1
        actions = [actions 1];
    end
    if S < 91
        actions = [actions 2];
    end
    if mod(S, 10) ~= 0
        actions = [actions 3];
    end
    if S > 10
        actions = [actions 4];
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