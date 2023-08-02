function [q_conj] = quat_conj(q)
%quaternion conjugate
%   HAO
q0=q(1);q1=q(2);q2=q(3);q3=q(4);
q_conj=[q0;-q1;-q2;-q3];
end

