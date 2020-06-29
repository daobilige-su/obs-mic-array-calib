% calculates the number of non-zeros of a graph
% Actually, it is an upper bound, as duplicate edges might be counted several times

function nnz = nnz_of_graph(g)

nnz = 0;

% elements along the diagonal
for n = 1:length(g.idLookup)
  nnz = nnz + g.idLookup(n).dimension^2;
end

% off-diagonal elements
for eid = 1:length(g.edges)
  edge = g.edges(eid);
  if (strcmp(edge.type, 'P') ~= 0)
    nnz = nnz + 2 * 3*3;
  elseif (strcmp(edge.type, 'L') ~= 0)
    nnz = nnz + 2 * 3*90;
  end
end

end
