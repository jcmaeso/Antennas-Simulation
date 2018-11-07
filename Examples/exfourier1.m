% FOURIER SYNTHESIS EXAMPLE1 (exfourier1)
%
% The example shows the use of fourier1.m for beam synthesis.
%
% This type of synthesis is generally used for flat-top sector
% coverage patterns. Although more complex pattern profiles are 
% possible, the resulting element excitations can result in very
% inefficient use of the array aperture. Basically many of the 
% elements end up at very low power levels. 
%
% See inside this file to change element numbers, spacing and
% synthesis profile.
%
% See help file for fourier1.m for more details.

close all;
clc;
help exfourier1

init;

freq_config=1e9;
lambda=velocity_config/freq_config;
dipoleg_config=[lambda*0.5,lambda*0.25];   
             
Dx=0.5*lambda;
N=12;
% Define Array Geometry
% N-element array
rect_array(N,1,Dx,0,'dipoleg',90); 

% Some example pattern profiles, comment in/out as required. 

Angle=[-90 -30 -30 +30 +30  90];
PwrdB=[-50 -50  0   0  -50 -50];

%Angle=[-90  -60  -60  -30  -30   +40  +40  +60  +60  +90];
%PwrdB=[-50  -50   0    0   -20   -20   0    0   -50  -50];

%Angle=[-90  -20  -20  +30  +30  +90];
%PwrdB=[-50  -50  -20    0  -50  -50];


Profile=[Angle;PwrdB];                                         % Construct the beam profile array

[Lin_Volts,Phase_Rad,theta,FnValdB] = fourier1(N,Dx,Profile);  % Calculate the Fourier coefficients

array_config(1,5,:)=Lin_Volts;                                 % Load the amplitudes directly into array_config
array_config(2,5,:)=Phase_Rad;                                 % Load the phases directly into array_config
list_array(0);

plot_geom3d(1,0);
plot_theta(-90,1,90,[0],'tot','first');   

figure(2);
hold on;
plot(theta,FnValdB,'b');                                        % Plot the intended beam profile
hold off;

