% WAVE ANIMATION (exanim1)
% 
% Example showing how to animate waves using the plot_wave_anim.m function
%
% In this case two 2.4GHz isotropic sources are placed 4*lambda apart on the x-y plane.
% The waves propagating from each source interfere with each other, causing a pattern
% that you might see when raindrops fall into a still pond.
%
% Try changing the relative power and phase of the sources, see inside file.

close all
clc
help exanim1
init;                              % Initialise global variables
freq_config=2.4e9;                 % Set frequency (Hz)
lambda=3e8/(freq_config);          % Calculate wavelength (m)

% ******************** Array definition **********************
Pwr1=0;     % Power source 1 (dB)
Phase1=0;   % Phase source 1 (deg)

Pwr2=0;     % Power source 2 (dB)
Phase2=0;   % Phase source 2 (deg)

single_element(-lambda*2,0,0,'iso',Pwr1,Phase1);
single_element(+lambda*2,0,0,'iso',Pwr2,Phase2);

% ***************** End Array definition *********************

plot_geom3d1(1,1,24);  % Plot 3D geometry with axis and element excitations in figure 20
view([140,40]);        % Select view
axis equal;

% ******** Wave slice parameters *********

xrng=10*lambda; % Dimension of slice in local x-direction 
yrng=10*lambda; % Dimension of slice in local y-direction
xsteps=80;   % Number of steps in x
ysteps=80;   % Number of steps in y
xrot=0;        % Rotation about x-axis 
yrot=0;        % Rotation about y-axis
zrot=0;        % Rotation about z-axis
xoff=0;                   % Offset in x 
yoff=0;                   % Offset in y
zoff=0;                   % Offset in z
polarisation='tot';       % Plot parameter
fignum1=25;               % Figure number for the frames
fignum2=26;               % Figurenumber for the animation

% Plot movie frames and animate them, returning the frames in M
[M]=plot_wave_anim(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation,fignum1,fignum2);

