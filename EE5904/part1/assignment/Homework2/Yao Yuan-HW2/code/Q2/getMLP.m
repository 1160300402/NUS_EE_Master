function [ net] = getMLP( n, images, labels, train_num, epochs )
% Construct a 1-n-1 MLP and conduct sequential training.
%
% Args:
% n: int, number of neurons in the hidden layer of MLP.
% images: matrix of (image_dim, image_num), containing possibly preprocessed image data as input.
% labels: vector of (1, image_num), containing corresponding label of each image.
% train_num: int, number of training images.
% val_num: int, number of validation images.
% epochs: int, number of training epochs.
%
% Returns:
% net: object, containing trained network.
% accu_train: vector of (epochs, 1), containing the accuracy on training
% set of each eopch during trainig.
% accu_val: vector of (epochs, 1), containing the accuracy on validation
% set of each eopch during trainig.
% 1. Change the input to cell array form for sequential training
    images_c = num2cell(images, 1);
    labels_c = num2cell(labels, 1);
 
% 2. Construct and configure the MLP
    net = fitnet(n,'traingdx');
    net.divideFcn = 'dividetrain'; % input for training only
    net.trainParam.epochs = epochs;

% 3. Train the network in sequential mode
    for i = 1 : epochs
        if mod(i,epochs/10)==0
            display(['Epoch: ', num2str(i)]);
        end
        idx = randperm(train_num); % shuffle the input
        net = adapt(net, images_c(:,idx), labels_c(:,idx));
    end
end