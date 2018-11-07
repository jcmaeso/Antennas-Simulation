% ORBITAL ANGULAR MOMENTUM EX2 (exoam2)
% 
% Example showing the use of a circular array to produce Orbital Angular Momentum (OAM)
% In this case the phase distribution across a square aperture is calculated, the receiving
% aperture is located in spherical coordinates relative to the OAM Tx array.
%
% The phase distribution across the aperture(s) of receiving antennas(s) may well be the
% key to using OAM to advantage in future communications systems.
%
% See OAM article in the additional documentation folder.

close all
clc
help exoam2

init;                              % Initialise global variables
dBrange_config=40;                 % Set dynamic range for plots
freq_config=2.4e9;                 % Set frequency (Hz)
lambda=3e8/(freq_config);          % Calculate wavelength (m)

% Location of Rx aperture
R=0.2;         % Radial distance of aperture from centre of radiating antenna element (m)
theta=50;      % Theta direction (Deg)
phi=-20;       % Phi direction (Deg)
% Aperture dimensions
Xdim=lambda/2; % X-Aperture dimension
Ydim=lambda/2; % Y-aperture dimension




% Patch parameters
Er=3.43;           % Relative dielectric constant Rogers RO4350
h=0.76e-3;         % Substrate thickness (m)

% Calculate dimensions for a rectangular patch using above parameters.
patchr_config=design_patchr(Er,h,freq_config);   % Use design_patchr to assign the patchr_config params
                                                       
%*********************************
% Circular Array paramters (ring1)
%*********************************
nr1=8;               % Number of elements in 1st ring (integer)
nrg=1;               % Number of rings (integer)
r=lambda*0.55;       % Radius of 1st ring (m) 
srng=lambda*0.5;     % Spacing between rings (m)
eltype='patchr';     % Element type (string). 'patchr' or 'patchc' or 'dipoleg'
Erot=90;             % E-plane rotation about Z-axis (Deg) 
Efix='yes';          % E-plane rotation with ring angle (string)
Mode=2;              % Array operation mode (OAM) Values 0,1,2....

 % Options for Efix are :
 % 
 %              'yes' - Fixed E-plane rotation as defined by Erot
 %              'no'  - Rotate with ring angle, starting at Erot              
                 
% Array configuration
circum=2*pi*r;       % Circular array 1st ring circumference
sr=circum/nr1;       % Spacing of element around 1st ring
circ_array(nr1,nrg,sr,srng,eltype,Erot,Efix);             % Define the array 
 
% Define element excitations (El_num, El_pwr(volts^2 in dB), El_phase (deg)) 
% The array default is El_pwr=0 and El_phase=0 for all elements, but can be
% defined manually, see below.

AngleInc=(2*Mode*pi/nr1)*180/pi;  % Phase angle increment in degrees

for i=1:nr1
  excite_element(i,0,(nr1-i)*AngleInc);
end;

yrot_array(-90,1,99); % Orientate the array boresight along x-axis
norm_array;           % Normalise array excitations to unity

% *****************************  Plot patterns *****************************
% **************************************************************************

plot_geom3d(1,0);      % Plot 3D geometry with axis (uses standard figure1)
plot_geom3d1(1,1,20);  % Plot 3D geometry with axis and element excitations in figure 20
view([90,0]);          % Select view
axis auto;             % Autoscale axes
list_array(0);         % List the array x,y,z locations and excitations only
calc_directivity(5,5);
plot_theta(-180,2,180,[0],'tot','none');                % Plot tot theta pattern -180 to +180 deg in 2deg steps phi=0
plot_phi(-180,2,180,[90],'tot','none');                 % Plot tot phi pattern -180 to +180 deg in 2deg steps theta=90


% ******** Field slice plot #1 *********

% Intermediate calculations
[xo,yo,zo]=sph2cart1(R,(theta)*pi/180,phi*pi/180);  % Calculate offset distances for slice
Theta=-theta;                                       % Theta value for use in plot_field_slice
Phi=-phi;                                           % Phi value for use in plot_field_slice

% Plot_field_slice parameters
xrng=Xdim; % Dimension of slice in local x-direction (m) 
yrng=Ydim; % Dimension of slice in local y-direction (m)
xsteps=20; % Number of steps in x (m)
ysteps=20; % Number of steps in y (m)
xrot=0;        % Rotation about x-axis (deg) 
yrot=Theta;    % Rotation about y-axis (deg)
zrot=Phi;      % Rotation about z-axis (deg)
xoff=xo;     % Offset in x (m)
yoff=yo;     % Offset in y (m)
zoff=zo;     % Offset in z (m)
polarisation='phase';   % Plot parameter (string)
normalise='yes';        % Normalisation option (string)
units='wm2';            % Display units
fignum1=1;           % Figure for 3D display
fignum2=15;          % Figure for dedicated plot

[XGC,YGC,ZGC,XLC,YLC,ZLC,PlotData]=plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,1,15); 

% Fine tune plot views
figure(1);
axis('auto'); 
axis('equal');
view([90+phi,90-theta]); % Set 3D geom view to be normal to slice.
ax=axis;
axis(ax/1.2);            % Zoom in by 1.2x
% Modify the title for the 3D geometry plot
if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase');  % Plot data for ar,tau or phase options
  Tunit='Deg';
else
  Tunit='dB';
end 
Ttext=sprintf('3D Geometry \n%s Field Slice (%s)',upper(polarisation),Tunit);
title(Ttext);

figure(15);      
view([90,90]);  % Set slice view to be same orientation as 3D view

fprintf('\n\n');
fprintf('OAM mode = %g\n',Mode); 
fprintf('Rx aperture dimension %3.2f x %3.2f mm\n',Xdim*1000,Ydim*1000);
fprintf('Rx aperture location (R=%3.2f m,Theta=%3.2f,Phi=%3.2f Deg)\n',R,theta,phi);
