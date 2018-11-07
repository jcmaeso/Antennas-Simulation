% CURRENT LOOP (exloop)
%
% Models a loop antenna with uniform current, using short 
% (lambda/10) dipoles.
%
% Within the file, the number of elements, dipole length and 
% radius of the loop maybe altered.
%
% Although the general aim of arraycalc is to use equation based
% models for resonant array elements e.g. patch, dipole etc. 
% Small, but finite versions of these elements can also be used to
% model larger structures with a particular current/field distribution.


close all
clc
help exloop

init;                              % Initialise global variables

freq_config=1e9;
lambda=3e8/freq_config;            % Calculate wavelength
dipole_config=lambda/10;           % Short dipole element

% Construct the array
N=12;                              % Number of short dipole elements
r=lambda*0.5;                      % Radius of loop (m)


pass=0;                            % Loop index
for seg=1:N                        % Loop through N elements
  xr=0;                            % Rotation about X-axis (Deg)
  yr=0;                            % Rotation about Y-axis (Deg)
  zr=-(pass/N)*360+90;             % Rotation about Z-axis (Deg)
  x=r*cos((pass/N)*2*pi);          % X-coord (m)
  y=r*sin((pass/N)*2*pi);          % Y-coord (m)
  z=0;                             % Z-coord (m)  
  place_element(seg,xr,yr,zr,...
             x,y,z,'dipole',0,0);
  pass=pass+1;                     % Segment number index
end

list_array(0);
plot_geom3d(1,0);
figure(1);
view(-37.5,30);
ax=axis;
axis(ax*1);

calc_directivity(5,15);
plot_theta(-180,5,180,[0,45,90],'tot','each');
plot_pattern3d(5,15,'tot','no');