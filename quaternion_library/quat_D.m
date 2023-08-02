function new_D=quat_D(q,D)
      q0=q(1);
      qv=q(2:4);
      R=eye(3)+2*q0*hat(qv)+2*hat(qv)*hat(qv);
      new_D=R*D*R';
end