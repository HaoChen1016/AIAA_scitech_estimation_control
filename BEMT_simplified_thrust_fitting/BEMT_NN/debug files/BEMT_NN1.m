
%% 
load('train_data.mat');
load('test_data.mat');
% normalized data
% X_train_norm = [train_dataset(:,1)/20 train_dataset(:,2)/360 train_dataset(:,3)/5 train_dataset(:,4)/16000];
% Y_train_norm = train_dataset(:,5)/4;
% X_test_norm = [test_dataset(:,1)/20 test_dataset(:,2)/360 test_dataset(:,3)/5 test_dataset(:,4)/16000];
% Y_test_norm = test_dataset(:,5)/4;
% csvwrite('X_train_norm.csv', X_train_norm);
% csvwrite('Y_train_norm.csv', Y_train_norm);
% csvwrite('X_test_norm.csv', X_test_norm);
% csvwrite('Y_test_norm.csv', Y_test_norm);

% X = [test_dataset(:,1)/20 test_dataset(:,2)/360 test_dataset(:,3)/5 test_dataset(:,4)/16000];
% Y = test_dataset(:,5)/4;
X = [train_dataset(:,1)/20 train_dataset(:,2)/360 train_dataset(:,3)/5 train_dataset(:,4)/16000];
Y = train_dataset(:,5)/4;
W = csvread('weights_normalized.csv');
n_lay_neu = [3;2;1];
[Y_fitted] = forward_NN(X,W,n_lay_neu);
% visualization
figure();
plot(Y,'r.');hold on;
plot(Y_fitted,'b.');hold on;
title('eveluation');legend('true\_thrust','fitted\_thrust');
xlabel('time(s)');ylabel('(N)');

%%
load('train_data.mat');
load('test_data.mat');
% original data 
% X_train = train_dataset(:,1:4);
% Y_train= train_dataset(:,5)/4;
% X_test = test_dataset(:,1:4);
% Y_test = test_dataset(:,5)/4;
% csvwrite('X_train.csv', X_train);
% csvwrite('Y_train.csv', Y_train);
% csvwrite('X_test.csv', X_test);
% csvwrite('Y_test.csv', Y_test);

X = train_dataset(:,1:4);
Y = train_dataset(:,5)/4;
% X = test_dataset(:,1:4);
% Y = test_dataset(:,5)/4;

W = csvread('weights.csv');
n_lay_neu = [3;2;1];
[Y_fitted] = forward_NN(X,W,n_lay_neu);
% visualization
figure();
plot(Y,'r.');hold on;
plot(Y_fitted,'b.');hold on;
title('thrust');legend('true\_thrust','fitted\_thrust');
xlabel('time(s)');ylabel('(N)');