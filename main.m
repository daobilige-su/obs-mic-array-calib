%% refresh
clear;
close all;
clc;

%% add path for including some tool functions
addpath('func');

%% params

% fig.4 (a)
fig4a.graph_file = './data/fig4a.mat';

% fig.4 (b)
fig4b.graph_file = './data/fig4b.mat';

% fig.5 (a)
fig5a.graph_file = './data/fig5a.mat';

% fig.5 (b)
fig5b.graph_file = './data/fig5b.mat';

% fig.5 (c)
fig5c.graph_file = './data/fig5c.mat';

% fig.6 (a)
fig6a.graph_file = './data/fig6a.mat';

% fig.8 (a)
fig8a.graph_file = './data/fig8a.mat';

% fig.8 (b)
fig8b.graph_file = './data/fig8b.mat';

%% illustrative results in section VI
disp('==================================================================');
disp('VI. ILLUSTRATIVE RESULTS');
disp(' ');

% A. cases when observability is guaranteed/impossible
disp('==================================================================');
disp('A. Cases when observability is guaranteed/impossible');
disp(' ');

% Fig.4(a)
disp('------------------------------------------------------------------');
disp('Fig.4(a)');
disp('----------');
fig4a.eqn.ss_idx = [1,2,3,4,21];
fig4a.eqn.o_r = [3, 3, 5];
fig4a.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig4a.eqn.type = 1; 

observability_analysis_func(fig4a);
disp('');

% Fig.4(b)
disp('------------------------------------------------------------------');
disp('Fig.4(b)');
disp('----------');
fig4b.eqn.ss_idx = [1,2,3,4,5];
fig4b.eqn.o_r = [3, 3, 5];
fig4b.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig4b.eqn.type = 1; 

observability_analysis_func(fig4b);
disp('');

% Fig.5(a)
disp('------------------------------------------------------------------');
disp('Fig.5(a)');
disp('----------');
fig5a.eqn.ss_idx = [1,2,3,4,6];
fig5a.eqn.o_r = [3, 3, 5];
fig5a.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig5a.eqn.type = 1; 

observability_analysis_func(fig5a);
disp('');

% Fig.5(c)
disp('------------------------------------------------------------------');
disp('Fig.5(c)');
disp('----------');
fig5c.eqn.ss_idx = [9,10,11,12,13];
fig5c.eqn.o_r = [3, 3, 5];
fig5c.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig5c.eqn.type = 1; 

observability_analysis_func(fig5c);
disp('');

% B. cases with only time offsets or clock drifts
disp('==================================================================');
disp('B. Cases with only time offsets or clock drifts');
disp(' ');

% Fig.5(c) with only time offset
disp('------------------------------------------------------------------');
disp('Fig.5(c) with only time offset');
disp('----------');
fig5c.eqn.ss_idx = [10,11,12,13];
fig5c.eqn.o_r = [3, 3, 5];
fig5c.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig5c.eqn.type = 2; 

observability_analysis_func(fig5c);
disp('');

% Fig.5(c) with only clock drift
disp('------------------------------------------------------------------');
disp('Fig.5(c) with only clock drift');
disp('----------');
fig5c.eqn.ss_idx = [10,11,12,13];
fig5c.eqn.o_r = [3, 3, 5];
fig5c.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig5c.eqn.type = 3; 

observability_analysis_func(fig5c);
disp('');

% Fig.5(b) with only clock drift
disp('------------------------------------------------------------------');
disp('Fig.5(b) with only clock drift');
disp('----------');
fig5b.eqn.ss_idx = [9,10,11,12];
fig5b.eqn.o_r = [3, 3, 5];
fig5b.eqn.o_k = [1, 2, 3];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig5b.eqn.type = 3; 

observability_analysis_func(fig5b);
disp('');

% C. impact of eigenvalues of FIM on observability and convergence of the system
disp('==================================================================');
disp('C. Impact of eigenvalues of FIM on observability and convergence'); 
disp('of the system');
disp(' ');
disp('Check plotting of Fig.6(b) below.');
disp(' ');

%% experimental results in section VII
disp('==================================================================');
disp('VII. EXPERIMENTAL RESULTS');
disp(' ');
% 
% Fig.8(a)
disp('------------------------------------------------------------------');
disp('Fig.8(a)');
disp('----------');
fig8a.eqn.ss_idx = [1,2,30,50,70];
fig8a.eqn.o_r = [3, 3, 5];
fig8a.eqn.o_k = [1, 4, 50];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig8a.eqn.type = 1; 

observability_analysis_func(fig8a);
disp('');

% Fig.8(b)
disp('------------------------------------------------------------------');
disp('Fig.8(b)');
disp('----------');
disp('This step will take a while (up to 1 min), please be patient ...');
disp(' ');
fig8b.eqn.ss_idx = [1,30,50,70, 130];
fig8b.eqn.o_r = [3, 3, 5];
fig8b.eqn.o_k = [1, 4, 50];
% type is one of:
% 1: full system with both time offset and clock drift, 
% 2: only time offset, 3: only clock drift, 4: none.
fig8b.eqn.type = 1; 

observability_analysis_func(fig8b);
disp('');

%% figures in Fig.4, Fig.5, Fig.6 and Fig.8
disp('==================================================================');
disp('Plotting figures in Fig.4, Fig.6 and Fig.8');
disp(' ');

% Fig.4(a)
disp('------------------------------------------------------------------');
disp('Plot Fig.4(a) in Fig. 1.');
fig4a.eps = 1e-2;
fig4a.fig.title = 'Fig.4(a)';
fig4a.fig.view_a = 30; fig4a.fig.view_e = 15;

calib_func(fig4a);
pause(0.5);

% Fig.4(b)
disp('------------------------------------------------------------------');
disp('Plot Fig.4(b) in Fig. 2.');
fig4b.eps = 1e-2;
fig4b.fig.title = 'Fig.4(b)';
fig4b.fig.view_a = 30; fig4b.fig.view_e = 15;

calib_func(fig4b);
pause(0.5);

% Fig.6(a)
disp('------------------------------------------------------------------');
disp('Plot Fig.6(a) in Fig. 3.');
fig6a.eps = 1e-2;
fig6a.fig.title = 'Fig.6(a)';
fig6a.fig.view_a = 30; fig6a.fig.view_e = 15;

calib_func(fig6a);
pause(0.5);

% Fig.6(b)
disp('------------------------------------------------------------------');
disp('Plot Fig.6(b) in Fig. 4.');
fig4b.fig.legend = 'cir+ver'; fig6a.fig.legend = 'cir';
fim_eigs(fig4b, fig6a); title('Fig.6(b)');
pause(0.5);

% Fig.8(b)
disp('------------------------------------------------------------------');
disp('Plot Fig.8(b) in Fig. 5.');
fig8b.eps = 1.5;
fig8b.fig.title = 'Fig.8(b)';
fig8b.fig.view_a = 61.1418; fig8b.fig.view_e = 47.4000;

calib_func(fig8b);
pause(0.5);

%% All done
disp('==================================================================');
disp('Finish');
disp(' ');
disp('==================================================================');




