function vec=vec_quat_v(q,v,type)
    if type == 0 %q*v*q^-1
      q1=q(1);q2=q(2);q3=q(3);
      q0=sqrt(1-(q1^2+q2^2+q3^2));
      qv=q;
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      vec=R*v;
    elseif type == 1 %q^-1*v*q
      q1=q(1);q2=q(2);q3=q(3);
      q0=sqrt(1-(q1^2+q2^2+q3^2));
      qv=q;
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      vec=inv(R)*v;
    end
end