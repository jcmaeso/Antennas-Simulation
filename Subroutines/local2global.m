function [globalxyz]=local2global(localxyz,rotoff)
% Convert global 3D node coordinates pairs to rotated & offset coordinates
% according to element local coordinate system.
% 
% Usage: [globalxyz]=local2global(localxyz,rotoff)
%
% localxyz...Local 3D-line coordinate nodes
% rotoff.....Rotation and offset matrix
% globalxyz..Rotated and offset coordinate pairs
%
%
%                                       
%                                     
% [globxyz] is of form (3,N) e.g.    x1 x2 x3 ..etc
% n=1:N sets of xyz coords           y1 y2 
%                                    z1 z2   
%
% rotoff is of the form 3,4) as below :
%
%                    /------- 3x3 rotation matrix
%                   /    /--- 3x1 offset matrix
%                  /    /  
%               ----- ---- 
%               L M N Xoff 
%   3x4 matrix  O P Q Yoff 
%               R S T Zoff 
%
%

[row,N]=size(localxyz);    % Number of xyz coord pairs (3D-lines)
Trot=rotoff(1:3,1:3,1);    % 3x3 rotation matrix
Toff=rotoff(1:3,4,1);      % 3x1 offset matrix

globalxyz=zeros(3,N);      % Initialise output matrix

for n=1:N
 xyz=localxyz(1:3,n);      % n'th xyz coord
 xyzrot=Trot*xyz+Toff;     % Apply rotations and offsets
 globalxyz(1:3,n)=xyzrot;  % Load output plotting matrix
end
 