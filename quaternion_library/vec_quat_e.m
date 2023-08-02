function m=vec_quat_e(q,type)
    if type == 0 %q^-1*e*q
        e_i=[1 0 0;0 1 0;0 0 1];
        m1=vec_quat_multiply(vec_quat_multiply(vec_quat_inv(q),e_i(:,1)),q);
        m2=vec_quat_multiply(vec_quat_multiply(vec_quat_inv(q),e_i(:,2)),q);
        m3=vec_quat_multiply(vec_quat_multiply(vec_quat_inv(q),e_i(:,3)),q);
        m=[m1 m2 m3];
    elseif type == 1 %q*e*q^-1
        e_i=[1 0 0;0 1 0;0 0 1];
        m1=vec_quat_multiply(vec_quat_multiply(q,e_i(:,1)),vec_quat_inv(q));
        m2=vec_quat_multiply(vec_quat_multiply(q,e_i(:,2)),vec_quat_inv(q));
        m3=vec_quat_multiply(vec_quat_multiply(q,e_i(:,3)),vec_quat_inv(q));
        m=[m1 m2 m3];
    elseif type == 2 %e*q
        e_i=[1 0 0;0 1 0;0 0 1];
        m1 = vec_quat_multiply(e_i(:,1),q);
        m2 = vec_quat_multiply(e_i(:,2),q);
        m3 = vec_quat_multiply(e_i(:,3),q);
        m=[m1 m2 m3];
    end
end