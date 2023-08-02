load('dataset\train_data_v1.mat');
%%
%A = train_data(:,[1 2 3 4 8]);
L1 = train_dataset(:,end-1);
L2 = train_dataset(:,end);
thrust = train_dataset(:,5);
w = train_dataset(:,4);
vh = train_dataset(:,1);
ang = train_dataset(:,2);
vz = train_dataset(:,3);
ind = find(thrust<25);
w = w(ind);
vh = vh(ind);
ang = ang(ind);
vz = vz(ind);
thrust = thrust(ind);
T = thrust';
%%
%% neural network
parpool
Td = normalize(T);
wd = normalize(w);
vhd = normalize(vh);
vzd = normalize(vz);
angd = normalize(ang/360*2*pi);
Xd = [wd vhd angd vzd]';
net = feedforwardnet([10 10]);
net = train(net,Xd,Td,'useParallel','yes','showResources','yes');
Y = net(Xd);
%%
Tp = Y/2*(max(T)-min(T)) + max(T)/2+min(T)/2;
figure;
plot(abs(Tp-T)./T)
figure;
plot(abs(Y-Td)./Td)
%% plot the curves
intv = 16;
figure;
j = 1;
while 1
    plot(T(intv*(j-1)+1:intv*j));
    hold on;
    if j*intv == length(T)
        break;
    end
    j = j + 1;
end
%% %% model fitting T = cw^2 + c2*w*vh^2 + c3 * vz
D = [w.^2 vh.^2 vz ones(length(w),1)];
C = D\T';
perr = ((D*C-T'))./(T');
figure; 
plot(T);
hold on
plot(D*C)

%%
function xn = normalize(x)
xmin = min(x);
xmax = max(x);
xavg = xmin/2 + xmax/2;
xn = (x-xavg)/(xmax-xmin)*2;
end