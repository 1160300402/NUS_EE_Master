%% Initialize
clc;
clear;
addpath(genpath('../GCMex/'));

%% Begin code
SOURCE_COLOR = [0, 0, 255]; %blue = foreground
SINK_COLOR = [245, 210, 110]; %yellow = background
img = imread('Bayes.png');
[Height, Width, Depth] = size(img);
unary = zeros(2, Width*Height);
edge_idx = 0;

for y = 0:Height-1
    for x = 0:Width-1
        c = reshape(img(y+1, x+1,:),[1,3]);
        node = y * Width + x +1;
        
        % data term
        unary(1, node) = get_dist(c, SINK_COLOR);
        unary(2, node) = get_dist(c, SOURCE_COLOR);
              
        if y+1 < Height
            edge_idx = edge_idx + 1;
            A(edge_idx) = node;
            B(edge_idx) = node + Width;
        end
        if x+1 < Width
            edge_idx = edge_idx + 1;
            A(edge_idx) = node;
            B(edge_idx) = node + 1;
        end
        if y-1 >= 0
            edge_idx = edge_idx + 1;
            A(edge_idx) = node;
            B(edge_idx) = node - Width;
        end
        if x-1 >= 0
            edge_idx = edge_idx + 1;
            A(edge_idx) = node;
            B(edge_idx) = node - 1;
        end
    end
end

%% Find best lambda
lambda_list = [1, 10, 50 , 100, 200, 500, 1000];
class = zeros(Width * Height, 1);
labelcost = [0 1 ; 1 0];

for lambda = lambda_list

    pairwise = sparse(A, B, lambda);
    labelcost = [0 1 ; 1 0];
    [labels, ~, ~] = GCMex(class, single(unary), pairwise, single(labelcost),1);
    labels = reshape(labels, [Width, Height])';
    for y = 1:Height
        for x = 1:Width
            if labels(y, x) == 1
                output(y, x, :) = SOURCE_COLOR;
            end
            if labels(y, x) == 0
                output(y, x, :) = SINK_COLOR;          
            end
        end
    end
    figure;
    imshow(uint8(output));
    pic_name = sprintf('Bayes%d.jpg', lambda);
    imwrite(uint8(output), pic_name);
end

%% Get distance function
function d = get_dist(c1, c2)
    d = sum(abs(double(c1) - double(c2))) / 3;
end