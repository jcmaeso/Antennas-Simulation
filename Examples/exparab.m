% SIMPLE PARABOLIC REFLECTOR MODEL (exparab)
%
% Parabolic reflector approximation using isotropic sources.
%
% The sources are placed such that they lie on the parabolic surface.
% The phase of each source is then determined by calculating the distance 
% between it and the feed point. A Taylor distribution is applied to give
% some degree of amplitude taper (specified to give approx -12dB at dish edge).
%
% The approximation is used to explore beam scanning by linear translation of the 
% feed perpendicular to the dish axis. Feed postions are plotted as f1,f2 and f3
% on the 3D geometry plot.
%
% Feed position f1 : Feed is at the focus.
% Feed position f2 : Feed is displaced 100mm from the focus in the +ve x-axis direction.
% Feed position f3 : Feed is displaced 200mm from the focus in the +ve x-axis direction.
% 
% Displacing the feed in the +ve x-axis direction causes the beam to be squinted
% in opposite direction. Note the merging of the 1st sidelobe with the main beam
% in the direction of the squint and increasing 1st sidelobe on the other side.  
%
% This is the method by which satellite TV dishes use multiple heads to target
% multiple satellites using a single dish. 
% Nominal dish specification : 
%
% Frequency 2.45GHz
% Diameter 800mm
% Offset 400mm
% Focal Length 500mm
% F/D 0.625
%
% Note the majority of satellite tv systems (Europe) operate at around 12GHz.
% This model will work at higher frequencies but the number of sources required
% increases considerably, making calculation times longer. The sampling
% point separation (variable: XYstep) can be as sparse as 1*lambda. However,
% this will limit the angle over which the patterns can be plotted before grating
% lobes appear.
%
% For more rapid and detailed reflector/horn analysis consider using ICARA
% from the University of Vigo in Spain. 
% (Internet search for 'ICARA Refector Design')
%
% Or SABOR from the Technical University of Madrid. 
% (Internet search for 'SABOR Refector Design')

close all
clc

init;                                  % Initialise global variables

% Parabolic dish parameters
freq_config=2.45e9;                    % Define frequency (Hz)
lambda=3e8/freq_config;                % Calculate wavelength (m)
F=500e-3;                              % Parabola focal length (m)
TWF=22.5;                              % Use Taylor window to give amplitude taper
                                       % select TWF to give approx -12dB at dish edge

PaXcen=0e-3;      % Projected aperture centre X-coordinate (m)
PaYcen=400e-3;    % Projected aperture centre Y-coordinate (m)

Xap=800e-3;       % Projected aperture X-dimension (m)
Yap=800e-3;       % Projected aperture Y-dimension (m)

XYstep=lambda/3;         % Stepping distance to sample aperture (m)

TWF=22.5;                % Use Taylor window to give amplitude taper
                         % select TWF to give approx -12dB at dish edge
% Feed translations
fx1=0;                   % Feed x-coordinate for 1st pattern calculation (m)
fx2=100e-3;              % Feed x-coordinate for 2nd pattern calculation (m)
fx3=200e-3;              % Feed x-coordinate for 3rd pattern calculation (m)

% Plotting parameters
minth=-50;     % Min theta (deg)
maxth=50;      % Max theta (deg)
stepth=1;      % Step theta (deg)



minXap=PaXcen-Xap/2;  % Minimum X-coord of projected aperture (m)
maxXap=PaXcen+Xap/2;  % Maximum X-coord of projected aperture (m)

minYap=PaYcen-Yap/2;  % Minimum Y-coord of projected aperture (m)
maxYap=PaYcen+Yap/2;  % Maximum Y-coord of projected aperture (m)

% Modify the limits slightly so that the sample points form a 
% symmetrical grid on the reflector surface

minXap=round(minXap/XYstep)*XYstep;
maxXap=round(maxXap/XYstep)*XYstep;

minYap=round(minYap/XYstep)*XYstep;
maxYap=round(maxYap/XYstep)*XYstep;



% Calc pattern for feed position 1
% ********************************

% Feed Position 1
fx=fx1;              % Feed X-coordinate (m)
fy=0;                % Feed Y-coordinate (m)
fz=F;                % Feed Z-coordinate (m)

% Array element parameters
Pwr=0;                   % Initialise power level variable for elements
Pha=0;                   % Initialise phase level variable for elements

for x=minXap:XYstep:maxXap                          % Step through x-coordinates
 for y=minYap:XYstep:maxYap                         % Step through y-coordinates
  xr1=(x-PaXcen);                            % x-coord relative to projected aperture centre
  yr1=(y-PaYcen);                            % y-coord relative to projected aperture centre
  r1=sqrt(xr1.^2+yr1.^2);                    % Radial distance from centre of projected aperture to point x,y
  ang1=atan2(xr1,yr1);                       % Angle from centre of aperture to point x,y

  xr2=(Xap/2).*sin(ang1);
  yr2=(Yap/2).*cos(ang1);                    % Point on aperture periphery in direction ang1
  r2=sqrt(xr2.^2+yr2.^2);                    % Radial distance from centre of projected aperture to periphery point
  
  if r1<r2                                   % Decide whether point lies within the specified aperture
   z=(x.^2+y.^2)/(4*F);                      % Calculate z-coordinate for parabola
   f2p=sqrt((fx-x).^2+(fy-y).^2+(fz-z).^2);  % Calculate distance from focal point to parabolic surface, f2p
   Pha=(f2p./(lambda))*360;                  % Calculate the appropriate phase excitation, based on f2p distance
   single_element(x,y,z,'iso',Pwr,Pha);      % Place the element 
  end
 end
end
taywin_array(TWF,'xy');                      % Modify the amplitude taper to give approx -12dB at dish edge


plot_geom3d(1,0);                            % Plot the array geometry in 3D, no global axes
view([35,10]);

[F1theta,F1pat]=plot_theta_geo1(minth,stepth,maxth,[0],'tot','yes','r-',1);  % Plot and store pattern for feed point f1                                                                


% Calc pattern for feed position 2
% ********************************


% Feed Position 2
fx=fx2;              % Feed X-coordinate (m)
fy=0;                % Feed Y-coordinate (m)
fz=F;                % Feed Z-coordinate (m)

indx=0;
for x=minXap:XYstep:maxXap                          % Step through x-coordinates
 for y=minYap:XYstep:maxYap                         % Step through y-coordinates
  xr1=(x-PaXcen);
  yr1=(y-PaYcen);
  r1=sqrt(xr1.^2+yr1.^2); 
  ang1=atan2(xr1,yr1);  

  xr2=(Xap/2).*sin(ang1);
  yr2=(Yap/2).*cos(ang1);
  r2=sqrt(xr2.^2+yr2.^2);
  
  if r1<r2
   z=(x.^2+y.^2)/(4*F);                      % Calculate z-coordinate for parabola
   f2p=sqrt((fx-x).^2+(fy-y).^2+(fz-z).^2);  % Calculate distance from focal point to parabolic surface, f2p
   Pha=(f2p./(lambda))*360;                  % Calculate the appropriate phase excitation, based on f2p distance
   indx=indx+1;                              % increment index (element number)
   excite_element(indx,Pwr,Pha);             % Set element excitation
  end
 end
end
taywin_array(TWF,'xy');                      % Modify the amplitude taper to give approx -12dB at dish edge


[F2theta,F2pat]=plot_theta_geo1(minth,stepth,maxth,[0],'tot','yes','g-',1);  % Plot and store pattern for feed point f2

% Calc pattern for feed position 3
% ********************************
 

% Feed Position 3
fx=fx3;              % Feed X-coordinate (m)
fy=0;                % Feed Y-coordinate (m)
fz=F;                % Feed Z-coordinate (m)

indx=0;
for x=minXap:XYstep:maxXap                          % Step through x-coordinates
 for y=minYap:XYstep:maxYap                         % Step through y-coordinates
  xr1=(x-PaXcen);
  yr1=(y-PaYcen);
  r1=sqrt(xr1.^2+yr1.^2); 
  ang1=atan2(xr1,yr1);  

  xr2=(Xap/2).*sin(ang1);
  yr2=(Yap/2).*cos(ang1);
  r2=sqrt(xr2.^2+yr2.^2);
  
  if r1<r2
   z=(x.^2+y.^2)/(4*F);                      % Calculate z-coordinate for parabola
   f2p=sqrt((fx-x).^2+(fy-y).^2+(fz-z).^2);  % Calculate distance from focal point to parabolic surface, f2p
   Pha=(f2p./(lambda))*360;                  % Calculate the appropriate phase excitation, based on f2p distance
   indx=indx+1;                              % increment index (element number)
   excite_element(indx,Pwr,Pha);             % Set element excitation
  end
 end
end
taywin_array(TWF,'xy');                      % Modify the amplitude taper to give approx -12dB at dish edge


[F3theta,F3pat]=plot_theta_geo1(minth,stepth,maxth,[0],'tot','yes','b-',1);  % Plot and store pattern for feed point f3


figure(20);
plot(F1theta,F1pat,'r','linewidth',2);
hold on;
plot(F2theta,F2pat,'g','linewidth',2);
plot(F3theta,F3pat,'b','linewidth',2);
hold off;
grid on;
zoom on;
xlabel('Theta Degrees');
ylabel('dB');
T1=sprintf('Beam Scan vs Feed Displacement F=%gmm Xap=%gmm Yap=%gmm @%gGhz',F*1000,Xap*1000,Yap*1000,freq_config/1e9);
title(T1)

T2=sprintf('f1 dx %gmm',fx1*1000);
T3=sprintf('f2 dx %gmm',fx2*1000);
T4=sprintf('f3 dx %gmm',fx3*1000); 
plegend(0.6,0.97,'r',T2);                                     
plegend(0.6,0.94,'b',T3);  
plegend(0.6,0.91,'m',T4);

figure(1);
text(fx1,0,F,'f1');
text(fx2,0,F,'f2');
text(fx3,0,F,'f3');
axis auto;

help exparab

