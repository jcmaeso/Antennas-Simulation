function [geom,gpflg]=helix_geom()
% Geometry definition for helix element
%
% Usage: [geom,gpflg]=helix_geom()

global helix_config
global freq_config;

lambda=3e8/freq_config;

N=helix_config(1,1);
S=helix_config(1,2);
C=1.2*lambda;

radius=C/(2*pi);
segno=0;
geom(1:3,1)=[radius;0;0];           % Helix start on X-axis

for turn=1:N                        % Construct turn by turn
 for seg=1:12                       % Use 12 line segments per turn
  segno=segno+1;                    % Segment number index
  rotang=(seg/12)*2*pi;             % Angle round helix
  xh=radius*cos(rotang);            % X-coord of segment node
  yh=radius*sin(rotang);            % Y-coord of segment node
  zh=segno*S/12;                    % Z-coord of segment node
  geom(1:3,segno+1)=[xh;yh;zh];     % Load coordinate array 
 end
end 

gpflg=1;