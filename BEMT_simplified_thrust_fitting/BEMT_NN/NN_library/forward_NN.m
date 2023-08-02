function [Y] = forward_NN(X,W,n_lay_neu)
%FORWARD_NN Summary of this function goes here
%   Detailed explanation goes here
[samples,features] = size(X);
n_layer = length(n_lay_neu);

for i=1:1:length(n_lay_neu)
    if i==1    
%         index_input = features;
%         index_output = n_lay_neu(i);
%         w = W(1:index_input,1:index_output);
%         b = W(index_input+1,1:index_output);
        w = W{i}(1:end-1,:);
        b = W{i}(end,:);
        z = X*w + b;
        a = activation(z,"tanh");   
    elseif i==n_layer
%         index_input_pre = index_input+1;
%         index_input = index_input_pre + n_lay_neu(i-1);
%         index_output = n_lay_neu(i);
%         w = W(index_input_pre+1:index_input,1:index_output);
%         b = W(index_input+1,1:index_output);
        w = W{i}(1:end-1,:);
        b = W{i}(end,:);
        z = a*w + b;
        Y = activation(z,"linear");
    else 
%         index_input_pre = index_input +1;
%         index_input = index_input_pre + n_lay_neu(i-1);
%         index_output = n_lay_neu(i);
%         w = W(index_input_pre+1:index_input,1:index_output);
%         b = W(index_input+1,1:index_output);
        w = W{i}(1:end-1,:);
        b = W{i}(end,:);
        z = a*w + b;
        a = activation(z,"tanh");
    end
    
end
end

