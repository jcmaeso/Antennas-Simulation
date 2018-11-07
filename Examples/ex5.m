% 3-SECTOR VERTICAL ARRAY (ex5)
%
% Shows the use of geometry construction commands to construct
% a 3-sector vertical array of horizontal dipoles. Freq = 1GHz
%
% To achieve down tilt on each sector, a single array is defined
% and squinted. Then it is rotate-copied to produce the complete
% structure.

close all
clc

help ex5

init;                    % Initialise global variables

freq_config=1e9;
lambda=3e8/freq_config;  % Calculate wavelength

% Dipole over ground parameters
len=0.5*lambda;          % Length (m)
h=0.25*lambda;           % Height above ground (m)
dipoleg_config=[len,h];  % Define vector of parameters


% Construct the array
N=6;
rect_array(1,N,0,0.7*lambda,'dipoleg',0);  % 6-element array of dipoles along the y-axis
squint_array(15,90,1);                     % Squint array to theta=15(deg), phi=0(deg), ref elmnt 1
move_array(0,0,0.2,1,N);                   % Move whole array up the Z-axis by 0.5m (radius for sector rotation)
yrotc_array(120,1,N);                      % Rotate copy the original array (els 1-6) 120(deg) around the X-axis
yrotc_array(-120,1,N);                     % Rotate copy the original array (els 1-6) -120(deg) around the X-axis
xrot_array(90,1,999);                      % Rotate the whole array 90deg around the x-axis

list_array(0);
plot_geom3d(1,0);
figure(1);
view(-37.5,30);
ax=axis;
axis(ax/1.5);

plot_theta(-180,2,180,[90],'tot','first');
plot_phi(-180,2,180,[105],'tot','first');