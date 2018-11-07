function cylin_array(nr,nh,sr,sh,eltype,Erot)
% Define a cylindrical array
%
% Usage: cylin_array(nr,nh,sr,sh,eltype,Erot)
%
% nr......Number of elements in each ring (integer)
% nh......Number of rings (integer)
% sr......Element spacing around the cylinder surface (m)
% sh......Spacing between rings (m)
% eltype..Element type (string)
% Erot....E-plane angle from Z-axis (deg)
%
% e.g. cylin_array(6,2,(0.7*lambda),(0.7*lambda),'patchr',0)
%                
%       |sr|                   
%       #  |               #----      # = cylindrical array element
%          #            #     sh
%       #      #    #      #----      Z   
%          #            #             |  Y
%       #      #    #      #          | /     
%          #            #             |/
%              #    #                 ----->X
%                                     Axis Orientation
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
 

fprintf('Constructing cylindrical array %i elements per ring, %i rings\n',nr,nh);

Erot_rad=Erot*pi/180;        % Element E-plane orientation rel to Z-axis

Trot=[1 0 0                  % Initialise rotation matrix as 'identity'
      0 1 0                  % (zero rotation)
      0 0 1]; 

Amp=1;                       % Set amplitude to 1 for all elements
Pha=0;                       % Set phase to 0 for all elemnts

[Elt]=eltcode(eltype);       % Assign numeric code for element type 

Texc=[Amp;Pha;Elt];          % Assemble last column of 3x5 element matrix

Circum=nr*sr;
Radius=Circum/(2*pi);
Angr=2*pi/nr;


% Construction of the Trot rotation matrix for the cylindrical
% array elemnts
%
% Step1 ... +ve rotation of 90deg about Y-axis, defined by YR
%            puts the plane of the element parallel to Z-axis
%
% Step2 ... +ve rotation of 360/nr Deg about X-axis, defined by XR
%            orientates the element according location on ring
%
% Step3 ... -ve rotation of Erot_rad about Z-axis, defined by ZR
%            this defines the E-plane orientation.



% ZR and YR will be the same for all elements

% E-plane orientation
ZR=rotz(-Erot_rad);

% Rotate to parallel with Z-axis
YR=roty(pi/2);

index=0;                       % Define element positions using the offset matrix
for h=1:1:nh
 for r=1:1:nr
  index=index+1;
  Angn=(r-1)*(2*pi/nr);        % Angle of element(n) on cylinder 
  Xoff=Radius*cos(Angn);       % X-offset
  Yoff=Radius*sin(Angn);       % Y-offset
  Zoff=(h-1)*sh;               % Z-offset
  Toff=[Xoff;Yoff;Zoff];       % Assemble offset matrix

  % Angle of element according to location on ring
  XR=rotx(-Angn-pi);
  
  Trot=YR*XR*ZR;               % Assemble rotation matrix 
 
  % Add element number (index+elnumber-1) to array_config
  % Defining : Rotation, Offset and Excitation for elements
  array_config(:,:,(index+elnumber-1))=[Trot,Toff,Texc]; 
 end
end
centre_array; % Centre array in global coord system
