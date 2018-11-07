% ORBITAL ANGULAR MOMENTUM EX3 (exoam3)
% 
% Example showing the use of a circular array to produce Orbital Angular Momentum (OAM)
%
% Two circular arrays of 8 and 16 patches are excited with sequential phase to 
% produce Orbital Angular Momentum (OAM). In this example two 'modes' (+2 & +4) of excitation
% result in a conical shaped beam with null on bore-sight. The beam is linearly polarised
% but has a pair of rotating phase-fronts with different phase rotation rates.
%
% The 'modes' of operation can be changed on lines 74 and 107 of this example,
% and should satisfy the following : -N/2<mode<N/2
% Where : N     is the number of elements in the circular array.
%         mode  is an integer.
%
% The phase increment around the array is given by : PhaseInc=360*mode/N (Deg)
%
% Thus for an 8-element array the max/min values of mode are -3 and +3 respectively.
%
% Mode          Beam Characteristic         Phase Increment(Deg)
%  +3        3-arm ccw rotating RH spiral       +135
%  +2        2-arm ccw rotating RH spiral       +90
%  +1        1-arm ccw rotating RH spiral       +45
%   0        Standard spherical                  0 
%  -1        1-arm cw rotating LH spiral        -45
%  -2        2-arm cw rotating LH spiral        -90
%  -3        3-arm cw rotating LH spiral        -135
%
%     (Sense of rotation looking towards antenna)
%
% For the outer array of 16 patches the max/min values of mode are -7 & +7 respectively.
%
% OAM is of interest as an another means of introducing diversity into communications
% systems and thereby improving performance. Similar to the way orthogonal polarisations
% VP/HP or LHCP/RHCP allow frequency re-use and therefore increased channel capacity, 
% for a given bandwidth.
%
% If the circular array was a continuous, as opposed to discrete array elements there would
% in theory at least, be an infinite number of 'modes' available.
%
% See also exanim3 example.

close all
clc
help exoam3

init;                              % Initialise global variables
dBrange_config=40;                 % Set dynamic range for plots
freq_config=2.4e9;                 % Set frequency (Hz)
lambda=3e8/(freq_config);          % Calculate wavelength (m)

% Patch parameters
Er=3.43;           % Relative dielectric constant Rogers RO4350
h=0.76e-3;         % Substrate thickness (m)

% Calculate dimensions for a rectangular patch using above parameters.
patchr_config=design_patchr(Er,h,freq_config);   % Use design_patchr to assign the patchr_config params
                                                       
% Dipole over ground parameters
len=0.05*lambda;                 % Length (m)
h=0.25*lambda;                  % Height above ground (m)
dipoleg_config=[len,h];         % Define vector of parameters
dipole_config=len;

%*********************************
% Circular Array paramters (ring1)
%*********************************
nr1=8;              % Number of elements in 1st ring (integer)
nrg=1;              % Number of rings (integer)
r=lambda*0.5;       % Radius of 1st ring (m)
srng=lambda*0.5;    % Spacing between rings (m)
eltype='patchr';    % Element type (string). 'patchr' or 'patchc' or 'dipoleg'
Erot=90;            % E-plane rotation about Z-axis (Deg) 
Efix='yes';         % E-plane rotation with ring angle (string)
Mode=2;             % Array operation mode (OAM) Values 0,1,2....
ElePwr=0;           % Element power (dB)

 % Options for Efix are :
 % 
 %              'yes' - Fixed E-plane rotation as defined by Erot
 %              'no'  - Rotate with ring angle, starting at Erot              
                

% Array configuration
circ_array1(nr1,nrg,r,srng,eltype,Erot,Efix);             % Define the array 
 
% Define element excitations (El_num, El_pwr(volts^2 in dB), El_phase (deg)) 
% The array default is El_pwr=0 and El_phase=0 for all elements, but can be
% defined manually, see below.

AngleInc=(2*Mode*pi/nr1)*180/pi;  % Phase angle increment in degrees

for i=1:nr1
  excite_element(i,ElePwr,(nr1-i)*AngleInc);
end;


%*********************************
% Circular Array paramters (ring2)
%*********************************
nr2=16;             % Number of elements in 1st ring (integer)
nrg=1;              % Number of rings (integer)
r=lambda*1;         % Radius of 1st ring (m)
srng=lambda*0.5;    % Spacing between rings (m)
eltype='patchr';    % Element type (string). 'patchr' or 'patchc' or 'dipoleg'
Erot=90;            % E-plane rotation about Z-axis (Deg) 
Efix='yes';         % E-plane rotation with ring angle (string)
Mode=4;             % Array operation mode (OAM) Values 0,1,2....
ElePwr=-3;          % Element power (dB)

 % Options for Efix are :
 % 
 %              'yes' - Fixed E-plane rotation as defined by Erot
 %              'no'  - Rotate with ring angle, starting at Erot              
                 

% Array configuration
circ_array1(nr2,nrg,r,srng,eltype,Erot,Efix);             % Define the array 
 
% Define element excitations (El_num, El_pwr(volts^2 in dB), El_phase (deg)) 
% The array default is El_pwr=0 and El_phase=0 for all elements, but can be
% defined manually, see below.

AngleInc=(2*Mode*pi/nr2)*180/pi;  % Phase angle increment in degrees

for i=1:nr2
  excite_element(i+nr1,ElePwr,(nr2-i)*AngleInc);
end;

                                              
theta=0;     % Theta (Deg)
phi=0;       % Phi (Deg)
Elref=1;     % Element number to normalise phase to


yrot_array(-90,1,99); % Orientate the array boresight along x-axis
norm_array;           % Normalise array excitations to unity

% *****************************  Plot patterns *****************************
% **************************************************************************

plot_geom3d(1,0);      % Plot 3D geometry with axis (uses standard figure1)
view([45,30]);         % Select view
plot_geom3d1(1,1,20);  % Plot 3D geometry with axis and element excitations in figure 20
view([90,0]);          % Select view
axis auto;             % Autoscale axes
list_array(0);         % List the array x,y,z locations and excitations only
calc_directivity(5,10);

% ******** Field slice plot #1 *********

xrng=4*lambda;   % Dimension of slice in local x-direction 
yrng=8*lambda;   % Dimension of slice in local y-direction
xsteps=20;  % Number of steps in x direction
ysteps=40;  % Number of steps in y direction
xrot=0;      % Rotation about x-axis 
yrot=0;      % Rotation about y-axis
zrot=0;      % Rotation about z-axis
xoff=xrng/2;   % Offset in x 
yoff=0;        % Offset in y
zoff=0;        % Offset in z
polarisation='phase';   % Plot parameter
normalise='no';         % Normalisation option
units='dblossd';        % Display units
fignum1=1;              % Figure number for plot in global coordinates (numeric)
fignum2=21;             % Figure number for plot in local coordinates (numeric)

% Generate field-slice plots in global and local coordinates, fignum1 / fignum2   
plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,fignum1,fignum2);    


% ********* Field slice plot #2 **********
% Leave other field_slice input values the same as for plot #1 except for...

xrng=8*lambda;   % Dimension of slice in local x-direction 
yrng=8*lambda;   % Dimension of slice in local y-direction
xsteps=40;  % Number of steps in x direction
ysteps=40;  % Number of steps in y direction
yrot=90;
xoff=4*lambda;
fignum2=22;

% Generate field-slice plots in local and global coordinates, fignum1 / fignum2
plot_field_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
   xoff,yoff,zoff,polarisation,normalise,units,fignum1,fignum2);

% Fine tune the plots generated by plot_field_slice1 #2

figure(fignum1);   % Select the figure for the slice plot in global coordinates.
                   % In this case figure1 which already has the 3D array geometry on it.
axis auto;         % Autoscale axes
ax=axis;
axis(ax/1.0);      % Zoom in by 1.0x

% Modify the title for the 3D geometry plot
if strcmp(polarisation,'ar') | strcmp(polarisation,'tau') | strcmp(polarisation,'phase');  % Plot data for ar,tau or phase options
  Tunit='Deg';
else
  Tunit='dB';
end 
Ttext=sprintf('3D Geometry \n%s Field Slice (%s)',upper(polarisation),Tunit);
title(Ttext);


% Other 2D and 3D plots

plot_theta(-180,2,180,[0],'tot','none');                % Plot tot theta pattern -180 to +180 deg in 2deg steps phi=0
plot_phi(-180,2,180,[90],'tot','none');                 % Plot tot phi pattern -180 to +180 deg in 2deg steps theta=90
plot_pattern3d1(5,10,'phase','no',23);                  % Plot tot 3D pattern
view([45,30]);                                          % Select view
