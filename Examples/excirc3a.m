% CIRCULARLY POLARISED ARRAY  (excirc3a)
% 
% A (4x1) element Right-Hand Circularly polarised array
%
% This method constructs one circularly polarised element
% using basic commands and then builds an array from them. 
%
% 
% Array uses the following rectangular element.
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

help excirc3a;

init;                      % Initialise global variables

freq_config=2.45e9;        % Specify frequency
lambda=3e8/freq_config;    % Calculate wavelength

patchr_config=design_patchr(3.43,1.6e-3,freq_config);

% Array Parameters

M=4;       % Number of elements in X-direction
N=1;       % Number of elements in Y-direction
T=M*N;     % Total number of circ-pol elements
xspc=0.8;  % Array spacing in the X-direction
yspc=0.8;  % Array spacing in the Y-direction


% Construct Circularly Polarised Array Element

single_element(0,0,0,'patchr',0,0);
single_element(0,0,0,'patchr',0,-90);
zrot_array(-90,2,2);

for m=1:M-1                   % Make M-1 copies of element in X-direction
 dx=(m*xspc*lambda);          % Forming the first row of the array
 movec_array(dx,0,0,1,2);
end

for n=1:N-1                   % Make N-1 copies of the 1st row in Y-direction
 dy=(n*yspc*lambda);          % Completing the array
 movec_array(0,dy,0,1,(2*M));
end

centre_array;



list_array(0);
plot_geom3d(1,0)

calc_directivity(2,15);
plot_theta(-90,1,90,[0,90],'rhcp','none');
%plot_pattern3d(2,15,'tot','no')