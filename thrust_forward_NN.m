function [Y] = thrust_forward_NN(X,W,n_lay_neu)
%FORWARD_NN Summary of this function goes here
%   Detailed explanation goes here
[samples,features] = size(X);
n_layer = length(n_lay_neu);

a = cell(1,length(n_lay_neu));

for i=1:1:length(n_lay_neu)
    if i==1
        w = W{i}(1:end-1,:);
        b = W{i}(end,:);
        z = X*w + b;
        a{i} = activation(z,"tanh");   
    elseif i==n_layer
        w = W{i}(1:end-1,:);
        b = W{i}(end,:);
        z = a{i-1}*w + b;
        Y = activation(z,"linear");
    else 
        w = W{i}(1:end-1,:);
        b = W{i}(end,:);
        z = a{i-1}*w + b;
        a{i} = activation(z,"tanh");
    end
    
end
end

