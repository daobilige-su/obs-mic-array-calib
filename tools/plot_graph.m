% plot a 2D SLAM graph
function plot_graph(g, iteration)

if nargin<2
iteration = -1;
end

clf;
hold on;
plot3(nan, nan, nan, 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','r', 'LineWidth',2);
plot3(nan, nan, nan, 'LineStyle','none','Marker','x', 'MarkerSize', 4,'MarkerEdgeColor','b');
legend('Mic. pos. est.','Sound source est.');
xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');

[p, l] = get_poses_landmarks(g);

if (length(l) > 0)
  landmarkIdxX = l+1;
  landmarkIdxY = l+2;
  landmarkIdxZ = l+3;
  plot3(g.x(landmarkIdxX), g.x(landmarkIdxY), g.x(landmarkIdxZ), 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','r', 'LineWidth',2);
end

if (length(p) > 0)
  pIdxX = p+1;
  pIdxY = p+2;
  pIdxZ = p+3;
  plot3(g.x(pIdxX), g.x(pIdxY), g.x(pIdxZ), 'LineStyle','none','Marker','x', 'MarkerSize', 4,'MarkerEdgeColor','b');
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

grid on;
view(30,15);
%xlim([-(g.mic_dis/2) g.mic_dis*(g.M_x-1)+(g.mic_dis/2)]);ylim([-(g.mic_dis/2) g.mic_dis*(g.M_y-1)+(g.mic_dis/2)]);

hold off;

%figure(1, 'visible', 'on');
figure(1);
grid on; axis equal;
legend('Mic. pos. est.','Sound source est.');
drawnow;
%pause(0.1);


% if (iteration >= 0)
%   filename = ['../plots/lsslam_' num2str(iteration) '.png'];
%   print(filename, '-dpng');
% end

saveas(gcf,['../plots/' num2str(iteration) '.fig']);
print(gcf,['../plots/' num2str(iteration) '.png'],'-dpng','-r300');
print(gcf,['../plots/' num2str(iteration) '.eps'],'-depsc','-r300');

end
