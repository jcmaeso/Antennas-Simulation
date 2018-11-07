function [geom,gpflg]=patchc_geom()
% Geometry definition for patch element
%
% Usage: [geom,gpflg]=patchc_geom()

global patchc_config

a=patchc_config(1,2);
h=patchc_config(1,3);
   
radius=a;
segno=0;
geom(1:3,1)=[radius;0;h];           % circle to start on X-axis

for seg=1:12                        % Use 12 line segments per turn
  segno=segno+1;                    % Segment number index
  rotang=(seg/12)*2*pi;             % Angle round circle
  xh=radius*cos(rotang);            % X-coord of segment node
  yh=radius*sin(rotang);            % Y-coord of segment node
  zh=h;                             % Z-coord of segment node
  geom(1:3,segno+1)=[xh;yh;zh];     % Load coordinate array 
end
 
gpflg=1;
