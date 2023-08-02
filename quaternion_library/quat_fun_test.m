q1=[0.966;0;0;0.259]; %ZYX order Z-30
q2=[0.924;0;0.383;0.000]; %ZYX order Y-45
vec_quat_multiply(q1(2:4),q2(2:4))
quatmultiply(q1',q2')'

vec_quat_inv(q1(2:4))
vec_quat_conj(q1(2:4))

e_i=[1 0 0;0 1 0;0 0 1];
m1=vec_quat_multiply(vec_quat_multiply(q1(2:4),e_i(:,1)),vec_quat_inv(q1(2:4)));
m2=vec_quat_multiply(vec_quat_multiply(q1(2:4),e_i(:,2)),vec_quat_inv(q1(2:4)));
m3=vec_quat_multiply(vec_quat_multiply(q1(2:4),e_i(:,3)),vec_quat_inv(q1(2:4)));
m=[m1 m2 m3]

e_i=[0 0 0;1 0 0;0 1 0;0 0 1];
m1=quatmultiply(quatmultiply(q1',e_i(:,1)'),quatinv(q1'))';
m2=quatmultiply(quatmultiply(q1',e_i(:,2)'),quatinv(q1'))';
m3=quatmultiply(quatmultiply(q1',e_i(:,3)'),quatinv(q1'))';
m=[m1 m2 m3]