%% Parameters for simulated sensors block
%gyro and accel sample time
P.Ts_gy_ac=0.01;

% %mag sample time
% P.Ts_mag=0.01;
%% GPS
    %gps sample time
    P.Ts_gps=1;
    %only noise
    P.bias_gps_x = 0;
    P.bias_gps_y = 0;
    P.bias_gps_z = 0;
    P.sigma_gps = 1;
    %differential GPS/RTK GPS
%     P.bias_gps_x = 0;
%     P.bias_gps_y = 0;
%     P.bias_gps_z = 0;
%     P.sigma_gps = 0.01;
%% gyro and accel
    %gyro
    %noise and bias
%     P.bias_gyro_x = 0;
%     P.bias_gyro_y = 0;
%     P.bias_gyro_z = 0;
%     P.sigma_gyro = 0.25;
    %noise and bias 
%     P.bias_gyro_x = 0.1*pi/180*rand;
%     P.bias_gyro_y = 0.1*pi/180*rand;
%     P.bias_gyro_z = 0.1*pi/180*rand;
%     P.sigma_gyro = 0.13*pi/180; % standard deviation of gyros in rad/sec;
    %only noise 
    P.bias_gyro_x = 0;
    P.bias_gyro_y = 0;
    P.bias_gyro_z = 0;
    P.sigma_gyro = 0.13*pi/180; % standard deviation of gyros in rad/sec;
    %no noise and bias
%     P.bias_gyro_x = 0;
%     P.bias_gyro_y = 0;
%     P.bias_gyro_z = 0;
%     P.sigma_gyro = 0;
    
    %accel
    %noise and bias
%     P.bias_accel_x=0;
%     P.bias_accel_y=0;
%     P.bias_accel_z=0;
%     P.sigma_accel = 1;
%     P.bias_accel_x=0.001*9.8*rand;
%     P.bias_accel_y=0.001*9.8*rand;
%     P.bias_accel_z=0.001*9.8*rand;
%     P.sigma_accel = 0.0025*9.8;
    %only noise 
    P.bias_accel_x=0;
    P.bias_accel_y=0;
    P.bias_accel_z=0;
    P.sigma_accel = 0.0025*9.8; % standard deviation of accelerometers in m/s^2
    %no noise and bias
    % P.bias_accel_x=0;
    % P.bias_accel_y=0;
    % P.bias_accel_z=0;
    % P.sigma_accel =0;
    
    %Mag
    %noise and bias  
%     P.bias_B_x = 0;
%     P.bias_B_y = 0;
%     P.bias_B_z = 0;
%     P.sigma_B = 0.1;
    % only noise 
%     P.bias_B_x = 0;
%     P.bias_B_y =0;
%     P.bias_B_z = 0;
%     P.sigma_B = 0.01;
    %no noise and bias
    % P.bias_B_x = 0;
    % P.bias_B_y =0;
    % P.bias_B_z = 0;
    % P.sigma_B = 0;
%     P.B_i = [1/sqrt(2);0;1/sqrt(2)];
%     P.bias_B_x = 20;
%     P.bias_B_y = 120;
%     P.bias_B_z = 90;
    P.bias_B_x = 0;
    P.bias_B_y = 0;
    P.bias_B_z = 0;
    P.sigma_B  = 1;
    P.B_i = [200;-40;480];
    
%% parameters for EKF
g = 9.8;
Q_option = 0; %0-constant wind; 1-LES wind 8m;2-LES wind 50m   
if Q_option == 0 
    % constant wind
    q1=10^-6;q2=10^-6;q3=10^-6;
    q4=0.0023;q5=0.0023;q6=0.0023;
    q7=10^-6;
    q8=10^-6;q9=10^-6;q10=10^-6;
    P.Q_est = diag([q1^2;q2^2;q3^2;q4^2;q5^2;q6^2;q7^2;q8^2;q9^2;q10^2;]);
elseif Q_option == 1 
    % LES wind 8m
    q1=10^-6;q2=10^-6;q3=10^-6;
    q4=0.0023;q5=0.0023;q6=0.0023;
    q7=10^-6;q8=0;q9=0;q10=0;
    Q_L8=[0.2820,0.0976,-0.0429;
          0.0976,0.1679,-0.0233;
         -0.0429,-0.0233,0.0269;];
    Q_L8=Q_L8./100;
    Q_est = diag([q1^2;q2^2;q3^2;q4^2;q5^2;q6^2;q7^2;q8^2;q9^2;q10^2;]);
    Q_est(8:10,8:10) = Q_L8;
%     q1=10^-6;q2=10^-6;q3=10^-6;q4=0.0023;q5=0.0023;q6=0.0023;
%     q7=10^-6;q8=0.01;q9=0.01;q10=0.01;
    P.Q_est = diag([q1^2;q2^2;q3^2;q4^2;q5^2;q6^2;q7^2;q8^2;q9^2;q10^2;]);
elseif Q_option == 2
    %  LES wind 50m
    % q1=10^-6;q2=10^-6;q3=10^-6;q4=0.0023;q5=0.0023;q6=0.0023;
    % q7=10^-6;q8=0;q9=0;q10=0;
    % Q_L50=[11.4169,4.5534,-2.2120;
    %        4.5534,3.8505,-0.9450;
    %       -2.2120,-0.9450,1.4116;];
    % Q_L50=Q_L50./100;
    % Q = diag([q1^2;q2^2;q3^2;q4^2;q5^2;q6^2;q7^2;q8^2;q9^2;q10^2;]);
    % Q(8:10,8:10) = Q_L50
    q1=10^-6;q2=10^-6;q3=10^-6;
    q4=0.0023;q5=0.0023;q6=0.0023;
    q7=10^-6;
    q8=0.1;q9=0.1;q10=0.1;
    P.Q_est = diag([q1^2;q2^2;q3^2;q4^2;q5^2;q6^2;q7^2;q8^2;q9^2;q10^2;]);
end
%R
r1=1;r2=1;r3=1;
r4=0.0025*9.8;r5=0.0025*9.8;r6=0.0025*9.8;
r7=1;r8=1;r9=1;
P.R_est=diag([r1^2;r2^2;r3^2;r4^2;r5^2;r6^2;r7^2;r8^2;r9^2]);
%X0   
mean_wind = [2.72 , 1.75, .006]; %NED 
P.X0_hat = [0;0;0;-mean_wind';1;0;0;0;mean_wind'];
% P.X0_hat = [0;0;0;0;0;0;1;0;0;0;0;0;0];
%P0
p1=1;p2=1;p3=1;
p4=1;p5=1;p6=1;
p7=0;p8=0.004;p9=0.005;p10=0.044;
p11=1;p12=1;p13=0.1;
P.EKF_P0=diag([p1^2;p2^2;p3^2;p4^2;p5^2;p6^2;p7^2;p8^2;p9^2;p10^2;p11^2;p12^2;p13^2;]);

ip1=1;ip2=1;ip3=1;
ip4=1;ip5=1;ip6=1;
ip7=0.004;ip8=0.005;ip9=0.044;
ip10=1;ip11=1;ip12=0.1;
P.IEKF_P0 = diag([ip1^2;ip2^2;ip3^2;ip4^2;ip5^2;ip6^2;ip7^2;ip8^2;ip9^2;ip10^2;ip11^2;ip12^2;]);
%% parameters for EKF(without_wind) 
%Q process noise covariance matrix
q1=10^-6;q2=10^-6;q3=10^-6;
q4=0.0025*g;q5=0.0025*g;q6=0.0025*g; %STD of accel
q7=0.0023;q8=0.0023;q9=0.0023;       %STD of gyro
P.Q_est1 = diag([q1^2;q2^2;q3^2;q4^2;q5^2;q6^2;q7^2;q8^2;q9^2;]);
%R measurement noise covariance matrix
r1=1;r2=1;r3=1; %STD of gps                   
r4=1;r5=1;r6=1; %STD of magnetometer
P.R_est1=diag([r1^2;r2^2;r3^2;r4^2;r5^2;r6^2;]);
%X0 inital states
P.X01_hat = [0;0;0;0;0;0;1;0;0;0;];
%P0 states error covariance matrix
p1=1;p2=1;p3=1;p4=1;p5=1;p6=1;
p7=0;p8=0.004;p9=0.005;p10=0.044;
P.EKF1_P0=diag([p1^2;p2^2;p3^2;p4^2;p5^2;p6^2;p7^2;p8^2;p9^2;p10^2;]);