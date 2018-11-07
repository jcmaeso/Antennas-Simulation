function [geom,gpflg]=dish_geom()
% Geometry definition for circular parabolic dish
%
% Usage: geom=dish_geom()

global dish_config;
  
dia=dish_config(1,1);

radius=dia/2;
segno=0;
geom(1:3,1)=[radius;0;0];           % Circle start on X-axis

for seg=1:24                        % Use 24 line segments 
  segno=segno+1;                    % Segment number index
  rotang=(seg/24)*2*pi;             % Angle round helix
  xh=radius*cos(rotang);            % X-coord of segment node
  yh=radius*sin(rotang);            % Y-coord of segment node
  zh=0;                             % Z-coord of segment node
  geom(1:3,segno+1)=[xh;yh;zh];     % Load coordinate array 
end

 
geom(1:3,segno+2)=[nan;nan;nan];                               % Line break

rot120=120*pi/180;

geom(1:3,segno+3)=[radius*cos(0);radius*sin(0);0];             % Strut1 end1
geom(1:3,segno+4)=[0;0;radius/1.5];                            % Strut1 end2

geom(1:3,segno+5)=[nan;nan;nan];                               % Line break

geom(1:3,segno+6)=[radius*cos(rot120);radius*sin(rot120);0];   % Strut2 end1
geom(1:3,segno+7)=[0;0;radius/1.5];                            % Strut2 end2 

geom(1:3,segno+8)=[nan;nan;nan];                               % Line break

geom(1:3,segno+9)=[radius*cos(-rot120);radius*sin(-rot120);0]; % Strut2 end1
geom(1:3,segno+10)=[0;0;radius/1.5];                           % Strut2 end2 

gpflg=1;