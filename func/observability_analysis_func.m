function observability_analysis_func(input)

%% parameters

% graph file
load(input.graph_file);

% idx of sound src to used for computing ranks
ss_idx = input.eqn.ss_idx;
% idx of Or
o_r = input.eqn.o_r;
o_k = input.eqn.o_k;

%% computing observability analysis

% compute 
[J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift,...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift, ...
    J_G_col_num,J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] ...
    = compute_fim(g);

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

% disp rank
J_G_rank = J_G_rank;
J_G_col_num = J_G_col_num;

J_G_only_offset_rank = rank(J_G_only_offset);
J_G_only_offset_col_num = size(J_G_only_offset,2);

J_G_only_drift_rank = rank(J_G_only_drift);
J_G_only_drift_col_num = size(J_G_only_drift,2);

J_G_no_offset_drift_rank = rank(J_G_no_offset_drift);
J_G_no_offset_drift_col_num = size(J_G_no_offset_drift,2);

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
end

% (1) display O_r 
Or = zeros(3,3);
for n=1:3
    Or(n,:) = T((g.M-1+3)*(o_k(n)-1)+(o_r(n)-1),:);
end
Or_rank = rank(Or);
disp(['O_r = [','O','_',num2str(o_r(1)),'^',num2str(o_k(1)),';',...
    'O','_',num2str(o_r(2)),'^',num2str(o_k(2)),';',...
    'O','_',num2str(o_r(3)),'^',num2str(o_k(3)),']: ']);
disp(Or);
disp(['rank(O_r) = ',num2str(Or_rank)]);
disp('----------');

% (2) disp G_i
n=2;
disp(['G_',num2str(n),':']);
if input.eqn.type==1
    disp(G.ss(n).Gi);                   
    disp(['rank(G_',num2str(n),') = ',num2str(G.ss(n).Gi_rank)]);
elseif input.eqn.type==2
    disp(G.ss(n).Gi_only_offset);       
    disp(['rank(G_',num2str(n),') = ',num2str(G.ss(n).Gi_only_offset_rank)]);
elseif input.eqn.type==3
    disp(G.ss(n).Gi_only_drift);        
    disp(['rank(G_',num2str(n),') = ',num2str(G.ss(n).Gi_only_drift_rank)]);
elseif input.eqn.type==4
    disp(G.ss(n).Gi_no_offset_drift);   
    disp(['rank(G_',num2str(n),') = ',num2str(G.ss(n).Gi_no_offset_drift_rank)]);
end
disp('----------');


% (3) disp F rank and column number
if input.eqn.type==1
    disp(['rank(F) = ',num2str(F_rank),', with column number of ',num2str(F_col_num) ]);
elseif input.eqn.type==2
    disp(['rank(F) = ',num2str(F_only_offset_rank),', with column number of ',num2str(F_only_offset_col_num) ]);
elseif input.eqn.type==3
    disp(['rank(F) = ',num2str(F_only_drift_rank),', with column number of ',num2str(F_only_drift_col_num) ]);
elseif input.eqn.type==4
    disp(['rank(F) = ',num2str(F_no_offset_drift_rank),', with column number of ',num2str(F_no_offset_drift_col_num) ]);
end
disp('----------');

% (4) disp J_G rank and column number
if input.eqn.type==1
disp(['rank(J_G) = ',num2str(J_G_rank),', with column number of ',num2str(J_G_col_num) ]);
elseif input.eqn.type==2
    disp(['rank(J_G) = ',num2str(J_G_only_offset_rank),', with column number of ',num2str(J_G_only_offset_col_num) ]);
elseif input.eqn.type==3
    disp(['rank(J_G) = ',num2str(J_G_only_drift_rank),', with column number of ',num2str(J_G_only_drift_col_num) ]);
elseif input.eqn.type==4
    disp(['rank(J_G) = ',num2str(J_G_no_offset_drift_rank),', with column number of ',num2str(J_G_no_offset_drift_col_num) ]);
end
disp(' ');

end









