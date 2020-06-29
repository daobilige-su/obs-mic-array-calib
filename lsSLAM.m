% This file performs least square SLAM
% make sure the creat_graph.m has been run before running this file.


%% refresh
more off;
clear all;
close all;

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
EPSILON = 1.5;%1.5/1e-2;

% Error
err = 0;

% add path for including some tool functions
addpath('tools');

% load the graph into the variable "g"
% load ./data/lemma_1_8_mic_line.mat
% load ./data/theorim_1_8_mic_circle.mat
% load ./data/theorim_1_8_mic_square.mat
% load ./data/theorim_1_8_mic_circle_no_vertical.mat
% load ./data/theorim_1_8_mic_circle_no_vertical_same_num.mat
load ./data/exp_full.mat

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

% plot the initial state of the graph
plot_graph(g, 0);

% compute the error for ground truth
gx = g.x;
% g.x = g.x_gt;
disp(['ground truth error ' num2str(compute_global_error(g))]);

% compute initial error for state vector
g.x = gx;
disp(['Initial error ' num2str(compute_global_error(g))]);

% carry out the iterations
for i = 1:numIterations
  disp(['Performing iteration ', num2str(i)]);

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
%       hc = rot_matrix*[g.x(5*(n-1)+1);g.x(5*(n-1)+2);1];
%       g.x(5*(n-1)+1) = hc(1);
%       g.x(5*(n-1)+2) = hc(2);
      g.x(5*(n-1)+1:5*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(5*(n-1)+1:5*(n-1)+3);1];
  end
  % rotate the sound src positions
  for n=1:(size(g.x,1)-5*g.M)/3
%       hc = rot_matrix*[g.x(3*(n-1)+1+5*g.M);g.x(3*(n-1)+2+5*g.M);1];
%       g.x(3*(n-1)+1+5*g.M) = hc(1);
%       g.x(3*(n-1)+2+5*g.M) = hc(2);
      g.x(5*g.M+3*(n-1)+1:5*g.M+3*(n-1)+3) = [eye(3) zeros(3,1)]*M_transform*[g.x(5*g.M+3*(n-1)+1:5*g.M+3*(n-1)+3);1];
  end
      
  % display estimation error of mic delay if asked
  if display_delay_error_on > 0    
      x_3_error = (g.x(9:5:g.M*5-1) - g.x_gt(9:5:g.M*5-1));
      disp('estimation error of starting time delay: ');
      x_3_error'
  end

  % plot the current state of the graph
  plot_graph(g, i);
  %{
  grid on;
  xlim([-0.5 g.mic_dis*(g.M_x-1)+(g.mic_dis/2)]);ylim([-0.5 g.mic_dis*(g.M_y-1)+(g.mic_dis/2)]);
  %}

  % compute current error
  err = compute_global_error(g);

  % Print current error
  disp(['Current error ' num2str(err)]);

  % TODO: implement termination criterion as suggested on the sheet
  % 
  if display_norm_dx_on>0
    disp(['norm(dx) = ' num2str(norm(dx))]);
  end
  
  if (norm(dx)<EPSILON)
    break;
  end


end

% plot the current state of the graph
plot_graph_with_cov(g, i, H);

%saveas(gcf,['../plots/' num2str(i) '.fig']);
%print(gcf,['../plots/' num2str(i) '.png'],'-dpng','-r300');
%print(gcf,['../plots/' num2str(i) '.eps'],'-depsc','-r300');

% show final error
disp(['Final error ' num2str(err)]);



