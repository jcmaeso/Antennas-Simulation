function XR=rotx(angle)
% Returns rotation matrix for rotation about X-axis
%
% Usage: XR=rotx(angle)
%
% angle....Rotation angle (radians)
%
% e.g. XR=rotx(pi/2) % +ve Rotation around the X-axis
%
% Positive rotation is defined as clockwise as looking from the
% end of the X-axis towards the origin.

XR=[ 1    0               0
     0    cos(angle)   sin(angle) 
     0   -sin(angle)   cos(angle)];