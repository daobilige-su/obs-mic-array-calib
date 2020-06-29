% Compute the error of a pose-pose constraint
% x1 3x1 vector (x,y,theta) of the first robot pose
% x2 3x1 vector (x,y,theta) of the second robot pose
% z 3x1 vector (x,y,theta) of the measurement
%
% You may use the functions v2t() and t2v() to compute
% a Homogeneous matrix out of a (x, y, theta) vector
% for computing the error.
%
% Output
% e 3x1 error of the constraint
% A 3x3 Jacobian wrt x1
% B 3x3 Jacobian wrt x2
function [e, A, B] = linearize_pose_pose_constraint(x1, x2, z)

  % TODO compute the error and the Jacobians of the error
  %e = t2v(inv(v2t(z))*(inv(v2t(x1)))*v2t(x2));
  e = x2-x1 - z;

  %A = [-cos(z(3)+x1(3)) , -sin(z(3)+x1(3)) , -sin(z(3)+x1(3))*(x2(1)-x1(1))+cos(z(3)+x1(3))*(x2(2)-x1(2));
  %     sin(z(3)+x1(3)) , -cos(z(3)+x1(3)) , -cos(z(3)+x1(3))*(x2(1)-x1(1))-sin(z(3)+x1(3))*(x2(2)-x1(2));
  %     0 , 0 , -1];
  A = [-1 0 0;
       0 -1 0;
       0 0 -1];

  %B = [cos(z(3)+x1(3)) , sin(z(3)+x1(3)) , 0;
  %     -sin(z(3)+x1(3)) , cos(z(3)+x1(3)) , 0;
  %     0 , 0 , 1];
  B = [1 0 0;
       0 1 0;
       0 0 1];

end
