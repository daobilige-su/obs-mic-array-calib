% plot a 2D SLAM graph
function plot_graph_with_cov(g, iteration, H)

if nargin<2
iteration = -1;
end

clf;
hold on;
plot3(nan, nan, nan, 'LineStyle','none','Marker','s', 'MarkerSize', 4,'MarkerEdgeColor','g', 'LineWidth',2);
plot3(nan, nan, nan, 'Color','g');
plot3(nan, nan, nan, 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','r', 'LineWidth',2);
plot3(nan, nan, nan, 'LineStyle','none','Marker','s', 'MarkerSize', 4,'MarkerEdgeColor','c');
plot3(nan, nan, nan, 'LineStyle','none','Marker','x', 'MarkerSize', 4,'MarkerEdgeColor','b');


legend('Mic. pos. est.','Sigma region of mic. pos. est.','Mic. pos. g. t.','Sound source est.', 'Sound source g. t.');

[p, l] = get_poses_landmarks(g);

if (length(l) > 0)
  landmarkIdxX = l+1;
  landmarkIdxY = l+2;
  landmarkIdxZ = l+3;
  plot3(g.x(landmarkIdxX), g.x(landmarkIdxY), g.x(landmarkIdxZ), 'LineStyle','none','Marker','s', 'MarkerSize', 4,'MarkerEdgeColor','g', 'LineWidth',2);
  plot3(g.x_gt(landmarkIdxX), g.x_gt(landmarkIdxY), g.x_gt(landmarkIdxZ), 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','r', 'LineWidth',2);
end

if (length(p) > 0)
  pIdxX = p+1;
  pIdxY = p+2;
  pIdxZ = p+3;
%   plot3(g.x(pIdxX), g.x(pIdxY), g.x(pIdxZ), 'LineStyle','-','Marker','x', 'MarkerSize', 4,'MarkerEdgeColor','b');
%   plot3(g.x_gt(pIdxX), g.x_gt(pIdxY), g.x_gt(pIdxZ), 'LineStyle','none','Marker','s', 'MarkerSize', 4,'MarkerEdgeColor','c');
  plot3(g.x(pIdxX), g.x(pIdxY), g.x(pIdxZ), 'LineStyle','none','Marker','s', 'MarkerSize', 4,'MarkerEdgeColor','c');
  plot3(g.x_gt(pIdxX), g.x_gt(pIdxY), g.x_gt(pIdxZ),'Color','b', 'LineStyle','-','Marker','x', 'MarkerSize', 4,'MarkerEdgeColor','b');
end

% draw line segments???
if 0
  poseEdgesP1 = [];
  poseEdgesP2 = [];
  landmarkEdgesP1 = [];
  landmarkEdgesP2 = [];
  for eid = 1:length(g.edges)
    edge = g.edges(eid);
    if (strcmp(edge.type, 'P') ~= 0)
      poseEdgesP1 = [poseEdgesP1, g.x(edge.fromIdx:edge.fromIdx+1)];
      poseEdgesP2 = [poseEdgesP2, g.x(edge.toIdx:edge.toIdx+1)];
    elseif (strcmp(edge.type, 'L') ~= 0)
      landmarkEdgesP1 = [landmarkEdgesP1, g.x(edge.fromIdx:edge.fromIdx+1)];
      landmarkEdgesP2 = [landmarkEdgesP2, g.x(edge.toIdx:edge.toIdx+1)];
    end
  end
  
  linespointx = [poseEdgesP1(1,:); poseEdgesP2(1,:)];
  linespointy = [poseEdgesP1(2,:); poseEdgesP2(2,:)];

  plot(linespointx, linespointy, 'r');
end

%plot(poseEdgesP1(1,:), poseEdgesP1(2,:), "r");

%if (columns(poseEdgesP1) > 0)
%end
%if (columns(landmarkEdges) > 0)
%end

if iteration>1

    P = inv(H);

    for m=2:g.M%g.M_z*g.M_y*g.M_x
        mic_m = g.x(5*(m-1)+1:5*(m-1)+3);
        mic_C = full(P(5*(m-1)+1:5*(m-1)+3,5*(m-1)+1:5*(m-1)+3));
        
        if m==g.M_x
            mic_C(2,2) = 0;
            mic_C(2,1) = 0;
            mic_C(1,2) = 0;
            
            mic_C(3,3) = 0;
            mic_C(3,1:2) = zeros(1,2);
            mic_C(1:2,3) = zeros(2,1);
        end
        
        if m==g.M_x*(g.M_y-1)+1
            mic_C(3,3) = 0;
            mic_C(3,1:2) = zeros(1,2);
            mic_C(1:2,3) = zeros(2,1);
        end
        
        %mic_fig_h = plot_gaussian_ellipsoid(mic_m, mic_C,1,5);
        %set(mic_fig_h,'edgecolor','r');
        
        % mic_fig_h = error_ellipse(mic_C,mic_m);
        
        drawprobellipse_3d(mic_m,mic_C,0.683,'g'); % 0.683 0.954 0.997
        
    end
end

grid on;
view(30,15);
%xlim([-(g.mic_dis/2) g.mic_dis*(g.M_x-1)+(g.mic_dis/2)]);ylim([-(g.mic_dis/2) g.mic_dis*(g.M_y-1)+(g.mic_dis/2)]);

hold off;

%figure(1, 'visible', 'on');
figure(1);
grid on; axis equal;
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
legend('Mic. pos. est.','Sigma region of mic. pos. est.','Mic. pos. g. t.','Sound source est.', 'Sound source g. t.');
drawnow;
%pause(0.1);


% if (iteration >= 0)
%   filename = ['../plots/lsslam_' num2str(iteration) '.png'];
%   print(filename, '-dpng');
% end

% gt
mic_gt = [g.x_gt(1:5:(5*(g.M-1)+1)) g.x_gt(2:5:(5*(g.M-1)+2)) g.x_gt(3:5:(5*(g.M-1)+3)) g.x_gt(4:5:(5*(g.M-1)+4)) g.x_gt(5:5:(5*(g.M-1)+5))];
mic_est = [g.x(1:5:(5*(g.M-1)+1)) g.x(2:5:(5*(g.M-1)+2)) g.x(3:5:(5*(g.M-1)+3)) g.x(4:5:(5*(g.M-1)+4)) g.x(5:5:(5*(g.M-1)+5))];
mic_est_std = zeros(g.M,2);
for n=2:g.M
    mic_est_std(n,:) = sqrt([full(P(5*(n-1)+4,5*(n-1)+4)) full(P(5*(n-1)+5,5*(n-1)+5))]);
end
src_gt = [g.x_gt((5*g.M+1):3:end) g.x_gt((5*g.M+2):3:end) g.x_gt((5*g.M+3):3:end)];
src_est = [g.x((5*g.M+1):3:end) g.x((5*g.M+2):3:end) g.x((5*g.M+3):3:end)]; %[g.x((4*g.M+1):2:end) g.x((4*g.M+2):2:end)];

% gcf;
% hold on;
% plot(mic_gt(:,1),mic_gt(:,2),'LineStyle','none','Marker','s','MarkerEdgeColor','g');
% plot(src_gt(:,1),src_gt(:,2),'LineStyle','none','Marker','s','MarkerEdgeColor','c');
% legend('est. mic. pos.','est. src. pos.','g.t. of mic. pos.','g.t. of src. pos.');

figure(2),
clf;
hold on;
errorbar(mic_est(:,4),mic_est_std(:,1),'LineStyle','none','Marker','s','MarkerEdgeColor','b');
plot(mic_gt(:,4),'LineStyle','none','Marker','o','MarkerEdgeColor','r');
hold off;
grid on;
xlabel('Mic. ID');ylabel('Starting time offset (s)');
legend('Estimation with sigma region','Ground truth');

figure(3),
clf;
hold on;
errorbar(mic_est(:,5),mic_est_std(:,2),'LineStyle','none','Marker','s','MarkerEdgeColor','b');
plot(mic_gt(:,5),'LineStyle','none','Marker','o','MarkerEdgeColor','r');
hold off;
grid on;
xlabel('Mic. ID');ylabel('Clock difference (s)');
legend('Estimation with sigma region','Ground truth');

mic_pos_e = sqrt((mic_gt(:,1)-mic_est(:,1)).^2 + (mic_gt(:,2)-mic_est(:,2)).^2 + (mic_gt(:,3)-mic_est(:,3)).^2);
mic_pos_e_rms = rms(mic_pos_e);
disp(['Final RMS Error of Mic. Pos. is: ' num2str(mic_pos_e_rms)]);
ss_pos_e = sqrt((src_gt(:,1)-src_est(:,1)).^2 + (src_gt(:,2)-src_est(:,2)).^2 + (src_gt(:,3)-src_est(:,3)).^2);
ss_pos_e_rms = rms(ss_pos_e);
disp(['Final RMS Error of SS. Pos. is: ' num2str(ss_pos_e_rms)]);
mic_start_t_e = mic_gt(:,4)-mic_est(:,4);
mic_start_t_e_rms = rms(mic_start_t_e);
disp(['Final RMS Error of Starting Time Diff. is: ' num2str(mic_start_t_e_rms)]);
mic_clock_diff_e = mic_gt(:,5)-mic_est(:,5);
mic_clock_diff_e_rms = rms(mic_clock_diff_e);
disp(['Final RMS Error of Clock Diff. is: ' num2str(mic_clock_diff_e_rms)]);

end
