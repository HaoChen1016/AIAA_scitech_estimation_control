function dz = derive_activation(z,option)
%ACTIVATION Summary of this function goes here
%   Detailed explanation goes here
if option == "relu"
    [samples, dim] =size(z);
    for i=1:1:samples
        for j=1:1:dim
%             a(i,j) = max([0,z(i,j)]); 
            if z(i,j)>= 0  
                dz(i,j) = 1;
            else
                dz(i,j) = 0;
            end 
            
        end 
    end
elseif option == "linear"
    dz = 1;
elseif option == "tanh"
    dz = 1-tanh(z)^2;
end
end

