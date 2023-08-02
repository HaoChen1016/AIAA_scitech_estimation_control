function m=quat_e(q,type)
    if type == 0 %q^-1*e*q
        e_i=[0 0 0;1 0 0;0 1 0;0 0 1];
        m1=quat_multiply(quat_multiply(quat_inv(q),e_i(:,1)),q);
        m2=quat_multiply(quat_multiply(quat_inv(q),e_i(:,2)),q);
        m3=quat_multiply(quat_multiply(quat_inv(q),e_i(:,3)),q);
        m=[m1 m2 m3];
        m=m(2:4,:);
    elseif type == 1 %q*e*q^-1
        e_i=[0 0 0;1 0 0;0 1 0;0 0 1];
        m1=quat_multiply(quat_multiply(q,e_i(:,1)),quat_inv(q));
        m2=quat_multiply(quat_multiply(q,e_i(:,2)),quat_inv(q));
        m3=quat_multiply(quat_multiply(q,e_i(:,3)),quat_inv(q));
        m=[m1 m2 m3];
        m=m(2:4,:);
    elseif type == 2 %e*q
        e_i=[0 0 0;1 0 0;0 1 0;0 0 1];
        m1 = quat_multiply(e_i(:,1),q);
        m2 = quat_multiply(e_i(:,2),q);
        m3 = quat_multiply(e_i(:,3),q);
        m=[m1 m2 m3];
    end
end