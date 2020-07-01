function [J_G, J1, J2, T, J1_only_offset, J1_only_drift, J1_no_offset_drift, ...
    J_G_only_offset, J_G_only_drift, J_G_no_offset_drift, ...
    FIM_only_offset, FIM_only_drift, FIM_no_offset_drift,  ...
    J_G_col_num, J_G_rank,FIM,FIM_eigs,min_FIM_eig,rank_deficiency,min_eigen] = compute_fim(g)

J_G = [];
W_inv = [];

rank_deficiency = [];
min_eigen = [];

for eid = 1:length(g.edges)
%   disp([num2str(eid),'/',num2str(length(g.edges))])
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') ~= 0)
    % edge.fromIdx and edge.toIdx describe the location of
    % the first element of the pose in the state vector
    % You should use also this index when updating the elements
    % of the H matrix and the vector b.
    % edge.measurement is the measurement
    % edge.information is the information matrix
    x1 = g.x_gt(edge.fromIdx:edge.fromIdx+2);  % the first robot pose
    x2 = g.x_gt(edge.toIdx:edge.toIdx+2);      % the second robot pose

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_pose_constraint(x1, x2, edge.measurement);
    
    % compute and add the term to H and b
    J_G = [J_G, zeros(size(J_G,1),3);...
           zeros(3,size(J_G,2)+3)];
    J_G(end-2:end, end-5:end) = [A,B];
    
    W_inv = [W_inv, zeros(size(W_inv,1),3);...
             zeros(3,size(W_inv,2)), edge.information];

  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') ~= 0)
    % edge.fromIdx and edge.toIdx describe the location of
    % the first element of the pose and the landmark in the state vector
    % You should use also this index when updating the elements
    % of the H matrix and the vector b.
    % edge.measurement is the measurement
    % edge.information is the information matrix
    x1 = g.x_gt(edge.toIdx:edge.toIdx+2);   % the robot pose
    x2 = g.x_gt(edge.fromIdx:edge.fromIdx+(5*g.M-1));     % the landmark

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_landmark_constraint(x1, x2, edge.measurement,edge.toIdx,1,1,g);
    
    A = A(:,6:end);
    
    % compute and add the term to H and b
    if isempty(J_G)
        J_G = zeros(g.M-1,size(A,2)+size(B,2));
    else
        J_G = [J_G;...
               zeros(g.M-1,size(J_G,2))];
    end
    J_G(end-(g.M-1)+1:end,1:5*(g.M-1)) = A;
    J_G(end-(g.M-1)+1:end,end-3+1:end) = B;
    
    W_inv = [W_inv, zeros(size(W_inv,1),g.M-1);...
             zeros(g.M-1,size(W_inv,2)), edge.information];
         
%     if isempty(rank_deficiency)
      J_G_col_num = size(J_G,2);
      J_G_rank = rank(J_G);
      rank_deficiency = [rank_deficiency,J_G_col_num - J_G_rank];
      
      FIM = J_G'*W_inv*J_G;
      FIM_eigs = eig(FIM);
      min_eigen = [min_eigen, norm(min(FIM_eigs))];
%     end

  end
  
  
  
end

J_G_col_num = size(J_G,2);
J_G_rank = rank(J_G);

FIM = J_G'*W_inv*J_G;
FIM_eigs = eig(FIM);

min_FIM_eig = min(FIM_eigs);

% situation in which only time offset / clock drift or nothing is present
J1 = J_G(:,1:5*(g.M-1));
J2 = J_G(:,5*(g.M-1)+1:end);

J1_only_offset = zeros(size(J1,1),size(J1,2)-(g.M-1));
J1_only_drift = zeros(size(J1,1),size(J1,2)-(g.M-1));
J1_no_offset_drift = zeros(size(J1,1),size(J1,2)-2*(g.M-1));
for n=1:g.M-1
    J1_only_offset(:,4*(n-1)+1:4*n) = J1(:,5*(n-1)+1:5*(n-1)+4);
    J1_only_drift(:,4*(n-1)+1:4*n) = [J1(:,5*(n-1)+1:5*(n-1)+3),J1(:,5*(n-1)+5)];
    J1_no_offset_drift(:,3*(n-1)+1:3*n) = J1(:,5*(n-1)+1:5*(n-1)+3);
end

J_G_only_offset = [J1_only_offset, J2];
J_G_only_drift = [J1_only_drift, J2];
J_G_no_offset_drift = [J1_no_offset_drift, J2];

% T matrix
T = zeros(size(J2,1),3);
K = size(J2,2)/3;
for k=1:K
    T = T+J2(:,3*(k-1)+1:3*(k-1)+3);
end


FIM_only_offset = J_G_only_offset'*W_inv*J_G_only_offset;
FIM_only_drift = J_G_only_drift'*W_inv*J_G_only_drift;
FIM_no_offset_drift = J_G_no_offset_drift'*W_inv*J_G_no_offset_drift;

end