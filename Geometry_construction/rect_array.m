function rect_array(nx,ny,sx,sy,eltype,Erot)
% Define a rectangular array
%
% Usage: rect_array(nx,ny,sx,sy,eltype,Erot)
%
% nx......Number of elements in x-direction
% ny......Number of elements in y-direction
% sx......Element spacing in x (meters)
% sy......Element spacing in y (meters)
% eltype..Element type (string)
% Erot....E-plane angle from X-axis (Deg)
%
% Valid strings for eltype are listed below. 
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
%
%  e.g. rect_array(4,3,(0.7*lambda),(0.7*lambda),'patchr',0)
%
%
%       |sx |                   
%       |   |                   # = rectangular array element
%       #   #   #   #-----
%                        |          Y
%                        sy         |   
%                        |          |  
%       #   #   #   #-----          +---->X      
%      
%                               Axis Orientation
%
%       #   #   #   #



% This function generates a global matrix variable :
% array_config(3,5,n)
%
% For each of n=1:N elements there is a 3x5 element
% matrix which defines the element's location, orientation
% excitation and type.
%
%                     /---------- 3x3 rotation matrix
%                    /    /------ 3x1 offset matrix
%                   /    /   /--- Amplitude,Phase,ElementType (1,2,3..)
%                  /    /   /
%               ----- ---- ---
%               L M N Xoff Amp
%   3x5 matrix  O P Q Yoff Pha
%               R S T Zoff Elt

global array_config;


[Trow,Tcol,N]=size(array_config);  % Total number of elements in array N

if array_config(1,1,1)==-1         % If there are no existing elements          
 elnumber=1;                       % Start array element numbering from 1
else
 elnumber=N+1;                     % Append to existing array elements
end
 

fprintf('Constructing rectangular X-Y array %i by %i elements\n',nx,ny);

Trot=rotz(Erot*pi/180);      % E-plane rotation angle around Z-axis
                             % angle measured from X-axis

Amp=1;                       % Set amplitude to 1 for all elements
Pha=0;                       % Set phase to 0 for all elemnts

[Elt]=eltcode(eltype);       % Assign numeric code for element type 

Texc=[Amp;Pha;Elt];          % Assemble last column of 3x5 element matrix

index=0;                     % Define element positions using the offset matrix
for y=1:1:ny
 for x=1:1:nx
  index=index+1;
  Xoff=((x-1)*sx);       % X-offset
  Yoff=((y-1)*sy);       % Y-offset
  Zoff=0;                % Z-offset
  Toff=[Xoff;Yoff;Zoff]; % Assemble offset matrix
  
  % Add element number (elnumber+index-1) to array_config
  array_config(:,:,(elnumber+index-1))=[Trot,Toff,Texc]; 
 end
end
centre_array; % Centre array in global coord system

