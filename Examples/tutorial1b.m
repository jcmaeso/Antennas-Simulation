% TUTORIAL EXAMPLE 1B (tutorial1b)
%
% Define a vertically orientated half-wave dipole, operating at 1Ghz.
% Add a second diople spaced lambda/2 from the 1st, and centre the array.
%
% Then :
%
% Calculate Directivity (dBi)
% Plot Azimuth and Elevation patterns
% Plot 3D pattern as a mesh and overlay geometry

close all;
clc;

help tutorial1b

init;                      % This initialises all the configuration variables
freq_config=1e9;           % Set frequency to 1Ghz
lambda=3e8/freq_config;    % Define a variable for wavelength, this is not obligatory it’s
                           % just to make the script more readable

% ********  Geometry Construction ********

dipole_config=[lambda/2];  % Configure the dipole (it requires only a single parameter of
                           % length).

single_element(0,0,0,'dipole',0,0);     % Place a single dipole at the origin, aligned by
                                        % default with the x-axis. The last 2 parameters 
                                        % define 0dB amplitude and 0deg phase.

yrot_array(90,1,1);              % Rotate the dipole 90 deg around the y-axis to bring it to the vertical  

movec_array(0,lambda/2,0,1,1);	 % Copy the 1st dipole and place the copy
                                 % lambda/2 along the x-axis


centre_array;                    % Centre the array on the global axes


% The array_config matrix now contains the 2-dipole array description.



% ***** Plotting and Visualisation ********

list_array(0);             % List out the array definition at the Matlab prompt
plot_geom3d(1,1);          % Display the array geometry together with axis, ampl and phase

% Matlab commands to fine tune the view for this example
view(30,30);               % Orientate 3D view to see dipole more easily
AX=axis;                   % Store 3D axis settings in AX
axis(AX/2);                % Zoom in by 2x on 3D plot

calc_directivity(5,15);    % Calulate the directivity for the array using 5deg increments
                           % in theta and 15deg increments in phi.


plot_theta(-180,5,180,[0],'tot','none');     % Plot the Elevation pattern, a theta pattern from
                                             % -90 to +90 in 5deg steps, for phi=0deg.
                                             %  (i.e. pattern the X-Z plane)


plot_phi(0,5,360,[90],'tot','none');         % Plot the Azimuth pattern, a phi pattern from
                                             % 0 to +360 in 5deg steps, for theta=90deg.
                                             % (i.e. pattern the X-Y plane)

plot_geopat3d(5,15,'tot','no','mesh',4); % Plot 3D pattern as a mesh with array geometry overlaid. 

% ***********  End of Script **************

