function YR=roty(angle)
% Returns rotation matrix for rotation about Y-axis
%
% Usage: YR=roty(angle)
%
% angle....Rotation angle (radians)
%
% e.g. YR=roty(pi/2) % +ve Rotation of 90 Deg around the Y-axis
%
% Positive rotation is defined as clockwise as looking from the
% end of the Y-axis towards the origin.

YR=[ cos(angle)  0  -sin(angle)             
        0        1       0
     sin(angle)  0   cos(angle)];
