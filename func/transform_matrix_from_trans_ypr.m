function M = transform_matrix_from_trans_ypr(x,y,z,yaw,pitch,roll,compute_once)

% PLEASE TEST THESE TRANSFORMATION FUNCTION EVERY TIME WHEN MAKING NEW ONE.
% SOMETIME IT IS DIFFICULT TO DEBUG AND DIFFICULT TO THINK/IMAGINE THESE
% COMPLICATED 3D TRANSFORM
%
% Rigid transformation matrix M:
%
% if point P' [1,0,0,1] (x,y,z,w) is multiplied by M: P=M*P'
% this means that point P' in local coord has transformed to global coord.
% Or, we can understand that global point P' has been transformed by the
% same moment that M transformed from global coordinate.
% In return, if we want to get local point P' from Rigid transformation
% matrix M (local coord frame/ pose) and global point P, P'=inv(M)*P.
% if M is not given, and Pose (tans+ypr) is given, we have to obtain M
% first, unfortunately.
% Please note that the inverse transform can NOT be
% (-x,-y,-z,-yaw,-pitch,-roll). This is because the rotation sequence from
% yaw pitch roll can NOT be recovered by sequence -yaw -pitch -roll, it
% should be -roll -pitch -yaw (the sequence should also inversed!).
%
% for detailed computation, look at "A tutorial on SE(3) transformation parameterizations and
% on-manifold optimization" by MAPIR Group (P. 32)

% if given as a vector
if nargin==1
    y = x(2);
    z = x(3);
    yaw = x(4);
    pitch = x(5);
    roll = x(6);
    x = x(1);
end

if nargin<7
    compute_once = 1;
end

if ~compute_once
    Rz = [cos(yaw), -sin(yaw), 0;
          sin(yaw), cos(yaw),  0;
          0,      0,       1];

    Ry = [cos(pitch), 0, sin(pitch);
          0,          1, 0;
          -sin(pitch),0, cos(pitch)];

    Rx = [1, 0,         0;
          0, cos(roll), -sin(roll);
          0, sin(roll), cos(roll)];

    R = Rz*Ry*Rx;
else

    R = [cos(yaw)*cos(pitch), cos(yaw)*sin(pitch)*sin(roll)-sin(yaw)*cos(roll), cos(yaw)*sin(pitch)*cos(roll)+sin(yaw)*sin(roll);
         sin(yaw)*cos(pitch), sin(yaw)*sin(pitch)*sin(roll)+cos(yaw)*cos(roll), sin(yaw)*sin(pitch)*cos(roll)-cos(yaw)*sin(roll);
         -sin(pitch),         cos(pitch)*sin(roll),                             cos(pitch)*cos(roll)];
end

M = [[R, [x;y;z]]; [0,0,0,1]];

end