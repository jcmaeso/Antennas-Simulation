% WAVE ANIMATION (exanim3)
% 
% Example showing how to animate waves using the plot_wave_anim.m function.
%
% A circular array of 8 patches is excited with sequential phase to produce
% Orbital Angular Momentum (OAM). This 'mode' of excitation results in a
% conical shaped beam with a null on bore-sight. The beam is linearly polarised
% but has a rotating wavefront.
%
% The 'mode' of operation can be changed on line 64 of this example,
% and should satisfy the following : -N/2<mode<N/2
% Where : N     is the number of elements in the circular array.
%         mode  is an integer.
%
% The phase increment around the array is given by : PhaseInc=360*mode/N (Deg)
%
% Thus for this 8-element array the max/min values of mode are -3 and +3 respectively.
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
% OAM is of interest as an another means of introducing diversity into communications
% systems and thereby improving performance. Similar to the way orthogonal polarisations
% VP/HP or LHCP/RHCP allow frequency re-use and therefore increased channel capacity, 
% for a given bandwidth.
%
% If the circular array was a continuous, as opposed to discrete array elements, there would
% be an infinite number of 'modes' available, in theory.
%
% See also exoam example.

close all
clc
help exanim3
init;                              % Initialise global variables
freq_config=2.4e9;                 % Set frequency (Hz)
lambda=3e8/(freq_config);          % Calculate wavelength (m)

% Patch parameters
Er=3.43;           % Relative dielectric constant Rogers RO4350
h=0.76e-3;         % Substrate thickness (m)

% Calculate dimensions for a rectangular patch using above parameters.
patchr_config=design_patchr(Er,h,freq_config);   % Use design_patchr to assign the patchr_config params

% ******************** Array definition **********************

% Circular Array paramters (ring1)
nr1=8;               % Number of elements in 1st ring (integer)
nrg=1;               % Number of rings (integer)
r=lambda*0.55;       % Radius of 1st ring (m) 
srng=lambda*0.5;     % Spacing between rings (m)
eltype='patchr';     % Element type (string). 'patchr' or 'patchc' or 'dipoleg'
Erot=-90;            % E-plane rotation about Z-axis (Deg) 
Efix='yes';          % E-plane rotation with ring angle (string)
Mode=2;              % Array operation mode (OAM) Values 0,1,2....

 % Options for Efix are :
 % 
 %              'yes' - Fixed E-plane rotation as defined by Erot
 %              'no'  - Rotate with ring angle, starting at Erot              
                 
% Array configuration
circum=2*pi*r;                                     % Circular array 1st ring circumference
sr=circum/nr1;                                     % Spacing of element around 1st ring
circ_array(nr1,nrg,sr,srng,eltype,Erot,Efix);      % Define the array 

AngleInc=(2*Mode*pi/nr1)*180/pi;                   % Phase angle increment in degrees

for i=1:nr1
  excite_element(i,0,(nr1-i)*AngleInc);              % Set element excitations
end;

xrot_array(90,1,99);                               % Orientate the array boresight along y-axis

% ***************** End Array definition *********************

plot_geom3d1(1,1,24);  % Plot 3D geometry with axis and element excitations in figure 20
view([140,40]);        % Select view
axis equal;

% ******** Wave slice parameters *********

xrng=8*lambda; % Dimension of slice in local x-direction 
yrng=8*lambda; % Dimension of slice in local y-direction
xsteps=40;   % Number of steps in x direction
ysteps=40;   % Number of steps in y direction
xrot=90;       % Rotation about x-axis 
yrot=0;        % Rotation about y-axis
zrot=0;        % Rotation about z-axis
xoff=0;                   % Offset in x 
yoff=5*lambda;            % Offset in y
zoff=0;                   % Offset in z
polarisation='tot';       % Plot parameter
fignum1=25;               % Figure number for the frames
fignum2=26;               % Figurenumber for the animation

% Plot movie frames and animate them, returning the frames in M
[M]=plot_wave_anim(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation,fignum1,fignum2);


