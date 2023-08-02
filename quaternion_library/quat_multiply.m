function [pq] = quat_multiply(p,q)
%quaternion multiplycation
%   HAO 
p0=p(1);p1=p(2);p2=p(3);p3=p(4);
q0=q(1);q1=q(2);q2=q(3);q3=q(4);
pq=[p0*q0-p1*q1-p2*q2-p3*q3;
    p0*q1+q0*p1+p2*q3-p3*q2;
    p0*q2+q0*p2+p3*q1-p1*q3;
    p0*q3+q0*p3+p1*q2-p2*q1;];
end

