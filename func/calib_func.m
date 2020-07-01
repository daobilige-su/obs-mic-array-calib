function calib_func(input)
% This file performs least square SLAM

%% parameters

% gonna estimate clock drift?
est_drift_on = 1;
% gonna estimate starting time delay?
est_delay_on = 1;
% display starting time delay estimation error?
display_delay_error_on = 0;
% display norm(dx) for each iteration?
display_norm_dx_on = 0;

% the maximum number of iterations
numIterations = 50;

% maximum allowed dx
EPSILON = input.eps;%1.5/1e-2;

% Error
err = 0;

% load the graph into the variable "g"
load(input.graph_file);

% if est_drift_on is not enabled, assign the ground truth values
if est_drift_on<1
    for n = 2:g.M
        g.x(5*(n-1)+5) = g.x_gt(5*(n-1)+5);
    end
end

% if est_delay_on is not enabled, assign the ground truth values
if est_delay_on<1
    for n = 2:g.M
        g.x(5*(n-1)+4) = g.x_gt(5*(n-1)+4);
    end
end

%% start slSLAM

% carry out the iterations
for i = 1:numIterations
%   disp(['Performing iteration ', num2str(i)]);

  % solve the dx
  [dx,H] = linearize_and_solve_with_H(g,est_delay_on,est_drift_on);

  % TODO: apply the solution to the state vector g.x
  g.x = g.x + dx;
  
  % compute the rotation matrix
  rot_yaw = -atan2(g.x((g.M_x-1)*5+2),g.x((g.M_x-1)*5+1));
  rot_pitch = atan2(g.x((g.M_x-1)*5+3),sqrt(g.x((g.M_x-1)*5+1)^2+g.x((g.M_x-1)*5+2)^2));
  M_half = transform_matrix_from_trans_ypr(0,0,0,rot_yaw,rot_pitch,0);
  M_y_p_hom = M_half*[g.x((g.M_y-1)*(g.M_x)*5+1:(g.M_y-1)*(g.M_x)*5+3);1];
  rot_roll = -atan2(M_y_p_hom(3),M_y_p_hom(2));
  M_transform = transform_matrix_from_trans_ypr(0,0,0,rot_yaw,rot_pitch,rot_roll);
  % rotate the mic positions
  for n=2:g.M
      g.x(5*(n-1)+1:5*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(5*(n-1)+1:5*(n-1)+3);1];
  end
  % rotate the sound src positions
  for n=1:(size(g.x,1)-5*g.M)/3
      g.x(5*g.M+3*(n-1)+1:5*g.M+3*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(5*g.M+3*(n-1)+1:5*g.M+3*(n-1)+3);1];
  end
      
  % display estimation error of mic delay if asked
  if display_delay_error_on > 0    
      x_3_error = (g.x(9:5:g.M*5-1) - g.x_gt(9:5:g.M*5-1));
      disp('estimation error of starting time delay: ');
      x_3_error'
  end

  % compute current error
  err = compute_global_error(g);

  % TODO: implement termination criterion as suggested on the sheet
  if display_norm_dx_on>0
    disp(['norm(dx) = ' num2str(norm(dx))]);
  end
  
  if (norm(dx)<EPSILON)
    break;
  end


end

% plot the current state of the graph
figure;
plot_graph_with_cov(g, i, H);
title(input.fig.title);
view(input.fig.view_a, input.fig.view_e);

end

