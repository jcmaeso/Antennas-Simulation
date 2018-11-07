function [geom,gpflg]=interp_geom()
% Geometry definition for interpolated element data
%
% Usage: [geom,gpflg]=interp_geom()
%
%
% Defines the geometry used to represent the interpolated element
% see inside file for details.


% For information :
%
% The geom array contains the coord list used draw the elements
% on the 3D/2D geometry plots. The format is shown below, the
% first example is for a simple dipole aligned with the x-axis.
%
% Coords           X   Y   Z
% geom(1:3,1)=[ -0.25 ; 0  ;0  ]; % One end of dipole
% geom(1:3,2)=[ 0.25  ; 0  ;0  ]; % the other end
% gpflg=0;                        % Show a groundplane under the element 0=no, 1=yes
%
%
%
% Geometry above is for a dipole.
% Change as appropriate for your element.
%
% Tip :
% To draw separate lines e.g. for a yagi just insert a NaN
% in the coordinate list, between line segments.
%
% e.g.
%                X     Y     Z
% geom(1:3,1)=[ -1.0 ; 0   ; 0   ]; % Beginning of 1st line
% geom(1:3,2)=[ +1.0 ; 0   ; 0   ]; % End of 1st line
% geom(1:3,3)=[  NaN ; NaN ; NaN ]; % Break
% geom(1:3,4)=[ -0.7 ; 0.5 ; 0   ]; % Beginning of 2nd line
% geom(1:3,5)=[ +0.7 ; 0.5 ; 0   ]; % End of 2nd line
%
%
% For information :
%  
%              STRING    VALUE IN array_config
%              'iso'             0
%              'patchr'          1
%              'patchc'          2
%              'dipole'          3
%              'dipoleg'         4
%              'helix'           5
%              'aprect'          6
%              'apcirc'          7
%              'wgr'             8
%              'wgc'             9
%              'dish'            10
%              'interp'          11
%              'user1'           12


gpflg=0;


global freq_config;
lambda=3e8/freq_config;

global array_config;
global interp_config;     % Contains a copy of the array_config matrix for the single sub-array
global patchr_config;     % Has the physical dimensions of the rectangular patch elements.
                          % If other elements are used this could be changed and 
                          % appropriate geometry drawn.

% Unless otherwise defined (normally it is), set the
% the interp_config to be the current array configuration.
% 
% When sub-arrays are defined interp_config is usually a copy
% of array_config as it was when the sub-array was defined. 
% Array_config is usually then cleared to allow definition of the
% the array of 'interp' elements, an array of sub-arrays.
 

if isempty(interp_config)
 interp_config=array_config;
end
 

Elt=interp_config(3,5,1);           % Elt is the numerical representation of the element type used in the sub-array

if Elt==11                          % If sub-array/data import element is 'interp' set to iso (coloured coord axes only) 
 Elt=0;
end

[Row,Col,Nele]=size(interp_config); % Nele is the number of element(s) in the sub-array/data import

[gcoords,gp_flag]=geocode(Elt);
[Row,Ncrds]=size(gcoords);          % Ncrds is the number of coordinate points used to draw
                                    % the individual element(s) in the sub-array/data import

%xyz=ones(Nele:3);

for n=1:1:Nele                      % Extract x,y,z coordinates and store separately
 xyz(n,1)=interp_config(1,4,n);
 xyz(n,2)=interp_config(2,4,n);
 xyz(n,3)=interp_config(3,4,n);
end

%interp_config
%xyz


indx=0;
for r=1:1:Nele     % Loop through sub-array elements
 xo=xyz(r,1);        % Origin of sub-array (x-coord)
 yo=xyz(r,2);        % Origin of sub-array (y-coord)
 zo=xyz(r,3);        % Origin of sub-array (z-coord)
 for c=1:1:Ncrds   % Loop through geometry coords of individual elements
  indx=indx+1;
  x=gcoords(1,c);                  % Element geom (x-coord)
  y=gcoords(2,c);                  % Element geom (y-coord)
  z=gcoords(3,c);                  % Element geom (z-coord)
  geom(1:3,indx)=[xo+x;yo+y;zo+z]; % Assemble list of geometry drawing coordinates
 end
 indx=indx+1;
 geom(1:3,indx)=[nan;nan;nan];     % Line Break
end
indx=indx+1;

if Nele>1
 avgxyz=mean(xyz);                 % Find geometric centre of sub-array if there are more than 1 elements
else
 avgxyz=xyz;                         
end

avgx=avgxyz(1,1);                  % x-coord
avgy=avgxyz(1,2);                  % y-coord
avgz=avgxyz(1,3);                  % z-coord


% Draw lines between sub-array geometric centre and the centre of 
% sub-array each element. Showing how elements are grouped if there are
% more than one of them.

if Nele>0
 for r=1:1:Nele                     % Loop through sub-array elements
  x=xyz(r,1);
  y=xyz(r,2);
  z=xyz(r,3);
  geom(1:3,indx+0)=[nan  ;nan     ;nan ];  % Line Break
  geom(1:3,indx+1)=[avgx ;avgy    ;avgz];  % Geometric Centre of Sub-Array
  geom(1:3,indx+2)=[x    ;y       ;z];     % Sub-Array Element Centre
  indx=indx+3;
 end
end

