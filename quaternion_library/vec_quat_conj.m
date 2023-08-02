function [q_conj] = vec_quat_conj(q)
%vector quaternion conjugate
%Hao Chen
q1=q(1);q2=q(2);q3=q(3);
q_conj=[-q1;-q2;-q3];
end

