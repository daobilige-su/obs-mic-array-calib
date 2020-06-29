% performs one iteration of the Gauss-Newton algorithm
% each constraint is linearized and added to the Hessian

function dx = linearize_and_solve(g,est_delay_on,est_drift_on)

nnz = nnz_of_graph(g);

% allocate the sparse H and the vector b
H = spalloc(length(g.x), length(g.x), nnz);
b = zeros(length(g.x), 1);

needToAddPrior = true;

% compute the addend term to H and b for each of our constraints
disp('linearize and build system');
for eid = 1:length(g.edges)
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') ~= 0)
    % edge.fromIdx and edge.toIdx describe the location of
    % the first element of the pose in the state vector
    % You should use also this index when updating the elements
    % of the H matrix and the vector b.
    % edge.measurement is the measurement
    % edge.information is the information matrix
    x1 = g.x(edge.fromIdx:edge.fromIdx+2);  % the first robot pose
    x2 = g.x(edge.toIdx:edge.toIdx+2);      % the second robot pose

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_pose_constraint(x1, x2, edge.measurement);
    

    % TODO: compute and add the term to H and b
    b(edge.fromIdx:edge.fromIdx+2) = (b(edge.fromIdx:edge.fromIdx+2)' + (e')*edge.information*A)';
    b(edge.toIdx:edge.toIdx+2) = (b(edge.toIdx:edge.toIdx+2)' + (e')*edge.information*B)';

    H(edge.fromIdx:edge.fromIdx+2,edge.fromIdx:edge.fromIdx+2) = H(edge.fromIdx:edge.fromIdx+2,edge.fromIdx:edge.fromIdx+2) + A'*edge.information*A;
    H(edge.fromIdx:edge.fromIdx+2,edge.toIdx:edge.toIdx+2) = H(edge.fromIdx:edge.fromIdx+2,edge.toIdx:edge.toIdx+2) + A'*edge.information*B;
    H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+2) = H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+2) + B'*edge.information*A;
    H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) = H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) + B'*edge.information*B;


  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') ~= 0)
    % edge.fromIdx and edge.toIdx describe the location of
    % the first element of the pose and the landmark in the state vector
    % You should use also this index when updating the elements
    % of the H matrix and the vector b.
    % edge.measurement is the measurement
    % edge.information is the information matrix
    x1 = g.x(edge.toIdx:edge.toIdx+2);   % the robot pose
    x2 = g.x(edge.fromIdx:edge.fromIdx+(5*g.M-1));     % the landmark

    % Computing the error and the Jacobians
    % e the error vector
    % A Jacobian wrt x1
    % B Jacobian wrt x2
    [e, A, B] = linearize_pose_landmark_constraint(x1, x2, edge.measurement,edge.toIdx,est_delay_on,est_drift_on,g);
    
    
    % TODO: compute and add the term to H and b
    b(edge.fromIdx:edge.fromIdx+(5*g.M-1)) = (b(edge.fromIdx:edge.fromIdx+(5*g.M-1))' + (e')*edge.information*A)';
    b(edge.toIdx:edge.toIdx+2) = (b(edge.toIdx:edge.toIdx+2)' + (e')*edge.information*B)';

    H(edge.fromIdx:edge.fromIdx+(5*g.M-1),edge.fromIdx:edge.fromIdx+(5*g.M-1)) = H(edge.fromIdx:edge.fromIdx+(5*g.M-1),edge.fromIdx:edge.fromIdx+(5*g.M-1)) + A'*edge.information*A;
    H(edge.fromIdx:edge.fromIdx+(5*g.M-1),edge.toIdx:edge.toIdx+2) = H(edge.fromIdx:edge.fromIdx+(5*g.M-1),edge.toIdx:edge.toIdx+2) + A'*edge.information*B;
    H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+(5*g.M-1)) = H(edge.toIdx:edge.toIdx+2,edge.fromIdx:edge.fromIdx+(5*g.M-1)) + B'*edge.information*A;
    H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) = H(edge.toIdx:edge.toIdx+2,edge.toIdx:edge.toIdx+2) + B'*edge.information*B;


    if (needToAddPrior)
      % TODO: add the prior for one pose of this edge
      % This fixes one node to remain at its current location

      H(1:5,1:5) = eye(5);
      
      % if don't need to estimate drift, adjust the information matrix to
      % have no correlation with other state variables
      if est_drift_on<1
          for n = 2:g.M
              H(5*(n-1)+5,1:(5*(n-1)+5-1)) = zeros(1,(5*(n-1)+5-1));
              H(1:(5*(n-1)+5-1),5*(n-1)+5) = zeros((5*(n-1)+5-1),1);
              H(5*(n-1)+5,5*(n-1)+5)=1;
          end
      end
      
      % if don't need to estimate drift, adjust the information matrix to
      % have no correlation with other state variables
      if est_delay_on<1
          for n = 2:g.M
              H(5*(n-1)+4,1:(5*(n-1)+4-1)) = zeros(1,(5*(n-1)+4-1));
              H(1:(5*(n-1)+4-1),5*(n-1)+4) = zeros((5*(n-1)+4-1),1);
              H(5*(n-1)+4,5*(n-1)+4)=1;
          end
      end
      
      %needToAddPrior = false;
    end

  end
end

disp('solving system');

% TODO: solve the linear system, whereas the solution should be stored in dx
% Remember to use the backslash operator instead of inverting H

dx = H\(-b);

end
