q1=[0.966;0;0;0.259]; %ZYX order Z-30
q2=[0.924;0;0.383;0.000]; %ZYX order Y-45
q3=[0.866;0.500;0.000;0.000]; %ZYX order X-60
q4=[0.822;0.360;0.440;0.022]; %ZYX order Z-30-Y-45-X-60
vec_quat_multiply(q1(2:4),q2(2:4))
quatmultiply(q1',q2')'

vec_quat_inv(q1(2:4))
vec_quat_conj(q1(2:4))

vec_quat_e(q4(2:4),2)
quat_e(q4,2)

% e_i=[1 0 0;0 1 0;0 0 1];
% m1=vec_quat_multiply(vec_quat_multiply(q1(2:4),e_i(:,1)),vec_quat_inv(q1(2:4)));
% m2=vec_quat_multiply(vec_quat_multiply(q1(2:4),e_i(:,2)),vec_quat_inv(q1(2:4)));
% m3=vec_quat_multiply(vec_quat_multiply(q1(2:4),e_i(:,3)),vec_quat_inv(q1(2:4)));
% m=[m1 m2 m3]
% 
% e_i=[0 0 0;1 0 0;0 1 0;0 0 1];
% m1=quatmultiply(quatmultiply(q1',e_i(:,1)'),quatinv(q1'))';
% m2=quatmultiply(quatmultiply(q1',e_i(:,2)'),quatinv(q1'))';
% m3=quatmultiply(quatmultiply(q1',e_i(:,3)'),quatinv(q1'))';
% m=[m1 m2 m3]