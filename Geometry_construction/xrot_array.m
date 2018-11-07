function xrot_array(ang,elstart,elfinish)
% Rotate array geometry about x-axis, rotation is relative
% to the current orientation.
%
% Usage : xrot_array(ang,elstart,elfinish)
%
% ang.......Rotation angle (Deg)
%
% elstart...Start element number (1 to N) where N 
%           is the number of elements in the array
%
% elfinish..Finish element number (1 to N) where N
%           is the number of elements in the array.
%           For elfinish>N, elfinish is set equal to N
%
% +ve defined by RH screw rule, holding x-axis
% RH = +ve
% LH = -ve
%
%         z
%         |
%         |
%         |_____ y
%        /      
%       / 
%      x RH Screw towards origin   
%


global array_config

[Trow,Tcol,N]=size(array_config);  % Number of elements in array N

XROT=rotx(ang*pi/180);             % Get x-axis rotation matrix for angle specified

% initialise a unit coordinate system of 4 points

P1=[0;0;0];
P2=[1;0;0];
P3=[0;1;0];
P4=[0;0;1];

if elfinish>N
 elfinish=N;
end

if elstart<1
 elstart=1;
end

fprintf('Rotate elements %i to %i around X-axis by %3.2f Deg\n',...
         elstart,elfinish,ang);


for n=elstart:1:elfinish           % Over elstart to elfinish sources
  Amp=array_config(1,5,n);         % Amplitude of (n)th source (lin volts)
  Pha=array_config(2,5,n);         % Phase of (n)th source (radians)

  Trot=array_config(1:3,1:3,n);    % Element orientataion (rotation matrix)
  Toff=array_config(1:3,4,n);      % Element position (offset matrix)

  % Position unit coordinate system according to (nth) element rotation
  % and offset matrices. 
  P1ref=Trot*P1+Toff;
  P2ref=Trot*P2+Toff;
  P3ref=Trot*P3+Toff;
  P4ref=Trot*P4+Toff;
  
  % Rotate the unit coordinate system representing the (nth) element
  % to its new position using the XROT matrix.
  P1rot=XROT*P1ref;
  P2rot=XROT*P2ref;
  P3rot=XROT*P3ref;
  P4rot=XROT*P4ref;

  % There are now 4 points in two coordinate systems, global reference
  % and final array position.

  xyz1=[P1,P2,P3,P4];             % Assemble refrence points into matrix
  xyz2=[P1rot,P2rot,P3rot,P4rot]; % Assemble rotated points into matrix

  [RotOff]=coord2Troff(xyz1,xyz2);

  New_Trot=RotOff(1:3,1:3);
  New_Toff=RotOff(1:3,4);

  array_config(1:3,1:3,n)=New_Trot;
  array_config(1:3,4,n)=New_Toff;
end
