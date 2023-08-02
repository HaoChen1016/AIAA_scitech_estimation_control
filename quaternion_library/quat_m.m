function mat=quat_m(q,m,type)
    if type == 0 %q*m*q^-1
      q0=q(1);
      qv=q(2:4);
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      mat=R*m;
    elseif type == 1 %q^-1*m*q
      q0=q(1);
      qv=q(2:4);
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      mat=inv(R)*m;
    end
end