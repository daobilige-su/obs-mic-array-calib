% Computes the total error of the graph
function Fx = compute_global_error(g)

Fx = 0;

% Loop over all edges
for eid = 1:length(g.edges)
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') ~= 0)

    x1 = g.x(edge.fromIdx:edge.fromIdx+2);
    x2 = g.x(edge.toIdx:edge.toIdx+2);

    % compute the error of the constraint and add it to Fx.
    % Use edge.measurement and edge.information to access the
    % measurement and the information matrix respectively.
    e_ij = (x2 - x1) - edge.measurement;
    e_ls_ij = e_ij' * edge.information * e_ij;
    Fx = Fx + e_ls_ij;


  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') ~= 0)
    l = g.x(edge.fromIdx:edge.fromIdx+(5*g.M-1));  % the landmark
    x = g.x(edge.toIdx:edge.toIdx+2);      % the robot pose

    % compute the error of the constraint and add it to Fx.
    % Use edge.measurement and edge.information to access the
    % measurement and the information matrix respectively.
    e_il = zeros(g.M-1,1);
    for n = 1:(g.M-1)
        e_il(n) = sqrt((l(5*n+1)-x(1))^2 + (l(5*n+2)-x(2))^2 + (l(5*n+3)-x(3))^2)/340 - ...
            sqrt((x(1))^2 + (x(2))^2  + (x(3))^2)/340 + l(5*n+4) + ...
            ((edge.toIdx-5*g.M+2)/3)*l(5*n+5) - edge.measurement(n);
    end
    
    e_ls_il = e_il' * edge.information * e_il;
    Fx = Fx + e_ls_il;

  end

end
