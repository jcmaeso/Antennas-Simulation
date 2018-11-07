% SPIN-LINEAR PLOTS (exspinlin1)
%
% This example shows a pair of crossed dipoles excited in phase quadrature to produce
% RHCP in the +X-axis direction. (ref excirc1)
% 
% When practical measurements are made in antenna test ranges there are various ways of 
% measuring antennas that are circularly polarised. One method is called 'Spin-Linear'.
% This involves mounting the test antenna on the rotator (e.g. Phi rotation about global
% z-axis in this case). The radiated field is then measured using a suitable dipole that
% rotates about an axis normal to that of the rotator (the global x-axis in this case). 
% The rotation rate is arbitrary, but much greater than that of the Phi rotation.
%
%
%                +Z
%                 |  <- Rotator, rotates AUT about Z-axis 
%                 |     (The axis set remains fixed)
%                 
%                 +  <- Antenna Under Test (AUT), circularly polarised
%                 +
%             +++++++++ _______ +Y    
%                 +               
%                 + \      
%                    \
%                     \
%                     +X
%                           / 
%                          /
%                        /\\  
%                       /  \\ <- Receive dipole rotates about fixed X-axis
%                                at a rate greater than the rotator.
%
% The dipole effectively 'traces out' the polarisation ellipse (axes are Emajor and Eminor). 
% The result is a plot that oscillates between the EmajorGain and the EminorGain. For perfect
% circular polarisation (Emajor=Eminor) the spin-linear trace will peak at 3dB below the 
% Co-polar (e.g. RHCP). The 3dB is due to the polarisation mismatch loss between perfect 
% linear and perfect circular polarisation. The difference between the max and min values
% of the pattern oscillations is the axial ratio in dB :  
%                          
%                              AR(dB)=20*log10(abs(Emajor)/abs(Eminor)) 
%
% In the Spin-Linear polar plot, the RHCP radiation pattern is in the +Xaxis (theta=90,phi=0)
% direction and shows good axial ratio performance (small oscillation amplitude) in the direction
% of propagation. Although there is very little RHCP signal in the -Xaxis direction, the 
% spin-linear has the same response as in the +Xaxis direction, why? Try selecting 'lhcp' as the 
% plot option in lines 76 & 77
%
% Also, try experimenting with the physical orientation and phasing of the dipoles to see the effect
% it has on axial ratio.
%
%
close all
clc

help exspinlin1

init;

freq_config=1.0e9;                                      % Set frequency (Hz)
lambda=velocity_config/freq_config;                     % Calculate lambda (m)
dBrange_config=60;                                      % Dynamic range for standard plots (dB)
arrayeff_config=99.9;                                   % Set array efficiency, just less than 100% so gain is plotted

dipole_config=lambda/2;
single_element(0,0,0,'dipole',0,0);   % 1st dipole
single_element(0,0,0,'dipole',0,-90); % 2nd dipole (phase 90deg lagging)
zrot_array(-90,2,2);                  % Rotate the 2nd dipole 90 deg
yrot_array(-90,1,2);                  % Rotate the whole array to put RHCP propagation direction along X-axis
                                                      
list_array(0);                     % List the array elements
norm_array;                        % Normalise linear array excitations such that they sum to unity.                              
list_array(0);                     % List the array elements

plot_geom3d(1,0);                           % Plot 3D geometry
view([35,40]);                              % Set view angle [AZ,EL]
calc_directivity(5,5);                      % Calculate directivity d(theta)=5deg , d(phi)=5deg
plot_theta(-180,2,180,[0],'rhcp','none');   % Plot total power theta pattern -180 to +180 deg in 2deg steps
plot_phi(-180,2,180,[90],'rhcp','none');    % Plot total power phi pattern -180 to +180 deg in 2deg steps


% Collect raw data for the Spin-Linear calculations
% *************************************************

[phi,Emulti]=phi_cut(-180,0.2,180,90);     % Pattern cut in phi -90 to +90deg in 0.2deg steps for theta=90deg     

PhiTOT=Emulti(:,1);     % Extract the Total pattern data from returned matrix (linear) 
PhiVP=Emulti(:,2);      % Extract the Vertical component pattern data from returned matrix (linear)
PhiHP=Emulti(:,3);      % Extract the Horizontal component pattern data from returned matrix (linear)
PhiLHCP=Emulti(:,4);    % Extract the LHCP component pattern data (linear)
PhiRHCP=Emulti(:,5);    % Extract the RHCP component pattern data (linear)
PhiAR=Emulti(:,6);      % Extract the AR data (linear)
PhiPHAVP=Emulti(:,9);   % Extract the VP Phase data (deg)
PhiPHAHP=Emulti(:,10);  % Extract the HP Phase data (deg)


% Calculate the Emajor and Eminor of the polarisation ellipse.
% Theory of operation document APPENDIX A for equations.

dg=(PhiPHAVP-PhiPHAHP)*pi/180;                               % Calculate delta gamma
Evp=PhiVP;
Ehp=PhiHP;

F1=Ehp.^2+Evp.^2;					                               % Intermediate calculation
F2=(Ehp.^4+Evp.^4+2.*(Ehp.^2).*(Evp.^2).*cos(2.*dg)).^0.5;   % Intermediate calculation
Emajor=sqrt(0.5*(F1+F2))+1e-9;                               % Emajor, Major axis of polarisation ellipse
Eminor=sqrt(0.5*(F1-F2))+1e-9;                               % Eminor, Minor axis of polarisation ellipse

RotRate=100;                      % Rate of rotation of probe antenna relative rotator's phi angle
DipoleAng=RotRate.*phi.*pi/180;   % Dipole rotation angle (radians).


% Normalise each data set and add in directivity
norm=normd_config-direct_config;  % Normalisation factor uses factor to normalise raw data (normd_config)
                                  % to 0dB, see init.m. Also the directivity value itself to give the directivity
                                  % or gain, depending on whether there are losses.  
PhiTOTgain=20*log10(PhiTOT)-norm;     
PhiLHCPgain=20*log10(PhiLHCP)-norm;   
PhiRHCPgain=20*log10(PhiRHCP)-norm;   
EmajorGain=20*log10(abs(Emajor))-norm;
EminorGain=20*log10(abs(Eminor))-norm;

% Spin-Linear oscillates between the Emajor and Eminor gain values.
PhiSPINLINgain=abs(EmajorGain-EminorGain).*(sin(DipoleAng).*0.5-0.5)+EmajorGain;

% Axial ratio plot for reference
figure(25);
plot(phi,20*log10(1./PhiAR),'r','linewidth',2);
axis([min(phi),max(phi),0,10]);
grid on;
zoom on;
xlabel('Phi Angle (Deg)');
ylabel('Axial Ratio (dB)');
title('AR Plot (dB)');
chartname=sprintf('Axial Ratio dB');
set(25,'name',chartname);


% Rectangular Spin-Linear Plot
figure(26);
clf;
p1=plot(phi,PhiSPINLINgain,'r','linewidth',2);
hold on;
p2=plot(phi,PhiTOTgain,'b','linewidth',2);
p3=plot(phi,PhiRHCPgain,'m','linewidth',2);
p4=plot(phi,PhiLHCPgain,'m:','linewidth',2);
p5=plot(phi,EmajorGain,'color',[0,0.5,0],'linestyle','-','linewidth',2);
p6=plot(phi,EminorGain,'color',[0,0.5,0],'linestyle',':','linewidth',2);
axis([min(phi),max(phi),-40,10]);
xlabel('Phi Angle (Deg)');
ylabel('Gain dB');
title('RHCP Crossed Dipole Antenna');
legend([p1,p2,p3,p4,p5,p6],'Spin Linear','Total Field','RHCP Gain','LHCP Gain','Emaj Gain','Emin Gain',3);
grid on;
zoom on;
chartname=sprintf('Spin-Linear Rect');
set(26,'name',chartname);

% Polar Spin-Linear plot
figure(27);
clf;
polaxis(-40,10,5,15);
polplot(phi,PhiSPINLINgain,-40,'r','linewidth',2);
polplot(phi,PhiRHCPgain,-40,'b','linewidth',2);
Ttitle=['Phi RHCP and Spin-Linear Gain Plots (th=90)'];
textsc(-0.25,1.05,Ttitle);
Tfreq=sprintf('Freq %g MHz',freq_config/1e6);
textsc(-0.25,0,Tfreq);
chartname=sprintf('Spin-Linear Polar');
set(27,'name',chartname);

plot_pattern3d1(10,10,'rhcp','no',28);
plot_pattern3d1(10,10,'ar','no',29);

figure(27);
