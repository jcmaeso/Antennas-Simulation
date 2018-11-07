function [geom,gpflg]=dipoleg_geom()
% Geometry definition for dipole element
%
% Usage: [geom,gpflg]=dipoleg_geom()

global dipoleg_config

dlen=dipoleg_config(1,1);
dhgt=dipoleg_config(1,2);
geom(1:3,1)=[-0.5*dlen ; 0  ;dhgt  ]; % Left hand end
geom(1:3,2)=[ 0.5*dlen ; 0  ;dhgt  ]; % Right hand end
gpflg=1;

