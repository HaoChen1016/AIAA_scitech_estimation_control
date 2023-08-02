
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

csvwrite('X_train.csv', X_train);
csvwrite('Y_train.csv', Y_train);
csvwrite('X_test.csv', X_test);
csvwrite('Y_test.csv', Y_test);


%% forward pass for NN with 2 hidden layer and [10;5] neurons
% hyperparameters epoch=1000 batch_size=100 optimizer='adam'
weights = csvread('weights.csv');

n_lay_neu = [10;5;1];
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
% save('weights.mat','weights');

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

%% forward pass for NN with 3 hidden layer and [10;10;10] neurons
% hyperparameters epoch=50 batch_size=100 optimizer='adam'
close all;
weights1 = csvread('weights1.csv');

n_lay_neu = [10;10;10;1];
features = 4;
weights1_ = cell(1,length(n_lay_neu));
for i=1:1:length(n_lay_neu)
    if i==1 
        index_input = features+1;                %+1 means add the bias row
        index_output = n_lay_neu(i);
        weights1_{i} = weights1(1:index_input,1:index_output);
    else
        index_input_pre = index_input;
        index_input = index_input_pre + n_lay_neu(i-1) + 1;
        index_output = n_lay_neu(i);
        weights1_{i} = weights1(index_input_pre+1:index_input,1:index_output);
    end 
end
% save('weights.mat','weights');

[Y1] = forward_NN(X_train,weights1_,n_lay_neu);
[Y2] = forward_NN(X_test,weights1_,n_lay_neu);

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