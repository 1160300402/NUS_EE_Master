function lambda = get_lambda(epsilon, ws, num_pixel, img, E)
    [H, W] = size(img(:, :, 1));

    top = num_pixel - W;
    bot =  num_pixel - W;
    left = num_pixel - H;
    right = num_pixel - H;

% seperate E into 4 neighbors
    E_top = E((num_pixel - W + 1):(top+num_pixel - W), :);
    E_bot = E(1:bot, :);
    E_left = E((top + num_pixel - W + right + 1):(top + num_pixel - W + right + left), :);
    E_right = E((top + num_pixel - W + 1):(top + num_pixel - W + right), :);

% seperate into 3 channels rgb
    r = img(:, :, 1);
    g = img(:, :, 2);
    b = img(:, :, 3);
    intensity = (r + g + b) / 3;

% find the U matrix for all directions bot, top, right, left
    array = zeros(1, num_pixel);
    array(unique(E_top(:, 1))) = array(unique(E_top(:, 1))) + 1;
    top1 = find(array == 1);
    top2 = find(array == 0);
    total_top = zeros(num_pixel, 1);
    total_top(top1) = 1./(sqrt((intensity(E_top(:, 1)) - intensity(E_top(:, 2))).^2) + epsilon);

    array = zeros(1, num_pixel);
    array(unique(E_bot(:, 1))) = array(unique(E_bot(:, 1))) + 1;
    bot1 = find(array == 1);
    bot2 = find(array == 0);
    total_bot = zeros(num_pixel, 1);
    total_bot(bot1) = 1./(sqrt((intensity(E_bot(:, 1)) - intensity(E_bot(:, 2))).^2) + epsilon);

    array = zeros(1, num_pixel);
    array(unique(E_left(:, 1))) = array(unique(E_left(:, 1))) + 1;
    left1 = find(array == 1);
    left2 = find(array == 0);
    total_left = zeros(num_pixel, 1);
    total_left(left1) = 1./(sqrt((intensity(E_left(:, 1)) - intensity(E_left(:, 2))).^2) + epsilon);

    array = zeros(1, num_pixel);
    array(unique(E_right(:, 1))) = array(unique(E_right(:, 1))) + 1;
    right1 = find(array == 1);
    right2 = find(array == 0);
    total_right = zeros(num_pixel, 1);
    total_right(right1) = 1./(sqrt((intensity(E_right(:, 1)) - intensity(E_right(:, 2))).^2) + epsilon);

    % get the number of connections of all the edges
    num_connection = zeros(1, num_pixel);
    num_connection(unique(E_top(:, 1))) = num_connection(unique(E_top(:, 1))) + 1;
    num_connection(unique(E_bot(:, 1))) = num_connection(unique(E_bot(:, 1))) + 1;
    num_connection(unique(E_left(:, 1))) = num_connection(unique(E_left(:, 1))) + 1;
    num_connection(unique(E_right(:, 1))) = num_connection(unique(E_right(:, 1))) + 1;

    % calculate and get the U matrix
    U = num_connection'./(total_left + total_right + total_top + total_bot);

    % remove index that were not used
    lambda_top = ws.* U./(total_top + epsilon);
    lambda_top(top2) = [];
    lambda_bot = ws.* U./(total_bot + epsilon);
    lambda_bot(bot2) = [];
    lambda_left = ws.* U./(total_left + epsilon);
    lambda_left(left2) = [];
    lambda_right = ws.* U./(total_right + epsilon);
    lambda_right(right2) = [];

    % combine all lambda values
    lambda = [lambda_bot;lambda_top;lambda_right;lambda_left];
end