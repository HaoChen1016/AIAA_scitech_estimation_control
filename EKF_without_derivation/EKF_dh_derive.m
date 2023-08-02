% This is in the NED frame
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
%measurements
syms B_i1 B_i2 B_i3 
B_i=[B_i1;B_i2;B_i3];
assume(B_i,'real');
b_3 = [0;0;1];
%inputs
syms w1 w2 w3 a1 a2 a3 
w=[w1;w2;w3];
a=[a1;a2;a3];
assume(a,'real');
assume(w,'real');
%% measurement equation 
x;
B_b = quat_v(q,B_i,1);
%%
dh1dx = jacobian(x,x)
dh1dv = jacobian(x,v)
dh1dq = jacobian(x,q)

dh2dx = jacobian(B_b,x)
dh2dv = jacobian(B_b,v)
dh2dq = jacobian(B_b,q)