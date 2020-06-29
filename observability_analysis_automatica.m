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

% load the graph into the variable "g"
% load ./data/theorim_1_8_mic_circle.mat
% load ./data/mic_array.mat
% load ./data/theorim_1_8_mic_circle.mat

% load ./data/theorim_1_8_mic_circle.mat
% load ./data/theorim_1_8_mic_square.mat
% load ./data/lemma_1_8_mic_line.mat
% load ./data/theorim_1_8_mic_circle_first_4_and_same.mat
% load ./data/lemma_1_8_mic_line_one_side_plus2.mat

% paper:
% theorim 2:
% load ./data/theorim_1_8_mic_circle.mat
% load ./data/theorim_1_8_mic_square.mat
% load ./data/lemma_1_8_mic_1pt_plus_line
% 
% lemma 1:
% load ./data/lemma_1_8_mic_line_one_side_plus2.mat
% 
% col 1:
% load ./data/lemma_1_8_mic_1pt_plus_line.mat
% % load ./data/lemma_1_8_mic_line_one_side_plus3.mat
% load ./data/lemma_1_8_mic_line_one_side_plus2.mat
% 
% col 2:
% load ./data/lemma_1_8_mic_1pt_plus_line.mat
% load ./data/lemma_1_8_mic_line_one_side_plus1.mat
% load ./data/lemma_1_8_mic_line_one_side_plus2.mat
%
% col 3:
% load ./data/lemma_1_8_mic_line_one_side_plus2.mat
% load ./data/lemma_1_8_mic_line_one_side_plus1.mat

% FIM eigen value
% load ./data/theorim_1_8_mic_circle.mat
% load ./data/theorim_1_8_mic_circle_no_vertical_same_num.mat

% exp 
% src num -> full:230, less1:97, less2:230
% load ./data/exp_full.mat
% load ./data/exp_less1.mat
load ./data/exp_less2.mat

% idx of sound src to used for computing ranks
ss_idx = [1, 30, 50, 70, 130];%(1:13);%[1, 2, 3, 4, 5];
% o_r = [3, 3, 5];
% o_k = [1, 2, 3];
o_r = [3, 3, 5];
o_k = [1, 4, 50];

% compute 
[J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift,...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift, ...
    J_G_col_num,J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] ...
    = compute_FIM_rank_automatica(g);

% F matrix rank in theorim 1
F = [J1,T];
F_only_offset = [J1_only_offset,T];
F_only_drift = [J1_only_drift,T];
F_no_offset_drift = [J1_no_offset_drift,T];

F_rank = rank(F);
F_col_num = size(F,2);
F_only_offset_rank = rank(F_only_offset);
F_only_offset_col_num = size(F_only_offset,2);
F_only_drift_rank = rank(F_only_drift);
F_only_drift_col_num = size(F_only_drift,2);
F_no_offset_drift_rank = rank(F_no_offset_drift);
F_no_offset_drift_col_num = size(F_no_offset_drift,2);

disp('==============');
disp('F in theorim 1 ranks:');
disp(['F                  rank: ',num2str(F_rank),'/',num2str(F_col_num) ]);
disp(['F_only_offset      rank: ',num2str(F_only_offset_rank),'/',num2str(F_only_offset_col_num) ]);
disp(['F_only_drift       rank: ',num2str(F_only_drift_rank),'/',num2str(F_only_drift_col_num) ]);
disp(['F_no_offset_drift  rank: ',num2str(F_no_offset_drift_rank),'/',num2str(F_no_offset_drift_col_num) ]);
disp('==============');

% disp rank
J_G_rank = J_G_rank;
J_G_col_num = J_G_col_num;

J_G_only_offset_rank = rank(J_G_only_offset);
J_G_only_offset_col_num = size(J_G_only_offset,2);

J_G_only_drift_rank = rank(J_G_only_drift);
J_G_only_drift_col_num = size(J_G_only_drift,2);

J_G_no_offset_drift_rank = rank(J_G_no_offset_drift);
J_G_no_offset_drift_col_num = size(J_G_no_offset_drift,2);

disp('==============');
disp('FULL system ranks:');
disp(['J_G                  rank: ',num2str(J_G_rank),'/',num2str(J_G_col_num) ]);
disp(['J_G_only_offset      rank: ',num2str(J_G_only_offset_rank),'/',num2str(J_G_only_offset_col_num) ]);
disp(['J_G_only_drift       rank: ',num2str(J_G_only_drift_rank),'/',num2str(J_G_only_drift_col_num) ]);
disp(['J_G_no_offset_drift  rank: ',num2str(J_G_no_offset_drift_rank),'/',num2str(J_G_no_offset_drift_col_num) ]);
disp('==============');

% compute Gi for each sound src
G = [];
G.ss(g.M).Gi = [];
G.ss(g.M).Gi_only_offset = [];
G.ss(g.M).Gi_only_drift = [];
G.ss(g.M).Gi_no_offset_drift = [];

for n=2:g.M
    G.ss(n).Gi                  = zeros(size(ss_idx,2),5);
    G.ss(n).Gi_only_offset      = zeros(size(ss_idx,2),4);
    G.ss(n).Gi_only_drift       = zeros(size(ss_idx,2),4);
    G.ss(n).Gi_no_offset_drift  = zeros(size(ss_idx,2),3);
    for i=1:size(ss_idx,2)
        k = ss_idx(i);
        G.ss(n).Gi(i,:) = J_G((g.M-1+3)*(k-1)+(n-1),5*(n-2)+1:5*(n-1));
        G.ss(n).Gi_rank = rank(G.ss(n).Gi);
        G.ss(n).Gi_rank_def = size(G.ss(n).Gi,2) - G.ss(n).Gi_rank;
        
        G.ss(n).Gi_only_offset(i,:) = J_G_only_offset((g.M-1+3)*(k-1)+(n-1),4*(n-2)+1:4*(n-1));
        G.ss(n).Gi_only_offset_rank = rank(G.ss(n).Gi_only_offset);
        G.ss(n).Gi_only_offset_rank_def = size(G.ss(n).Gi_only_offset,2) - G.ss(n).Gi_only_offset_rank;
        
        G.ss(n).Gi_only_drift(i,:) = J_G_only_drift((g.M-1+3)*(k-1)+(n-1),4*(n-2)+1:4*(n-1));
        G.ss(n).Gi_only_drift_rank = rank(G.ss(n).Gi_only_drift);
        G.ss(n).Gi_only_drift_rank_def = size(G.ss(n).Gi_only_drift,2) - G.ss(n).Gi_only_drift_rank;
        
        G.ss(n).Gi_no_offset_drift(i,:) = J_G_no_offset_drift((g.M-1+3)*(k-1)+(n-1),3*(n-2)+1:3*(n-1));
        G.ss(n).Gi_no_offset_drift_rank = rank(G.ss(n).Gi_no_offset_drift);
        G.ss(n).Gi_no_offset_drift_rank_def = size(G.ss(n).Gi_no_offset_drift,2) - G.ss(n).Gi_no_offset_drift_rank;
    end
    
    disp(['mic: ',num2str(n)]);disp('');
    disp(G.ss(n).Gi);                   disp(G.ss(n).Gi_rank);                  disp(G.ss(n).Gi_rank_def);
    disp(G.ss(n).Gi_only_offset);       disp(G.ss(n).Gi_only_offset_rank);      disp(G.ss(n).Gi_only_offset_rank_def);
    disp(G.ss(n).Gi_only_drift);   disp(G.ss(n).Gi_only_drift_rank);       disp(G.ss(n).Gi_only_drift_rank_def);
    disp(G.ss(n).Gi_no_offset_drift);   disp(G.ss(n).Gi_no_offset_drift_rank);  disp(G.ss(n).Gi_no_offset_drift_rank_def);
    disp('==========');
end

Or = zeros(3,3);
for n=1:3
    Or(n,:) = T((g.M-1+3)*(o_k(n)-1)+(o_r(n)-1),:);
end
Or_rank = rank(Or);
disp(['[','O','_',num2str(o_r(1)),'^',num2str(o_k(1)),';',...
    'O','_',num2str(o_r(2)),'^',num2str(o_k(2)),';',...
    'O','_',num2str(o_r(3)),'^',num2str(o_k(3)),']: ']);
disp(Or);
disp('rank Or: ');
disp(Or_rank);
disp('==========');

% % min eigen
% FIM_only_offset
% FIM_only_drift
% FIM_no_offset_drift



%% plots
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









