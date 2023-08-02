%% Quadcopter Trajectory Tracking Simulation in the LES wind field %%
%  Tracking performed by a MCV Controller and IEKF estimates states and
%  wind
% Run main simulation %

clc
clear all
close all
addpath("quaternion_library")
addpath("controller_func_library")
addpath("BEMT_library")

%% Run file the Parameters for the estimator %%
run("param_est")
%% Quadcopter parameters 

% dynamics related
m=1.035 * 4/6;                                      % mass [kg]
l=0.225 ;                                           % arm length [m]
Ix= 0.0469 ;
Iy= 0.0358 ;
Iz=  0.101 * 4/6;
I_B = diag([Ix,Iy,Iz]);
I_r = 3.357e-5;                                      % rotor momemt of inertia (kg x m^2)
g = 9.8;

% aerodynamics related
b =  1.5652e-08;% * (60/(2*pi))^2 ;                  % Thrust coeffcient intially N/(rpm^2), %now N/(rev/s^2)
k =  2.0862e-10;%* (60/(2*pi))^2 ;                   % Torque Coeffcient intially Nm/(rpm^2),% now Nm/(rev/s^2)
D=diag([0.04,0.04,0]);


% input params to model, P
% mean_wind = [2.72 , 1.75, 0.006]; %NED when running all other
mean_wind = [2.72 , 1.75, -0.006]; %NEU when running constant wind
P.m= m;                      
P.l= l ;                           
P.Ix= Ix ;
P.Iy= Iy ;P.Iz=  Iz;
P.I_B = diag([Ix,Iy,Iz]);
P.I_r = I_r;        
P.b =  b;                                           % Thrust coeffcient  N/(rpm^2)
P.k =  k;                                           % Torque Coeffcient  Nm/(rpm^2)
P.g = g;
P.D = D;
P.mean_wind = mean_wind;


% blade params
R=3*0.0254;                                          % propeller radius  [m]
nb=2;                                                % number of blade
A=pi*R^2;                                            % disk area
rho = 1.15;
nr = 20;                                             % number of radial points on a blade
npsi = 60;                                           % number of azimuthal points for 2*Pi  ROTOR PLANE
P.rho = rho;  %air density(kg/m^3)

%%
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

% global geometry
geometry = Simulink.Signal;
geometry .DataType = 'double';
geometry .Dimensions = [length(list) npsi];
geometry .Complexity = 'real';
geometry .SamplingMode = 'Sample based';
geometry .InitialValue = 'geometry2';

%% forward flight only
% load("traj_nom_long.mat")
% load("new_traj_pts.mat")
% load("traj_nom_long4.mat")         %works in closed loop, this is with relative velocity information(MCV)
load("traj_nom_long4_new.mat")     %works in closed loop, this is without relative velocity information(LQR)

% load("traj_nom_long3.mat") %use this one to tune the estimator
% traj_nom  = traj_pts(1:10000,:);

% load("hovering_traj.mat") %use this one to tune the estimator
% traj_nom  = traj_pts(1:10000,:);

P.nomTraj = traj_nom;

plot3(traj_nom(:,2),traj_nom(:,3),-traj_nom(:,4),'r','linewidth',2);
title('quadcopter trajectory');
xlabel('x(m)');ylabel('y(m)');zlabel('z(m)');
% xlim([0 210]);ylim([0 210]);zlim([-5 20]);

%calibration time
P.tcal = 8; 


%% load wind
% Aug 20 2021 Wind is just at point 8 m TODO: Spatial temporal wind add

%in case you want the extracted wind

load("LES_wind.mat")  
load("LES_wind_8m.mat")

% Oct 7, added spatial temporal wind
% load('40x40x40_1sec_3d.mat') %this line can be commented out if the data is loaded once

P.res=[10 10 10];

% Not Using all the data because dataset is huge and interpolation takes
% a lot of time so only loading for the timeframe
time_start = 1;
time_length = 100;%T(end) ; %length(t_nom) length of nominal trajectory plus 1 cause time starts at zero in trajectory
time_end = time_start + time_length;


common_start =1; % this is the start of trajectory typically [0,0,0]
%common_end = 12; % this is the grid idx  taking 12*12*12 grid this is enough for small range trajectory

% Or find the max point each trajectory can reach so that each time
% interpolation doesnot have to create whole grid within calculation
% 


x_end_p = max(traj_nom(:,2));  
y_end_p = max(traj_nom(:,3));
z_end_p = max(traj_nom(:,4));

extra_grid = 2;
x_end_idx = round(x_end_p/P.res(3))+extra_grid;
y_end_idx = round(y_end_p/P.res(2))+extra_grid;
z_end_idx = round(z_end_p/P.res(1))+extra_grid;


%format is [t,z,y,x];
% % v1 = v( time_start:time_end,     z_start:z_end,      y_start:y_end,      x_start:x_end);
% u1 = u( time_start:time_end,     common_start:z_end_idx,      common_start:y_end_idx,      common_start:x_end_idx);
% v1 = v( time_start:time_end,     common_start:z_end_idx,      common_start:y_end_idx,      common_start:x_end_idx);
% w1 = w( time_start:time_end,     common_start:z_end_idx,      common_start:y_end_idx,      common_start:x_end_idx);
%% Controller params %%

% load nominal trajectory and initial states
x0=[0,0,0,1,0,0,0,-P.mean_wind,0,0,0]; %intial state
xref = [1,1,-8,1,0,0,0,-P.mean_wind];
fc0=g*m;
% uref=[0,0,2,10]; %initial wz is required;[wx,wy,wz,fc]
uref=[0;0;0.5;10]; %initial wz is required [wx wy wz fc];
P.uref = uref;
%gains
Q=diag([10,10,15,1,1,1,1,0.1,0.1,0.1]);

F =  diag([12,12,12,.1,.1,.1,.1,0.1,0.1,0.1]);  % Terminal cost on state 
Rg=diag([5,5,1,0.1]); %MCV %last one is force [wx,wy,wz,fc]
% Rg=diag([1,5,5,.1]);  %LQR
G=zeros(10,3);
G(1,1)=  0.5434 ; G(2,2)= 0.4197;G(3,3)=0.1236; %noise covariance from wind data
W=eye(3,3);
gama=0.75;

P.Q= Q;
P.R =Rg;
P.G = G;
P.W= W;
P.gama = gama;
P.F = F;

% 10/25/2021 add weights for thrust NN trained model
% load('weights_v0.mat');
% P.n_lay_neu = [10;5;1]; %neurons for each hidden layers
% P.weights = weights;

% load('weights_v1.mat');
% P.n_lay_neu = [10;10;10;1]; %neurons for each hidden layers
% P.weights = weights1;

load('weights_v2.mat');
P.n_lay_neu = [10;5;1]; %neurons for each hidden layers
P.weights = weights;
%% run the model
tic

sim('Quadcopter_v5_1_full.slx')

toc
%% Prepare the data %% 
% 
% t=ans.tout; t=t(1:10:length(t));
% state= ans.states;
% pos=state(:,1:3);vel=state(:,8:10);quat_angle=state(:,4:7); omega = state(:,11:13);
% rel_vb = ans.v_rel_b;rel_vb = rel_vb(1:10:end,:);
% %%
% controller_torque = ans.control_force_torque; 
% controller_RPM = ans.rotor_RPM; 
% bemt_torque = ans.control_force_adjusted;
% bemt_RPM = ans.rotor_RPM_adjusted; 
% bemt_RPM =bemt_RPM(1:10:end,:);
% bemt_torque =bemt_torque(1:10:end,:);
% local_param =ans.local_param;local_param = local_param(1:4:end,:);
% local_param = local_param(1:10:end,:);

%%
% figure()
% plot(t,controller_torque(:,1))
% hold on
% plot(t, bemt_torque(:,1))
% xlabel("time, [s]")
% ylabel("Cumulative thrust, [N]")
% grid on
% legend("Controller", "BMET")
% 
%% save the data
% data_lqr_con_open_bemt_sep9 = [t , state , controller_torque ,  controller_RPM, bemt_torque ,bemt_RPM , local_param, rel_vb];
% 
% save("data_lqr_con_open_bemt_sep9.mat","data_lqr_con_open_bemt_sep9")

% 
% 
%%
% figure()
% plot(t,controller_torque(:,1))
% hold on
% grid on
% plot(t,bemt_torque(:,1))
% xlabel("time [s]")
% ylabel("thrust ")
% legend("Controller zero","BEMT zero")
% title("Thrust comparision")
% 
% figure()
% plot(t,controller_torque(:,2))
% hold on
% grid on
% plot(t,bemt_torque(:,2))
% xlabel("time [s]")
% ylabel("x ")
% legend("Controller zero","BEMT zero")
% title("torque comparision")
% 
% figure()
% plot(t,controller_torque(:,3))
% hold on
% grid on
% plot(t,bemt_torque(:,3))
% xlabel("time [s]")
% ylabel("y ")
% legend("Controller zero","BEMT zero")
% title("torque comparision")
% 
% figure()
% plot(t,controller_torque(:,4))
% hold on
% grid on
% plot(t,bemt_torque(:,4))
% xlabel("time [s]")
% ylabel("z ")
% legend("Controller zero","BEMT zero")
% title("Torque comparision")