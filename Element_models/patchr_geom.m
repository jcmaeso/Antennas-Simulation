function [geom,gpflg]=patchr_geom()
% Geometry definition for patch element
%
% Usage: [geom,gpflg]=patchr_geom()

global patchr_config;
  
W=patchr_config(1,2);
L=patchr_config(1,3);
h=patchr_config(1,4);

geom(1:3,1)=[-0.5*L ;-0.5*W  ;h  ]; % Bottom left
geom(1:3,2)=[-0.5*L ; 0.5*W  ;h  ]; % Top left
geom(1:3,3)=[ 0.5*L ; 0.5*W  ;h  ]; % Top right
geom(1:3,4)=[ 0.5*L ;-0.5*W  ;h  ]; % Bottom right
geom(1:3,5)=[-0.5*L ;-0.5*W  ;h  ]; % Bottom left

gpflg=1;
