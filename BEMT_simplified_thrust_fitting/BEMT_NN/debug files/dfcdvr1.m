function [dydx] = dfcdvr(X,W,n_lay_neu)
%DFCDVR Summary of this function goes here
%   Detailed explanation goes here
W = csvread('weights1.csv');
n_lay_neu = [3;2;1];
n_layer = length(n_lay_neu);

[samples,featurs] = size(X);
for i=1:1:length(n_lay_neu)
    if i==1    
        index_input = featurs;
        index_output = n_lay_neu(i);
        w{i} = W(1:index_input,1:index_output);
        b{i} = W(index_input+1,1:index_output);
        z{i} = X*w{i} + b{i};
        a{i} = activation(z{i},"relu"); 
    elseif i==n_layer
        index_input_pre = index_input+1;
        index_input = index_input_pre + n_lay_neu(i-1);
        index_output = n_lay_neu(i);
        w{i} = W(index_input_pre+1:index_input,1:index_output);
        b{i} = W(index_input+1,1:index_output);
        z{i} = a{i-1}*w{i} + b{i};
        Y = activation(z{i},"linear");
    else 
        index_input_pre = index_input +1;
        index_input = index_input_pre + n_lay_neu(i-1);
        index_output = n_lay_neu(i);
        w{i} = W(index_input_pre+1:index_input,1:index_output);
        b{i} = W(index_input+1,1:index_output);
        z{i} = a{i-1}*w{i} + b{i};
        a{i} = activation(z{i},"relu");
    end
end

for j=length(n_lay_neu):-1:1
    if j == length(n_lay_neu)
        dydx = w{j}';
    elseif j==1
        dadz = zeros(n_lay_neu(j),n_lay_neu(j));
        for k=1:n_lay_neu(j)
            dadz(k,k) = derive_activation(z{j}(1,k),"relu");
        end
        dydx = dydx*dadz*w{j}(1:3,:)';
    else
        dadz = zeros(n_lay_neu(j),n_lay_neu(j));
        for k=1:n_lay_neu(j)
            dadz(k,k) = derive_activation(z{j}(1,k),"relu");
        end
        dydx = dydx*dadz*w{j}';
    end 
end

end

