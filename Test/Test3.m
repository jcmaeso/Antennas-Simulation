clear clc
init;                      % Initialise global variables

freq_config=7.804e9;        % Specify frequency
lambda=3e8/freq_config;    % Calculate wavelength

AngBarrido=deg2rad([-37.5,-18.75,0,18.75,37.5]);

alpha=-2*pi*0.5*cos(AngBarrido);        % Desfasaje necesario
alpha = alpha(1);
patchr_config=design_patchr(3.43,1.6e-3,freq_config);

% Array Parameters

M=20;       % Number of elements in X-direction
N=20;       % Number of elements in Y-direction
T=M*N;     % Total number of circ-pol elements
xspc=0.5;  % Array spacing in the X-direction
yspc=0.5;  % Array spacing in the Y-direction

alphac = 0;
for i = 0:1:(M-1)
    alphac = rad2deg(2*pi*i*0.65*sin(deg2rad(15)));
    single_element(i*xspc*lambda,0,0,'patchr',0,alphac);
end
 
centre_array;
plot_geom3d(1,0);
[thetaMax,phiMax] = calc_directivity(1,15);
plot_theta(-90,0.1,90,[0,90],'tot','none');