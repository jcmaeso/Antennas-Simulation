% CIRCULARLY POLARISED ARRAY (excirc3b)
%
% A (4x1) element Right-Hand Circularly polarised array
%
% This method constructs the array using the standard rect_array
% command. Then, all array elements are duplicated, rotating
% each element by -90deg about its local Z-axis and applying a 
% phase lag of 90deg.
%
% The advantage with this approach is that all the usual array
% construction commands rect_array, cylin_array, squint_array etc
% can be used first, then the array 'circularly polarised' at the 
% end.
%
% This process has been put into a function cpol_array, see excirc3c.m
% 
% Single rectangular patch
% Freq = 2.45GHz
% Er   = 3.43 (Rogers 4350)
% h    = 1.6mm
%
% In practice the patch would normally be square but the 
% rectangular patch makes it easier to see how the geometry is 
% constructed.


close all
clc

help excirc3b;

init;                      % Initialise global variables

freq_config=2.45e9;        % Specify frequency
lambda=3e8/freq_config;    % Calculate wavelength

patchr_config=design_patchr(3.43,1.6e-3,freq_config);

% Array Parameters

M=4;       % Number of elements in X-direction
N=1;       % Number of elements in Y-direction
T=M*N;     % Total number of circ-pol elements
xspc=0.6;  % Array spacing in the X-direction
yspc=0.6;  % Array spacing in the Y-direction

rect_array(M,N,xspc*lambda,yspc*lambda,'patchr',0);     % Construct 1st (M by N) Array

%taywin_array(20,'x');                                   % Apply amplitude taper in x-direction
%squint_array(20,0,1);                                   % Steer array to (theta,phi)


% Parameters for 2nd Array of orthogonal elements

dRot=-90;  % Rotation -90deg
dPha=-90;  % Phase lag 90 Deg
dAmp=0;    % No change to amplitude weights

ZR=rotz(dRot*pi/180);    % Define rotation matrix

% Duplicate the array elements with appropriate changes to the 
% element orientations and phases

for elnum=1:T
  array_config(1:3,1:3,elnum+T)=array_config(1:3,1:3,elnum)*ZR;    % Rotate element about its local z-axis
  array_config(:,4,elnum+T)=array_config(:,4,elnum);               % Copy offsets from 1st array
  array_config(1,5,elnum+T)=array_config(1,5,elnum)*10^(dAmp/20);  % Change amplitude, if required
  array_config(2,5,elnum+T)=array_config(2,5,elnum)+dPha*pi/180;   % Change the phase, usually by pi/2
  array_config(3,5,elnum+T)=array_config(3,5,elnum);               % Copy element type from 1st array
end


list_array(0);
plot_geom3d(1,0)

calc_directivity(2,15);
plot_theta(-90,1,90,[0,90],'rhcp','none');
%plot_pattern3d(2,15,'tot','no')