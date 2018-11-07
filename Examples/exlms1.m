% LEAST MEAN SQUARE OPTIMISATION (exlms1)
%
% This type of optimisation / beam synthesis is used to steer the array's 
% main lobe in the direction of the wanted signal and place nulls in the 
% direction of the interferers.
%
% This example is for an 8 element array with a wanted signal at theta=10,phi=0
% and 2 interferers at theta=50,phi=0 and theta=-10,phi=0. See inside this file 
% for details.
%
% This method relies on knowing in advance the direction of the desired signals 
% and interferers. It is not an Angle Of Arrival (AOA) estimation algorithm.
%
% This example and the code in lmsoptimise.m function (beam_synthesis directory) 
% has been adapted for ArrayCalc from 'Smart Antennas for Wireless Communications
% with Matlab' by Frank Gross, published by McGraw-Hill.



help exlms1


init;                      % Initialise global variables

freq_config=300e6;
lambda=3e8/freq_config;    % Calculate wavelength

% Array Parameters

M=8;       % Number of elements in X-direction
N=1;       % Number of elements in Y-direction
xspc=0.5;  % Array spacing in the X-direction
yspc=0.5;  % Array spacing in the Y-direction

rect_array(M,N,xspc*lambda,yspc*lambda,'iso',0);         % Construct 1st (M by N) Array


signal=[10,0];   % Wanted signal direction    [theta,phi] 
inter1=[50,0];   % Direction of interferer #1 [theta,phi]
inter2=[-10,0];  % Direction of interferer #2 [theta,phi]
mu=0.01;         % Step size for optimisation

lmsoptimise(signal,[inter1; inter2],mu);

list_array(0);
plot_geom3d(1,0);
plot_theta(-90,1,90,[0,90],'tot','each');