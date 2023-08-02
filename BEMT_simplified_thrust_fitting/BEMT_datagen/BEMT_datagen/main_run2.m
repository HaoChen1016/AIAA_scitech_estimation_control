% bemt data generation



b =  1.5652e-08;                % Thrust coeffcient N/(rpm^2)
k =  2.0862e-10;
l =  0.225;

P.b =  b;                                         
P.k =  k;  
P.l= l ;   



%%

% blade params
R=3*0.0254;                                          % propeller radius  [m]
nb=2;                                                % number of blade
A=pi*R^2;                                            % disk area
rho = 1.15;
nr = 20;                                             % number of radial points on a blade
npsi = 60;                                           % number of azimuthal points for 2*Pi  ROTOR PLANE
the0=repmat(4,[1,11]);               %absolute value of zero lift angle of attack
cla1=repmat(1.7059*pi,[1,11]);       %2-D lift curve slope
th1=(the0+[24.9844849214694,24.4885730384207,23.6542985258914,22.4816610238794,20.9706612541160,19.1212982695717,16.9335723826041,14.4074838117246,11.5430326339323,8.34021849685304,4.79904143902087])*pi/180;   %blade pitch angle in radian
c1=[7.96284784614477,11.2448599794330,13.6346682267195,15.1322722373498,15.7376722802413,15.4508682842241,14.2718602574625,12.2006482106621,9.23723208187088,5.38161196932697,0.633787695366624]*0.001;

% interpolating data for different radius location (final size of the vectors 1*nr)
th=interp1(linspace(1/11,1,11),th1,linspace(floor(0.15*nr)/nr,1,nr),'linear','extrap');  %blade pitch angle in radian
c=interp1(linspace(1/11,1,11),c1,linspace(floor(0.15*nr)/nr,1,nr),'linear','extrap');     %cord length
cla=interp1(linspace(1/11,1,11),cla1,linspace(floor(0.15*nr)/nr,1,nr),'linear','extrap');  %2-D lift curve slope extrapolated

r=linspace(floor(nr*0.01)/nr,1,nr);    % normolized radial locations
psi=linspace(0,2*pi,npsi);             % azimuth angle

maxsize=max(nr,npsi);
numvar=11;
geometry2=zeros(numvar,maxsize);

list={R,nb,A,rho,nr,npsi,th,c,cla,r,psi};

for  i=1:numvar
    
geometry2(i,1:length(list{i}))=[list{i}];

end

global geometry
geometry = geometry2;


%% for varying RPM generate training data
RPM_min = 1000;RPM_max = 25000;RPM_icrm = 1000;
Vr_x_min = -5;Vr_x_max =5; Vr_x_icrm = 1;
Vr_y_min = -5;Vr_y_max =5; Vr_y_icrm = 1;
Vr_z_min = -5;Vr_z_max =5; Vr_z_icrm = 1;

thrust_i=[];input=[];
for i = Vr_x_min:Vr_x_icrm:Vr_x_max
    
    for j = Vr_y_min:Vr_y_icrm:Vr_y_max
        
        for k = Vr_z_min:Vr_z_icrm:Vr_z_max
            
            V_rel_b=[i ,j,k];
            if norm(V_rel_b) ==0
                break;
            end
            for l=RPM_min:RPM_icrm:RPM_max
                
                RPM_now = ones(4,1)*l;
                input=[input;V_rel_b l];
                [V_rel_b RPM_now']
                
                [T_final,lambda1,lambda2]  = FWF_BEMT2(RPM_now,V_rel_b, P);
                thrust_i = [thrust_i; T_final];
                
            end
            
        end
    
    end
end

train_dataset=[input , thrust_i];
disp("Done generating training data")

%% generate random test data

[train_row, train_col] = size(train_dataset);
test_data_len = round(train_row*0.3); % 30% sample of training data

test_dataset = zeros(test_data_len,train_col);

for m=1:1:test_data_len
    inp_v = [randi([Vr_x_min,Vr_x_max]), randi([Vr_y_min,Vr_y_max]), randi([Vr_z_min Vr_z_max])];
    while norm(inp_v) ==0
        inp_v = [randi([Vr_x_min,Vr_x_max]), randi([Vr_y_min,Vr_y_max]), randi([Vr_z_min Vr_z_max])];
    end
    
    inp_rpm = ones(4,1)*randi([RPM_min RPM_max]);
    
    [inp_v inp_rpm']
    [T_final,lambda1,lambda2]  = FWF_BEMT2(inp_rpm,inp_v, P);
   
    test_dataset(m,:) = [inp_v , inp_rpm(1,1) , T_final];
    
end
disp("Done generating test data")

save('test_dataset.mat','test_dataset');
save('train_dataset.mat','train_dataset');
%% plot RPM vs thrust

%  rpm = RPM_init:increament:RPM_max;
%  plot(rpm,thrust_i)
% 
% xlabel("RPM")
% ylabel("thrust")
