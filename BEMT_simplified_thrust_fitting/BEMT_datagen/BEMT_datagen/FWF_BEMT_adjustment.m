function [T_final,lambda1,lambda2] = FWF_BEMT_adjustment(rpm_guesses,V_rel_b, P)


% governing equations
% governing equations

% T=T1+T2+T3+T4 ;
% TA1=l*(T4-T2) ;   roll positive right wing down
% TA2=l*(T1-T3) ;   pitch up positive
% TA3=ta1+ta2+ta3+ta4 ;

% it looks like in atitude control output of the functin should be pitch
% down positive
% Not Related with LQR CONTROL ASMA*

%%
% predefining vriables for Codegen

k = P.k;
b = P.b;
l = P.l;
T_final=0;
Tau_initial=zeros(3,1);
Tau_final=zeros(3,1);
T2=zeros(4,1);
pow=zeros(4,1);

TA=zeros(3,1);
TA1=zeros(4,1);
TA2=zeros(4,1);
TA3=zeros(4,1);
ta1=zeros(4,1);
ta2=zeros(4,1);
ta3=zeros(4,1);

RPM2=single(zeros(4,1));
RPM=zeros(4,1);

T = b * rpm_guesses.^2;       % requested thrust from rotor r
Tau = k * rpm_guesses.^2;     % requested torques from rotor r

%%for calculation transforming all information into vector form
% rel_speed = V_info(1);
% heading = deg2rad(V_info(2));
% v_rel_z = V_info(3);
% 
% v_rel_x = rel_speed*cos(heading);
% v_rel_y = rel_speed*sin(heading);
% 
% V_rel_b = [v_rel_x,v_rel_y,v_rel_z];


for i=1:4
    % optimization to find optimum rpm where both momentum annd blade element theories match
    
    subfcn2 = @(rpm) try1(rpm,V_rel_b,T(i));
    
    rpm=golden_search(0,25000,subfcn2); %limits of RPM, checked that the higher limit goes beyond 25000 so chaging from 100 16000
%     rpm=golden_search(0,17000,subfcn2);  %HAO,the argument in here is to keep consistent with BEMT in datagen
    [~,roll,pitch,yaw,~,lambda1]=try1(rpm,V_rel_b,T(i));
    
    % rpm to rad/second
    RPM(i)=rpm ;%*2*pi/60; NO NEED ASMA
    
    % torques of a rotor - rotor 1 is the leading edge rotor,left
    % number 2, right number 4, aft number, 1 and 3 ccw. 2 and 4 cw.
    
    heading=atan(V_rel_b(2)/(V_rel_b(1)+0.000001));
    ta1(i) = roll * cos(heading) * (-1)^(i+1) - pitch * sin(heading);
    ta2(i) = roll * sin(heading) * (-1)^(i+1) + pitch * cos(heading) ;
    % the sign will be taken care of in Matrix M -- no worries!
    ta3(i) = yaw * (+1)^(i+1); %??? ASMA
    
end

Tau_initial=[sum(ta1);sum(ta2);sum(ta3)];

%% new addition to help with yaw moment

% here we need to find a way to change RPMs a bit such that they also
% provide the required Ta3. So, we can find the thrust and torque
% coefficients for a specific time and flight condition.

bb=T./RPM.^2;
kk=ta3./RPM.^2;

M=[bb'; ...
  0,bb(2)*l,0,-bb(4)*l;...
  bb(1)*l,0,-bb(3)*l,0;...
  kk(1),-kk(2),kk(3),-kk(4)];

% M=double([bb'; ...
%   0,-bb(2)*l,0,bb(4)*l;...
%   bb(1)*l,0,-bb(3),0;...
%   kk(1),-kk(2),kk(3),-kk(4)]);  %ASMA

T_tot=sum(T);

% we use the requsted thrust and torque - here we used the actual
% conventions, down pos z, right wing pos y, pointing to nose pos x
TA(1) = l* (T(2)-T(4)) - Tau_initial(1); % roll
TA(2) = l* (T(1)-T(3)) - Tau_initial(2); % pitch
TA(3) = dot([k,-k,k,-k],rpm_guesses.^2'); % yaw



%ASMA
%  TA(1) = l* (T(4)-T(2)) - Tau_initial(1); % roll
% TA(2) = l* (T(1)-T(3)) - Tau_initial(2); % pitch
% TA(3) = dot([-k,k,-k,k],rpm_guesses.^2'); % yaw

u_temp= [T_tot;TA(1);TA(2);TA(3)];
% newly obtained RPMs Original
% RPM2=(M\[T_tot;TA(1);TA(2);TA(3)]).^0.5;

%%ADDED BY ASMA
RPM_SQ = pinv(M)*u_temp;

for i=1:4
    if RPM_SQ(i) < 0
        RPM_SQ(i) = 0;
    end
end

RPM2 = sqrt(RPM_SQ);

% now let's see how much thrust and torque they make

for i=1:4
    % input to propeller code must be RPM not rev/sec
    
    subfcn2 = @(T) try2(T,rpm,V_rel_b);
    
    T=golden_search(0,40,subfcn2);  %THIS IS FOR THURST
    
    [~,roll,pitch,yaw,T,lambda2]=try2(T,rpm_guesses(i),V_rel_b);
    pow(i)=yaw * RPM2(i);
    T2(i)=T;
    heading=atan(V_rel_b(2)/(V_rel_b(1)+0.000001));
    TA1(i) = roll * cos(heading) * (-1)^(i+1) - pitch * sin(heading);
    TA2(i) = roll * sin(heading) * (-1)^(i+1) + pitch * cos(heading) ;
    TA3(i)=yaw* (-1)^(i+1);
end

TA_rotor=[sum(TA1);sum(TA2);sum(TA3)];

% here since we don't use negative thrusts, conventions are changed
T_final=sum(T2);
Tau_final(1,1)=l*(T2(2)-T2(4))+TA_rotor(1) ; % roll
Tau_final(2,1)=l*(T2(1)-T2(3))+ TA_rotor(2) ; % pitch
Tau_final(3,1)=TA_rotor(3) ;

%ASMA
%  Tau_final(1,1)=l*(T2(4)-T2(2))+ TA_rotor(1) ; % roll 

power = sum(pow) ;

U_final=[T_final,Tau_final'];
local_param= [bb , kk];
end

