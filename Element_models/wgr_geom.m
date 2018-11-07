function [geom,gpflg]=wgr_geom()
% Geometry definition for rectangular waveguide element.
%
% Usage: geom=wgr_geom()

global wgr_config;
 
% Dimension assigments a,b changed such that br=a and ar=b so that E-field
% is aligned with x-axis, see below.
 
ar=wgr_config(1,1);
br=wgr_config(1,2);


geom(1:3,1)=[-0.5*br ;-0.5*ar  ;0  ]; % Bottom left
geom(1:3,2)=[-0.5*br ; 0.5*ar  ;0  ]; % Top left
geom(1:3,3)=[ 0.5*br ; 0.5*ar  ;0  ]; % Top right
geom(1:3,4)=[ 0.5*br ;-0.5*ar  ;0  ]; % Bottom right
geom(1:3,5)=[-0.5*br ;-0.5*ar  ;0  ]; % Bottom left

gpflg=1;