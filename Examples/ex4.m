% HANSEN-WOODYARD SUPER DIRECTIVITY (ex4)
% 
% Shows the difference between the ordinary end-fire condition and
% the Hansen-Woodyard, increased directivity condition for a
% 6-element array of dipoles. Freq=300MHz
%
% The array has spatial inter-element phasing of 90 degrees
%
% For the ordinary end-fire condition the elements are phased :
% (-n*90) modulo 360 
% Where n is the element number.
%
% For the Hansen-Woodyard condition the elements are phased :
% (-n*(90+180/N)) modulo 360     
% Where n is the element number and N is the total number 
% of elements (N=6)
%
% Shows the use of array geometry manipulation using xrot_array. 
% Also lower level functions such as excite_element, polaxis, 
% polplot and calc_theta.


close all
clc

help ex4;

init;                      % Initialise global variables

lambda=3e8/freq_config;    % Calculate wavelength
N=6;                       % Number of elements

% Define Array Geometry
% 6-element dipole array
rect_array(1,N,0.25*lambda,0.25*lambda,'dipole',0);   % Define N-element dipole array along y-axis
xrot_array(90,1,N);                                   % Rotate the array around the x-axis by 90deg
                                                      % making the array vertical.
plot_geom3d(1,0);                                     % Plot 3D geometry including global axes

figure(1);                                            % Set up the view for the 3D geometry
view(-37.5,30);
ax=axis;                                              % Zoom in x2
axis(ax/2);



% Ordinary End-fire condition : 
% 90deg spatial and phase separation between elements.
fprintf('\n\nApply phase excitations for ordinary end-fire condition\n');
for n=1:N
 phase=mod((n-1)*90,360);                                % Calc the phase excitations for element (n)
 excite_element(n,0,phase);                               % Apply the excitation to element (n) 
end
ORDdirec=calc_directivity(5,15);                          % Calc directivity and store for use later
[ORDtheta,ORDpat]=calc_theta(-180,5,180,0,'tot','no');    % Calc pattern data and store for use later
fprintf('\n\n');


% Hansen-Woodyard increased directivity condition : 
% 90deg spatial and 90+180/N phase separation between elements.
fprintf('Apply phase excitations for Hansen-Woodyard condition\n');
for n=1:N
 phase=mod((n-1)*(90+180/N),360);                       % Calc the phase excitations for element (n)
 excite_element(n,0,phase);                              % Apply the excitation to element (n)
end
HWdirec=calc_directivity(5,15);                          % Calc directivity and store for use later
[HWtheta,HWpat]=calc_theta(-180,5,180,0,'tot','no');     % Calc pattern data and store for use later
fprintf('\n');


figure(3);
clf;
polaxis(-dBrange_config,15,5,15);                              % Set up polar axis (min(dB) max(dB) d(dB) d(Ang))
polplot(ORDtheta,ORDpat,-dBrange_config,'r','LineWidth',2);    % Plot Ord-Endfire patterns
polplot(HWtheta,HWpat,-dBrange_config,'b','LineWidth',2);      % Plot Hansen-Woodyard patterns
plegend(0.8,0.20,'r','Ord Endfire');                           % ORD Label at screen coords               
plegend(0.8,0.17,'b','H-Woodyard');                            % HW Label at screen coords
textsc(-0.10,1.00,'Theta Cuts for Phi=0');                     % Title line1 at screen coords
textsc(-0.10,0.97,'Directivity (dBi)');                        % Title line2 at screen corrds

