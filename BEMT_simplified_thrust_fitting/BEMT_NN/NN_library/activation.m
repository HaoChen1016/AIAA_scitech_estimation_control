function a = activation(z,option)
%ACTIVATION Summary of this function goes here
%   Detailed explanation goes here
if option == "relu"
    [samples, dim] =size(z);
    for i=1:1:samples
        for j=1:1:dim
            a(i,j) = max([0,z(i,j)]); 
%             if z(i,j)>= 0  
%                 a(i,j) = z(i,j);
%             else
%                 a(i,j) = 0;
%             end 
            
        end 
    end
elseif option == "linear"
    a =z;
elseif option == "tanh"
%     a = tanh(z);
      a = (exp(z)-exp(-z))./(exp(z)+exp(-z));
end
end

