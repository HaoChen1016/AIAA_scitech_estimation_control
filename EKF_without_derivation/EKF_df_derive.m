%This is based on NED frame 
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
%% system dynamics
x_dot=v;
v_dot = A_gr + quat_v(q,a,0);
q_dot = (1/2)*quat_multiply(q,[0;w]);
%%derivatives 
df1dx = jacobian(x_dot,x)
df1dv = jacobian(x_dot,v)
df1dq = jacobian(x_dot,q)

df2dx = jacobian(v_dot,x)
df2dv = jacobian(v_dot,v)
df2dq = jacobian(v_dot,q)

df3dx = jacobian(q_dot,x)
df3dv = jacobian(q_dot,v)
df3dq = jacobian(q_dot,q)
