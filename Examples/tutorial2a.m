% TUTORIAL EXAMPLE 2A (tutorial2a)
%
% Define a vertically orientated half-wave dipole, operating at 1Ghz.
% Add a second diople spaced lambda/2 from the 1st, and centre the array.
%
% Then :
%
% Calculate Directivity (dBi)
% Plot Azimuth and Elevation patterns
%
% Except this time the results for the 1 and 2-dipole configurations
% are going to be overlaid on the same plot.

close all;
clc;

help tutorial2a

init;                      % This initialises all the configuration variables
freq_config=1e9;           % Set frequency to 1Ghz
lambda=3e8/freq_config;    % Define a variable for wavelength, this is not obligatory it’s
                           % just to make the script more readable

% ********  Geometry Construction for 1-dipole configuration ********

fprintf('\n\n  1-Dipole Array Construction and Pattern Calculations\n');
fprintf('  ====================================================\n');


dipole_config=[lambda/2];  % Configure the dipole (it requires only a single parameter of
                           % length).

single_element(0,0,0,'dipole',0,0);     % Place a single dipole at the origin, aligned by
                                        % default with the x-axis. The last 2 parameters 
                                        % define 0dB amplitude and 0deg phase.

yrot_array(90,1,1);                     % Rotate the dipole 90 deg around the y-axis to bring it to the vertical  




% ***** Calculate the 1-dipole pattern information ********

list_array(0);                       % List out the array definition at the Matlab prompt


D1Direc=calc_directivity(5,15);      % Calculate and store the directivity for the array using 5deg increments
                                     % in theta and 15deg increments in phi.


[D1Theta,D1ThetaPat]=calc_theta(-180,5,180,[0],'tot','no');    % Calc the Elevation pattern and store.
                                                               % -180 to +180 in 5deg steps, for phi=0deg.
                                                               %  (i.e. pattern the X-Z plane)


[D1Phi,D1PhiPat]=calc_phi(0,5,360,[90],'tot','no');     % Calc the Azimuth pattern and store.
                                                        % 0 to +360 in 5deg steps, for theta=90deg.
                                                        % (i.e. pattern the X-Y plane)

% *****************  End of 1-Dipole Calculations ********************


clear_array;  % Clear the existing array configuration


% *********  Geometry Construction for 2-dipole configuration ********


fprintf('\n\n  2-Dipole Array Construction and Pattern Calculations\n');
fprintf('  ====================================================\n');

single_element(0,0,0,'dipole',0,0);     % Place a single dipole at the origin, aligned by
                                        % default with the x-axis. The last 2 parameters 
                                        % define 0dB amplitude and 0deg phase.

yrot_array(90,1,1);              % Rotate the dipole 90 deg around the y-axis to bring it to the vertical  

movec_array(0,lambda/2,0,1,1);	 % Copy the 1st dipole and place the copy
                                 % lambda/2 along the x-axis

centre_array;                    % Centre the array on the global axes


list_array(0);                   % List out the array definition at the Matlab prompt




% ***** Calculate the 2-dipoles pattern information ********


D2Direc=calc_directivity(5,15);      % Calculate and store the directivity for the array using 5deg increments
                                     % in theta and 15deg increments in phi.


[D2Theta,D2ThetaPat]=calc_theta(-180,5,180,[0],'tot','no');    % Calc the Elevation pattern and store.
                                                               % -180 to +180 in 5deg steps, for phi=0deg.
                                                               %  (i.e. pattern the X-Z plane)


[D2Phi,D2PhiPat]=calc_phi(0,5,360,[90],'tot','no');     % Calc the Azimuth pattern and store.
                                                        % 0 to +360 in 5deg steps, for theta=90deg.
                                                        % (i.e. pattern the X-Y plane)


% *****************  End of 2-Dipoles Calculations ********************


% **********************  Construct the polar plots ********************

figure(3);
clf;
polaxis(-dBrange_config,15,5,15);                              % Set up polar axis (min(dB) max(dB) d(dB) d(Ang))

polplot(D1Theta,D1ThetaPat,-dBrange_config,'r','LineWidth',2); % Plot 1-dipole theta (EL) pattern
polplot(D2Theta,D2ThetaPat,-dBrange_config,'b','LineWidth',2); % Plot 2-dipoles theta (EL) pattern

plegend(0.78,0.14,'r','1-Dipole EL Pat');                      % 1-dipole EL pat label at screen coords               
plegend(0.78,0.11,'b','2-Dipoles EL Pat');                     % 2-dipoles EL pat label at screen coords   

textsc(-0.10,1.00,'Theta (EL) plots');                         % Title line1 at screen coords
textsc(-0.10,0.97,'Directivity (dBi)');                        % Title line2 at screen corrds


figure(4);
clf;
polaxis(-dBrange_config,15,5,15);                              % Set up polar axis (min(dB) max(dB) d(dB) d(Ang))

polplot(D1Phi,D1PhiPat,-dBrange_config,'r','LineWidth',2);     % Plot 1-dipole phi (AZ) pattern
polplot(D2Phi,D2PhiPat,-dBrange_config,'b','LineWidth',2);     % Plot 2-dipoles phi (AZ) pattern
  
plegend(0.78,0.14,'r','1-Dipole AZ Pat');                      % 1-dipole EL pat label at screen coords               
plegend(0.78,0.11,'b','2-Dipoles AZ Pat');                     % 2-dipoles EL pat label at screen coords   


textsc(-0.10,1.00,'Phi (AZ) plots');                           % Title line1 at screen coords
textsc(-0.10,0.97,'Directivity (dBi)');                        % Title line2 at screen corrds






