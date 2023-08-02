function [dydx] = dfcdvr(X,W,n_lay_neu)
%DFCDVR Summary of this function goes here
%   Detailed explanation goes here
n_layer = length(n_lay_neu);

[samples,featurs] = size(X);
for i=1:1:length(n_lay_neu)
    if i==1    
        w{i} = W{i}(1:end-1,:);
        b{i} = W{i}(end,:);
        z{i} = X*w{i} + b{i};
        a{i} = activation(z{i},"tanh"); 
    elseif i==n_layer
        w{i} = W{i}(1:end-1,:);
        b{i} = W{i}(end,:);
        z{i} = a{i-1}*w{i} + b{i};
        Y = activation(z{i},"linear");
    else 
        w{i} = W{i}(1:end-1,:);
        b{i} = W{i}(end,:);
        z{i} = a{i-1}*w{i} + b{i};
        a{i} = activation(z{i},"tanh");
    end
end

for j=length(n_lay_neu):-1:1
    if j == length(n_lay_neu)
        dydx = w{j}';
    elseif j==1
        dadz = zeros(n_lay_neu(j),n_lay_neu(j));
        for k=1:n_lay_neu(j)
            dadz(k,k) = derive_activation(z{j}(1,k),"tanh");
        end
        dydx = dydx*dadz*w{j}(1:3,:)';
    else
        dadz = zeros(n_lay_neu(j),n_lay_neu(j));
        for k=1:n_lay_neu(j)
            dadz(k,k) = derive_activation(z{j}(1,k),"tanh");
        end
        dydx = dydx*dadz*w{j}';
    end 
end

end

