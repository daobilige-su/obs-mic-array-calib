% This file performs least square SLAM
% make sure the creat_graph.m has been run before running this file.


%% refresh
clear;
close all;
clc;

%% parameters

% add path for including some tool functions
addpath('tools');

%% computing observability analysis

% FIM eigen value
% load ./data/theorim_1_8_mic_circle.mat
load ./data/exp_full.mat

% compute 
[J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift,...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift, ...
    J_G_col_num,J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] ...
    = compute_FIM_rank_automatica(g);

a = FIM_eigs;
a_sort = sort(a);

% FIM eigen value
% load ./data/theorim_1_8_mic_circle_no_vertical_same_num.mat
load ./data/exp_less2.mat

% compute 
[J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift,...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift, ...
    J_G_col_num,J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] ...
    = compute_FIM_rank_automatica(g);

b = FIM_eigs;
b_sort = sort(b);



%% plots

figure;
semilogy(a,'Marker','s');
hold on;
semilogy(b,'Marker','*','color','r');
grid on;
legend('cir+ver','cir');

figure;
semilogy(a_sort,'Marker','s');
hold on;
semilogy(b_sort,'Marker','*','color','r');
grid on;
% legend('cir+ver','cir');
legend('exp. traj. 3','exp. traj. 2');






% 
% figure,
% hold on;
% plot(rank_deficiency,'Marker','^','LineWidth',2);
% xlabel('Num. of sound src. loc.'); ylabel('Rank deficiency');
% xlim([0,50]); grid on;
% %legend('Sim. 1','Sim. 2');
% %saveas(gcf,['../plots/observability/3d_rank_deficiency.fig']);
% % print(gcf,['../plots/observability/3d_rank_deficiency.png'],'-dpng','-r300');
% % print(gcf,['../plots/observability/3d_rank_deficiency.eps'],'-depsc','-r300');
% 
% figure,
% hold on;
% plot(min_eigen,'Marker','^','LineWidth',2);
% xlabel('Num. of sound src. loc.'); ylabel('Min eigenvalue of FIM');
% xlim([0,50]); grid on;
% %legend('Sim. 1','Sim. 2');
% %saveas(gcf,['../plots/observability/3d_min_eigen.fig']);
% % print(gcf,['../plots/observability/3d_min_eigen.png'],'-dpng','-r300');
% % print(gcf,['../plots/observability/3d_min_eigen.eps'],'-depsc','-r300');









