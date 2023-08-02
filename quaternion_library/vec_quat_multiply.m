function [r] = vec_quat_multiply(p,q)
%vector quaternion multiplycation
%   Hao Chen 
p1=p(1);p2=p(2);p3=p(3);
q1=q(1);q2=q(2);q3=q(3);

p0=sqrt(1-(p1^2+p2^2+p3^2));
q0=sqrt(1-(q1^2+q2^2+q3^2));

r=[p0*q0-p1*q1-p2*q2-p3*q3;
   p0*q1+q0*p1+p2*q3-p3*q2;
   p0*q2+q0*p2+p3*q1-p1*q3;
   p0*q3+q0*p3+p1*q2-p2*q1;];

r0=r(1)/norm(r);
r1=r(2)/norm(r);
r2=r(3)/norm(r);
r3=r(4)/norm(r);

r=[real(r1);real(r2);real(r3)];
end

