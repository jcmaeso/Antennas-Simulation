% DIFFERENT ULTRASOUND TRANSDUCER DIAMETERS (extransducer)
% 
% Shows the sound intensity patters for different diameters of
% circular ultrasound transducers using the 'apcirc' element model,
% assuming an infinite baffle.
%
close all
clc

help extransducer;

init;                      % Initialise global variables


freq_config=40e3;                      % Specify frequency (Hz)
velocity_config=1522;
lambda=velocity_config/freq_config;    % Calculate wavelength (m)
dBrange_config=30;

% 1 Lambda Diameter Circular Transducer
fprintf('\n1 LAMBDA DIAMETER\n');
apcirc_config=1*lambda;
single_element(0,0,0,'apcirc',0,0)

%LAM1direc=calc_directivity(5,15);
[LAM1theta,LAM1pat]=calc_theta(-90,1,90,0,'tot','yes');
fprintf('\n\n');
clear_array;

% 2 Lambda Diameter Circular Transducer
fprintf('\n2 LAMBDA DIAMETER\n');
apcirc_config=2*lambda;
single_element(0,0,0,'apcirc',0,0)

%LAM2direc=calc_directivity(5,15);
[LAM2theta,LAM2pat]=calc_theta(-90,1,90,0,'tot','yes');
fprintf('\n\n');
clear_array;

% 4 Lambda Diameter Circular Transducer
fprintf('\n4 LAMBDA DIAMETER\n');
apcirc_config=4*lambda;
single_element(0,0,0,'apcirc',0,0)

%LAM4direc=calc_directivity(5,15);
[LAM4theta,LAM4pat]=calc_theta(-90,1,90,0,'tot','yes');
fprintf('\n\n');
clear_array;

% 10 Lambda Diameter Circular Transducer
fprintf('\n10 LAMBDA DIAMETER\n');
apcirc_config=10*lambda;
single_element(0,0,0,'apcirc',0,0)

%LAM10direc=calc_directivity(5,15);
[LAM10theta,LAM10pat]=calc_theta(-90,1,90,0,'tot','yes');
fprintf('\n\n');
clear_array;


% POLAR PLOTS
figure(3);
clf;
polaxis(-dBrange_config,0,5,15);
polplot(LAM1theta,LAM1pat,-dBrange_config,'r','LineWidth',2);
polplot(LAM2theta,LAM2pat,-dBrange_config,'b','LineWidth',2);
polplot(LAM4theta,LAM4pat,-dBrange_config,'g','LineWidth',2);
polplot(LAM10theta,LAM10pat,-dBrange_config,'c','LineWidth',2);
plegend(0.8,0.20,'r','1 Lambda');
plegend(0.8,0.17,'b','2 Lambda');
plegend(0.8,0.14,'g','4 Lambda');
plegend(0.8,0.11,'c','4 Lambda');
textsc(-0.10,1.00,'Theta Cuts for Phi=0');
textsc(-0.10,0.97,'Relative Level (dB)');

% RECTANGULAR PLOTS
figure(4);
clf;
hold on;
p1=plot(LAM1theta,LAM1pat,'r-','LineWidth',2);
p2=plot(LAM2theta,LAM2pat,'b-','LineWidth',2);
p3=plot(LAM4theta,LAM4pat,'g-','LineWidth',2);
p4=plot(LAM10theta,LAM10pat,'c-','LineWidth',2);

legend([p1,p2,p3,p4],'1 Lambda','2 Lambda','4 Lambda','10 Lambda'); 
axis([-90 90 -dBrange_config,0]);
title('Pattern comparison for various diameters of circular ultrasound transducers');
xlabel('Theta (degrees)');
ylabel('Relative Level (dB)');
grid on;

textsc(0.05,0.97,'Theta Cuts for Phi=0');
textsc(0.05,0.93,'Relative Level (dB)');

