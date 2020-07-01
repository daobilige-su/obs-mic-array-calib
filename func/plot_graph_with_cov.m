% plot a 3D SLAM graph
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
        
        drawprobellipse_3d(mic_m,mic_C,0.683,'g'); % 0.683 0.954 0.997
        
    end
end

grid on;
view(30,15);
hold off;

gcf;
grid on; axis equal;
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
legend('Mic. pos. est.','Sigma region of mic. pos. est.','Mic. pos. g. t.','Sound source est.', 'Sound source g. t.');
drawnow;

end
