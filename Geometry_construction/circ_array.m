function circ_array(nr,nrg,sr,srng,eltype,Erot,Efix)
% Define a circular array using number of elements in first
% ring and element spacing to determine the number of elements
% in subsequent rings.
%
% Usage: circ_array(nr,nrg,sr,srng,eltype,Erot,Efix)
%
% nr......Number of elements in 1st ring (integer)
% nrg.....Number of rings (integer)
% sr......Element spacing around the ring (m)
% srng....Spacing between rings (m)
% eltype..Element type (string)
% Erot....E-plane rotation about Z-axis (Deg) 
% Efix....E-plane rotation with ring angle (string)
% 
% Options for Efix are :
% 
%              'yes' - Fixed E-plane rotation as defined by Erot
%              'no'  - Rotate with ring angle, starting at Erot              
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
% e.g. circ_array(6,2,(0.7*lambda),(0.7*lambda),'patchr',0,'yes')

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
 

fprintf('Constructing %i ring circular array\n',nrg);

Erot_rad=Erot*pi/180;        % Element E-plane orientation rel to Z-axis

Trot=[1 0 0                  % Initialise rotation matrix as 'identity'
      0 1 0                  % (zero rotation)
      0 0 1]; 

Amp=1;                       % Set amplitude to 1 for all elements
Pha=0;                       % Set phase to 0 for all elemnts

[Elt]=eltcode(eltype);       % Assign numeric code for element type 

Texc=[Amp;Pha;Elt];            % Assemble last column of 3x5 element matrix

index=0;                       % Define element positions using the offset matrix
nrn=nr;                        % Elements in ring n, starting with 1st

for g=1:1:nrg                  % Loop for rings
Circum=nrn*sr;
Radius=Circum/(2*pi);
Angr=2*pi/nrn;
fprintf('Ring %i comprising %i elements\n',g,nrn);
 for r=1:1:nrn                 % Loop for single ring
  index=index+1;
  Angn=(r-1)*(2*pi/nrn);       % Angle of element(n) on ring 
  Xoff=Radius*cos(Angn);       % X-offset
  Yoff=Radius*sin(Angn);       % Y-offset
  Zoff=0;                      % Z-offset
  Toff=[Xoff;Yoff;Zoff];       % Assemble offset matrix

  % Angle of element according to location on ring
  if strcmp(Efix,'no');
   ZR=rotz(-Angn-Erot_rad);
  else
   ZR=rotz(-Erot_rad);
  end
  
  Trot=ZR;   % Rotation matrix for E-rotation
 
  % Add element number (elnumber+index-1) to array_config
  % Defining : Rotation, Offset and Excitation for elements
  array_config(:,:,(elnumber+index-1))=[Trot,Toff,Texc]; 
 end
 nrn=round(((Radius+srng)*2*pi)/sr); % Number of elements in next ring  
end
fprintf('Total number of elements = %i\n',index);
centre_array; % Centre array in global coord system
