% Compute the error of a pose-landmark constraint
% x 3x1 vector (x,y,theta) of the robot pose
% l 2x1 vector (x,y) of the landmark
% z 2x1 vector (x,y) of the measurement, the position of the landmark in
%   the coordinate frame of the robot given by the vector x
%
% Output
% e 2x1 error of the constraint
% A 2x3 Jacobian wrt x
% B 2x2 Jacobian wrt l
function [e, A, B] = linearize_pose_landmark_constraint(x, l, z, toIdx,est_delay_on,est_drift_on,g)

  % compute the error and the Jacobians of the error
   
  % error
  e = zeros(g.M-1,1);
  for n = 1:(g.M-1)
    e(n) = sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)/340 - ...
      sqrt((x(1))^2 + (x(2))^2 + (x(3))^2)/340 + l(5*n+4) + ...
      ((toIdx-5*g.M+2)/3)*l(5*n+5) - z(n);
  end
  
  % computation of A, de/dx1, x1 here is landmark
  A = [];
  A = [A zeros(g.M-1,5)];
  for n = 1:(g.M-1)
    A_struct(n).matrix = [zeros(n-1,5);
                          (1/340)*((1/2)*(1/sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)) *(2*(l(5*n+1)-x(1)))),...
                          (1/340)*((1/2)*(1/sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)) *(2*(l(5*n+2)-x(2)))),...
                          (1/340)*((1/2)*(1/sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)) *(2*(l(5*n+3)-x(3)))),...
                          1,...
                          ((toIdx-5*g.M+2)/3);
                          
                          zeros(g.M-1-n,5)];
    % if no need to estimate drift, the jacobian is 0;
    if est_drift_on<1
        A_struct(n).matrix(n,5) = 0;
    end
    % if no need to estimate delay, the jacobian is 0;
    if est_delay_on<1
        A_struct(n).matrix(n,4) = 0;
    end
    A = [A A_struct(n).matrix];
  end
  
  % computation of B, de/dx2, x2 here is robot pose
  B = [];
  for n = 1:(g.M-1)
    B_struct(n).matrix = [(1/340)*((1/2)*(1/sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)) *(2*(x(1)-l(5*n+1)))) - (1/340)*((1/2)*(1/sqrt(x(1)^2+x(2)^2+x(3)^2)) * (2*x(1))),...
                          (1/340)*((1/2)*(1/sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)) *(2*(x(2)-l(5*n+2)))) - (1/340)*((1/2)*(1/sqrt(x(1)^2+x(2)^2+x(3)^2)) * (2*x(2))),...
                          (1/340)*((1/2)*(1/sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)) *(2*(x(3)-l(5*n+3)))) - (1/340)*((1/2)*(1/sqrt(x(1)^2+x(2)^2+x(3)^2)) * (2*x(3)))];
    B = [B; B_struct(n).matrix];
  end
  
end
