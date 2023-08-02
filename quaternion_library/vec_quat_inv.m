function [q_inv] = vec_quat_inv(q)
%vector quaternion inverse
%Hao Chen
q1=q(1);q2=q(2);q3=q(3);
q_inv=[-q1;-q2;-q3];
end
