% WAVE ANIMATION (exanim2)
% 
% Example showing how to animate waves using the plot_wave_anim.m function
%
% 4-element 2.4GHz array of circular patches with mechanical bore-sight aligned
% with y-axis. Array is phased to steer main beam 20deg off y-axis (theta=90,phi=90+20)
% Element spacing is 0.7 lambda along the x-axis.
%
% Note how the waves start as distinct entities infront of each array element, eventually
% merging to form circular (slice through spherical wave) wavefronts, as the waves move 
% away into the far-field.


close all
clc
help exanim2
init;                              % Initialise global variables

freq_config=2.45e9;                                     % Specify frequency
lambda=3e8/freq_config;
patchc_config=design_patchc(3.43,1.6e-3,freq_config);   % Use design_patchc to assign the patchc_config
                                                        % parameters.

% ******************** Array definition **********************

rect_array(4,1,(0.7*lambda),(0.7*lambda),'patchc',0);   % Define a 4 x 1 array of circular patches
xrot_array(90,1,99);                                    % Orientate the array boresight along y-axis
squint_array(90,90+20,1);                               % Squint array 20deg from y-axis

% ***************** End Array definition *********************

plot_geom3d1(1,1,24);  % Plot 3D geometry with axis and element excitations in figure 20
view([140,40]);        % Select view
axis equal;

% ******** Wave slice parameters *********

xrng=8*lambda; % Dimension of slice in local x-direction 
yrng=8*lambda; % Dimension of slice in local y-direction
xsteps=40;  % Number of steps in x
ysteps=40;  % Number of steps in y
xrot=0;        % Rotation about x-axis 
yrot=0;        % Rotation about y-axis
zrot=0;        % Rotation about z-axis
xoff=0;                   % Offset in x 
yoff=4*lambda;            % Offset in y
zoff=0;                   % Offset in z
polarisation='tot';       % Plot parameter
fignum1=25;               % Figure number for the frames
fignum2=26;               % Figurenumber for the animation

% Plot movie frames and animate them, returning the frames in M
[M]=plot_wave_anim(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation,fignum1,fignum2);

