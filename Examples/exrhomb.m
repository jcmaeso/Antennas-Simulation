% RHOMBIC ARRAY (exrhomb)
%
% Example of Rhombic array
%
% 4x3 array of rectangular patches, X-Y spacing 0.7 lambda
% X-offset for alternate rows 0.35 lambda,
% Frequency 2.45GHz
%
% Theta plots for Phi=0 and 90 Degrees 


close all
clc

help exrhomb
    
init;                                                   % Initialise global variables
freq_config=2.45e9;                                     % Specify frequency
lambda=3e8/freq_config;                                 % Calculate wavelength
patchr_config=design_patchr(3.43,1.6e-3,freq_config);   % Use design_patchr to assign the patchr_config
                                                        % parameters.

% Array parameters
Nx=4;                                  % Number of elements in x-axis direction       
Ny=3;                                  % Number of elements in y-axis direction
Sx=0.7*lambda;                         % Spacing in x-axis direction
Sy=0.7*lambda;                         % Spacing in y-axis direction
Xoff=0.35*lambda;                      % Offset for alternate rows in x
Yoff=0.0*lambda;                       % Offset for alternate rows in y
Ang=0;                                 % Angle of elements - 
                                       % (+ve rotation about z-axis, measured from x-axis in Deg)

% Define array geometry                                       
rhomb_array(Nx,Ny,Sx,Xoff,Sy,Yoff,'patchr',0);  % Define 4x3 array of patches over g-plane
list_array(0);                                  % List the array x,y,z locations and excitations only 


% Plotting and visualisation
plot_geom3d(1,0);                               % Plot the array geometry in 3D, plots will be added
                                                % to this view by the plot_theta command
plot_geom3d1(1,0,20);                           % 3D geom plot (figure 20)
plot_geom2d(0,1);                               % Plot array geom in 2D anotating elements with excitations
plot_theta(-90,2,90,[0,90],'tot','first');      % Plot theta patterns for phi=0 and 90deg 



% Fine tune the 3D views
figure(20);
AX=axis;
axis(AX/1.5);
view(60,30);

figure(1);
AX=axis;
axis(AX/1.5);
view(60,30);
