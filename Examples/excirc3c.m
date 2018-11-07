% CIRCULARLY POLARISED ARRAY (excirc3c)
% 
% A (4x1) element Right-Hand Circularly polarised array
%
% Circularly polarised using the cpol_array function.
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

help excirc3c;

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

rect_array(M,N,xspc*lambda,yspc*lambda,'patchr',0);      % Construct 1st (M by N) Array

%taywin_array(20,'x');                                   % Apply amplitude taper in x-direction
%squint_array(20,0,1);                                   % Steer array to (theta,phi)

cpol_array(-90,-90,0);                                   % Circularly polarise the array


list_array(0);
plot_geom3d(1,0)

calc_directivity(5,10);
plot_theta(-90,2,90,[0,90],'rhcp','none');
plot_pattern3d1(5,10,'rhcp','no',12);
plot_pattern3d1(5,10,'lhcp','no',13);
plot_pattern3d1(5,10,'ar','no',14);