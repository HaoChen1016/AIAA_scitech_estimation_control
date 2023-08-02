% %% Differentiation by using symbolic tool
% syms x1 x2 x3 vr1 vr2 vr3 q0 q1 q2 q3  d1 d2 d3 
% x = [x1;x2;x3];assume(x,'real');
% vr = [vr1;vr2;vr3];assume(vr,'real');
% q = [q0;q1;q2;q3];assume(q,'real');
% d = [d1;d2;d3];assume(d,'real');
% 
% syms rpm 
% assume(rpm,'real');
% 
% X = [vr' rpm];
% weights = csvread('weights.csv');
% n_lay_neu = [10;5;1];
% features = 4;
% weights1 = cell(1,length(n_lay_neu));
% for i=1:1:length(n_lay_neu)
%     if i==1 
%         index_input = features+1;                %+1 means add the bias row
%         index_output = n_lay_neu(i);
%         weights1{i} = weights(1:index_input,1:index_output);
%     else
%         index_input_pre = index_input;
%         index_input = index_input_pre + n_lay_neu(i-1) + 1;
%         index_output = n_lay_neu(i);
%         weights1{i} = weights(index_input_pre+1:index_input,1:index_output);
%     end 
% end
% 
% 
% fc = forward_NN(X,weights1,n_lay_neu)
% % simplify(fc)
% 
% dfcdx = jacobian(fc,x)
% dfcdvr = jacobian(fc,vr)
% % simplify(dfcdvr)
% dfcdq = jacobian(fc,q)
% dfcdd = jacobian(fc,d)
%% Automatic Differentiation 
load('train_data.mat');
load('test_data.mat');
%data process
train_dataset(:,2) = deg2rad(train_dataset(:,2));
test_dataset(:,2)  = deg2rad(test_dataset(:,2));
vr_x = train_dataset(:,1).*cos(train_dataset(:,2));
vr_y = train_dataset(:,1).*sin(train_dataset(:,2));
vr_z = train_dataset(:,3);
rpm  = train_dataset(:,4)/16000;
thrust = train_dataset(:,5)/4;
find(thrust < 0)
X_train = [vr_x vr_y vr_z rpm];
Y_train = thrust;

while find(test_dataset(:,5) < 0)
    index =find(test_dataset(:,5) < 0);
    test_dataset(index(1),:)=[];
end 
find(test_dataset(:,5) < 0)
vr_x = test_dataset(:,1).*cos(test_dataset(:,2));
vr_y = test_dataset(:,1).*sin(test_dataset(:,2));
vr_z = test_dataset(:,3);
rpm  = test_dataset(:,4)/16000;
thrust = test_dataset(:,5)/4;

X_test = [vr_x vr_y vr_z rpm];
Y_test = thrust;
weights = csvread('weights.csv');
n_lay_neu = [10;5;1];
features= 4;
weights1 = cell(1,length(n_lay_neu));
for i=1:1:length(n_lay_neu)
    if i==1 
        index_input = features+1;                %+1 means add the bias row
        index_output = n_lay_neu(i);
        weights1{i} = weights(1:index_input,1:index_output);
    else
        index_input_pre = index_input;
        index_input = index_input_pre + n_lay_neu(i-1) + 1;
        index_output = n_lay_neu(i);
        weights1{i} = weights(index_input_pre+1:index_input,1:index_output);
    end 
end
% save('weights.mat','weights');

[dydx] = dfcdvr(X_test(2,:),weights1,n_lay_neu)
