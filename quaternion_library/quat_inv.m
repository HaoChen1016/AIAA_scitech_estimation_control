function [q_inv] = quat_inv(q)
%quaternion inverse
%   HAO
q0=q(1);q1=q(2);q2=q(3);q3=q(4);
q_inv=quat_conj(q)/(q0^2+q1^2+q2^2+q3^2);
end
