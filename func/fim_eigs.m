function fim_eigs(input1, input2)
%% parameters

%% computing observability analysis

% FIM eigen value
load(input1.graph_file);

% compute 
[J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift,...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift, ...
    J_G_col_num,J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] ...
    = compute_fim(g);

a = FIM_eigs;
a_sort = sort(a);

% FIM eigen value
load(input2.graph_file);

% compute 
[J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift,...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift, ...
    J_G_col_num,J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] ...
    = compute_fim(g);

b = FIM_eigs;
b_sort = sort(b);

%% plots

figure;
semilogy(a_sort,'Marker','s');
hold on;
semilogy(b_sort,'Marker','*','color','r');
grid on;
legend(input1.fig.legend, input2.fig.legend);

end







