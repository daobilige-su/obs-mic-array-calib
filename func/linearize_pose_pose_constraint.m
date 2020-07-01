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
function [e, A, B] = linearize_pose_pose_constraint(x1, x2, z)

  % compute the error and the Jacobians of the error
  e = x2-x1 - z;
  A = [-1 0 0;
       0 -1 0;
       0 0 -1];

  B = [1 0 0;
       0 1 0;
       0 0 1];
end
