addpath('..\quaternion_library');
%true states 
syms x1 x2 x3 v1 v2 v3 q0 q1 q2 q3  
x = [x1;x2;x3];assume(x,'real');
v = [v1;v2;v3];assume(v,'real');
q = [q0;q1;q2;q3];assume(q,'real');
%parameters
syms  m g 
A_gr=[0;0;g];
assume(m,'real');
assume(A_gr,'real');
%inputs
syms w1 w2 w3 a1 a2 a3
w=[w1;w2;w3];
a=[a1;a2;a3];
assume(w,'real');
assume(a,'real');
b3=[0;0;1];
%non-additive noise 
syms omega_x1 omega_x2 omega_x3 omega_a1 omega_a2 omega_a3 ...
     omega_w1 omega_w2 omega_w3
omega_x = [omega_x1;omega_x2;omega_x3];
omega_a = [omega_a1;omega_a2;omega_a3];
omega_w = [omega_w1;omega_w2;omega_w3];
assume(omega_x,'real');
assume(omega_a,'real');
assume(omega_w,'real');
%% system dynamics
x_dot=v + omega_x;
v_dot = A_gr + quat_v(q,a+omega_a,0);
q_dot = (1/2)*quat_multiply(q,[0;w+omega_w]);
%derivatives
df1domega_x = jacobian(x_dot,omega_x)
df1domega_a = jacobian(x_dot,omega_a)
df1domega_w = jacobian(x_dot,omega_w)

df2domega_x = jacobian(v_dot,omega_x)
df2domega_a = jacobian(v_dot,omega_a)
df2domega_w = jacobian(v_dot,omega_w)

df3domega_x = jacobian(q_dot,omega_x)
df3domega_a = jacobian(q_dot,omega_a)
df3domega_w = jacobian(q_dot,omega_w)

