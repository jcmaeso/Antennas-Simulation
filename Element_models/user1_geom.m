function [geom,gpflg]=user1_geom()
% Geometry definition for user element
%
% Usage: [geom,gpflg]=user1_geom()

global user1_config

geom(1:3,1)=[0 ; 0  ;0  ]; % 
geom(1:3,2)=[0 ; 0  ;0  ]; % 

gpflg=1;


% If parameters represent X-coords of element the geom
% vectors may look something like this :
%
% parameter1=user1_config(1,1); % Parameter1 input
% parameter2=user1_config(1,2); % Parameter2 input
%
%               X            Y   Z
% geom(1:3,1)=[ parameter1 ; 0  ;0  ]; % One end of a line...
% geom(1:3,2)=[ parameter2 ; 0  ;0  ]; % the other end
%
% Tip :
% To draw separate lines e.g. for a yagi just insert a NaN
% in the coordinate list, between line segments.
%
% e.g.
%
%                X     Y     Z
% geom(1:3,1)=[ -1.0 ; 0   ; 0   ]; % Beginning of 1st line
% geom(1:3,2)=[ +1.0 ; 0   ; 0   ]; % End of 1st line
% geom(1:3,3)=[  NaN ; NaN ; NaN ]; % Break
% geom(1:3,4)=[ -0.7 ; 0.5 ; 0   ]; % Beginning of 2nd line
% geom(1:3,5)=[ +0.7 ; 0.5 ; 0   ]; % End of 2nd line