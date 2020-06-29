% extract the offset of the poses and the landmarks

function [poses, landmarks] = get_poses_landmarks(g)

poses = [];
landmarks = [];

%{
for [value, key] = g.idLookup
  dim = value.dimension;
  offset = value.offset;
  if (dim == 3)
    poses = [poses; offset];
  elseif (dim == 2)
    landmarks = [landmarks; offset];
  end
end
%}

for n = 1:length(g.idLookup)

  dim = g.idLookup(n).dimension;
  offset = g.idLookup(n).offset;
  if (dim == 3)
    poses = [poses; offset];
  elseif (dim == 5)
    landmarks = [landmarks; offset];
  end
end

end
