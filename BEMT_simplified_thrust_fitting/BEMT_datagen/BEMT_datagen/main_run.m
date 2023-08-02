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
% RPM_init = 8000;
% RPM_max = 16000;
% increament = 1000;
% % LES_wind_8m(:,4) = -LES_wind_8m(:,4);
% % Lambda=[];
% rel_h_min = 3; rel_h_max= 20; rel_h_icrm = 3;
% rel_v_min = -5 ; rel_v_max=5; rel_v_icrm=2.5;
% 
% head_min=0;head_max= 360;

RPM_init = 1000;RPM_max = 10000;increament = 1000;
rel_h_min = 3; rel_h_max= 6; rel_h_icrm = 3;
rel_v_min = -5 ; rel_v_max=5; rel_v_icrm =5;

head_min=0;head_max= 360;head_icrm =180;

Lambda_i=[];thrust_i=[];input=[];
for i= rel_h_min:rel_h_icrm:rel_h_max
    
    for j=head_min:head_icrm:head_max
        
        for k=rel_v_min:rel_v_icrm:rel_v_max
            
            V_info=[i ,j,k];
             
            for l=RPM_init:increament:RPM_max
                
                RPM_now = ones(4,1)*l;input=[input;V_info l];
                
                 [T_final,lambda1,lambda2]  = FWF_BEMT(RPM_now,V_info, P);
                thrust_i = [thrust_i; T_final];
                Lambda_i=[Lambda_i;lambda1,  lambda2];
                
                
            end
            
            
        end
        
    
    end
end

train_dataset=[input , thrust_i , Lambda_i];
disp("Done generating training data")

%% generate random test data

[train_row, train_col] = size(train_dataset);
test_data_len = round(train_row*0.3); % 30% sample of training data

test_dataset = zeros(test_data_len,train_col);

for m=1:1:test_data_len
    inp_v = [randi([3,25]), randi([0,360]), randi([-7 7])];
    
    inp_rpm = ones(4,1)*randi([7000 17000]);
    [T_final,lambda1,lambda2]  = FWF_BEMT(inp_rpm,inp_v, P);
   
    test_dataset(m,:) = [inp_v , inp_rpm(1,1) , T_final,lambda1,lambda2];
    
end
disp("Done generating test data")

%% plot RPM vs thrust

%  rpm = RPM_init:increament:RPM_max;
%  plot(rpm,thrust_i)
% 
% xlabel("RPM")
% ylabel("thrust")

