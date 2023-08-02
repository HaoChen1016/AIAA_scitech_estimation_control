function vec=quat_v(q,v,type)
    if type == 0 %q*v*q^-1
      q0=q(1);
      qv=q(2:4);
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      vec=R*v;
    elseif type == 1 %q^-1*v*q
      q0=q(1);
      qv=q(2:4);
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      vec=inv(R)*v;
    end
end