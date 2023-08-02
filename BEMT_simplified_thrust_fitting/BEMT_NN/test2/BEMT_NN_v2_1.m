% inputs:
% col 1: relative velocity in x direction [-5:1:5]
% col 2: relative velocity in y direction [-5:1:5]
% col 3: relative velocity in z direction [-5:1:5]
% col 4: RPM [range 1000:1000 :25000]
% outputs:
% col 5: total thrust 

load('train_dataset2.mat');
load('test_dataset2.mat');
%data process


%check whether the thrust is negative, if yes, remove it
% find(train_dataset(:,5) < 0)         
while find(train_dataset(:,5) < 0)
    index =find(train_dataset(:,5) < 0);
    train_dataset(index(1),:)=[];
end 
find(train_dataset(:,5) < 0)
train_vr_x = train_dataset(:,1);
train_vr_y = train_dataset(:,2);
train_vr_z = train_dataset(:,3);
train_rpm  = train_dataset(:,4)/25000;
train_thrust = train_dataset(:,5)/4; %thrust for a rotor 

% train_vr_x = normalize(train_vr_x);
% train_vr_y = normalize(train_vr_y);
% train_vr_z = normalize(train_vr_z);
% train_rpm  = normalize(train_rpm);
% train_thrust = normalize(train_thrust);

X_train = [train_vr_x train_vr_y train_vr_z train_rpm];
Y_train = train_thrust;


% find(test_dataset(:,5) < 0)
while find(test_dataset(:,5) < 0)
    index =find(test_dataset(:,5) < 0);
    test_dataset(index(1),:)=[];
end 
find(test_dataset(:,5) < 0)
test_vr_x = test_dataset(:,1);
test_vr_y = test_dataset(:,2);
test_vr_z = test_dataset(:,3);
test_rpm  = test_dataset(:,4)/25000;
test_thrust = test_dataset(:,5)/4;

% test_vr_x = normalize(test_vr_x);
% test_vr_y = normalize(test_vr_y);
% test_vr_z = normalize(test_vr_z);
% test_rpm  = normalize(test_rpm);
% test_thrust = normalize(test_thrust);


X_test = [test_vr_x test_vr_y test_vr_z test_rpm];
Y_test = test_thrust;

csvwrite('X_train.csv', X_train);
csvwrite('Y_train.csv', Y_train);
csvwrite('X_test.csv', X_test);
csvwrite('Y_test.csv', Y_test);

figure();
plot(Y_train,'r.');hold on;
title('training data for thrust');
xlabel('data index');ylabel('(N)');

figure();
plot(Y_test,'r.');hold on;
title('testing data for thrust');
xlabel('data index');ylabel('(N)');
%% forward pass for NN with 3 hidden layer and [10;10] neurons
% hyperparameters epoch=100 batch_size=100 optimizer='adam'
close all;
addpath("..\NN_library");

weights = csvread('weights.csv');
save('weights.mat','weights'); 

n_lay_neu = [10;10;1]; %this should includes the output layer
features = 4;
weights_ = cell(1,length(n_lay_neu));
for i=1:1:length(n_lay_neu)
    if i==1 
        index_input = features+1;                %+1 means add the bias row
        index_output = n_lay_neu(i);
        weights_{i} = weights(1:index_input,1:index_output);
    else
        index_input_pre = index_input;
        index_input = index_input_pre + n_lay_neu(i-1) + 1;
        index_output = n_lay_neu(i);
        weights_{i} = weights(index_input_pre+1:index_input,1:index_output);
    end 
end


[Y1] = forward_NN(X_train,weights_,n_lay_neu);
[Y2] = forward_NN(X_test,weights_,n_lay_neu);

%%validation 
for i=1:1:length(Y_train)
accuracy1(i,1) = abs((Y_train(i,1) - Y1(i,1))/Y_train(i,1));
end
for i=1:1:length(Y_test)
accuracy2(i,1) = abs((Y_test(i,1) - Y2(i,1))/Y_test(i,1));
end
% visualization
figure();
plot(Y_train,'r.');hold on;
plot(Y1,'b.');hold on;
title('training');legend('true\_thrust','fitted\_thrust');
xlabel('time(s)');ylabel('(N)');

figure();
plot(accuracy1,'r.');
title('accuracy');
xlabel('train data points');ylabel('%');
mean(accuracy1)

figure();
plot(Y_test,'r.');hold on;
plot(Y2,'b.');hold on;
title('testing');legend('true\_thrust','fitted\_thrust');
xlabel('time(s)');ylabel('(N)');

figure();
plot(accuracy2,'r.');
title('accuracy');
xlabel('test data points');ylabel('%');
mean(accuracy2)

function xn = normalize(x)
xmin = min(x);
xmax = max(x);
xavg = xmin/2 + xmax/2;
xn = (x-xavg)/(xmax-xmin)*2;
end