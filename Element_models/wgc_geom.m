function [geom,gpflg]=wgc_geom()
% Geometry definition for circular waveguide element
%
% Usage: geom=wgc_geom()

global wgc_config;
  
dia=wgc_config(1,1);

radius=dia/2;
segno=0;
geom(1:3,1)=[radius;0;0];           % Circle start on X-axis

for seg=1:24                        % Use 12 line segments per turn
  segno=segno+1;                    % Segment number index
  rotang=(seg/24)*2*pi;             % Angle round helix
  xh=radius*cos(rotang);            % X-coord of segment node
  yh=radius*sin(rotang);            % Y-coord of segment node
  zh=0;                             % Z-coord of segment node
  geom(1:3,segno+1)=[xh;yh;zh];     % Load coordinate array 
end
 

gpflg=1;