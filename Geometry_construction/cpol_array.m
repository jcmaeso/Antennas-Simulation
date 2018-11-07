function cpol_array(Zrot,dPha,dAmp)
% Circularly polarise existing array
%
% Usage: cpol_array(Zrot,dPha,dAmp)
%
% Zrot....Rotation about element local Z-axis (Deg)
% dPha....Relative phase change for each element (Deg)
% dAmp....Relative amplitude change for each element (dB)
%
% This function duplicates all existing array elements and
% then applies relative changes to orientation, phase and 
% amplitude as listed above.
%
% Example     Rectangular right-hand circularly polarised array
%
%             rect_array(8,1,0.8,0,'dipoleg',0);       % Define (8 by 1) array
%             taywin_array(20,'x');                    % Amplitude taper, if required
%             squint_array(15,0,1);                    % Steer the array, if required
%             cpol_array(-90,-90,0);                   % Generate the orthogonal elements for RHCP
%
% For LHCP use cpol_array(+90,-90,0)

global array_config;

[Trow,Tcol,N]=size(array_config);    % Number of elements in array N

% Parameters for 2nd Array of orthogonal elements

dR=Zrot*pi/180;   % Convert Z-axis rotation to (radians)
dP=dPha*pi/180;   % Convert relative phase change to (radians)
dA=10^(dAmp/20);  % Convert relative amplitude change to (linear)

ZR=rotz(dR);      % Define rotation matrix

% Duplicate the array elements with appropriate changes to the 
% element orientations and phases

fprintf('Duplicating all array elements,  dZrot=%3.2f Deg, dPha=%3.2f Deg, dPwr=%3.2f dB\n',...
         Zrot,dPha,dAmp);

for elnum=1:N
  array_config(1:3,1:3,elnum+N)=array_config(1:3,1:3,elnum)*ZR;    % Rotate element about its local z-axis
  array_config(:,4,elnum+N)=array_config(:,4,elnum);               % Copy offsets from 1st array
  array_config(1,5,elnum+N)=array_config(1,5,elnum)*dA;            % Change amplitude, if required
  array_config(2,5,elnum+N)=array_config(2,5,elnum)+dP;            % Change the phase, usually by pi/2
  array_config(3,5,elnum+N)=array_config(3,5,elnum);               % Copy element type from 1st array
end