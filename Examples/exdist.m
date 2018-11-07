% COMPARISON OF AMPLITUDE DISTRIBUTIONS (exdist)
% 
% Shows the difference between Modified Taylor, Chebyshev and
% Binomial distributions on an 8-element patch array.
%
% The sidelobe reduction for the the Taylor and Chebyshev arrays
% is set at 30dB down with respect to the main beam.
%
% The Binomial distribution , by definition has zero power sidelobes

close all
clc

help exdist;

init;                      % Initialise global variables

arrayeff_config=100;       % Set array efficiency is set to 100% (plots are labeled in dBi)
freq_config=2.45e9;        % Specify frequency (Hz)
lambda=3e8/freq_config;    % Calculate wavelength (m)
patchr_config=design_patchr(3.43,1.6e-3,freq_config);


N=8;                       % Number of elements
Spc=0.65;                  % Element spacing as aproportion of lambda
SLL=30;                    % Sidelobe reduction (dB w.r.t main beam)

% Define Array Geometry
% N-element patch array
rect_array(N,1,Spc*lambda,Spc*lambda,'patchr',0); 
plot_geom3d(1,0);

figure(1);
view(-37.5,30);
ax=axis;
axis(ax/2);

list_array(0);

% Modified Taylor Distribution
fprintf('\nTAYLOR DISTRIBUTION');
[LinVolt,TAYdB]=modtaylor(N,SLL);
array_config(1,5,:)=LinVolt;


TAYdirec=calc_directivity(5,15);
[TAYtheta,TAYpat]=calc_theta(-90,1,90,0,'tot','no');
fprintf('\n\n');


% Chebychev Distribution
fprintf('\nCHEBYSHEV DISTRIBUTION');
[LinVolt,CHBdB]=chebwin1(N,SLL);
array_config(1,5,:)=LinVolt;

CHBdirec=calc_directivity(5,15);
[CHBtheta,CHBpat]=calc_theta(-90,1,90,0,'tot','no');
fprintf('\n\n');


% Binomial Distribution
fprintf('\nBINOMIAL DISTRIBUTION');
[LinVolt,BINdB]=binomial1(N);
array_config(1,5,:)=LinVolt;

BINdirec=calc_directivity(5,15);
[BINtheta,BINpat]=calc_theta(-90,1,90,0,'tot','no');
fprintf('\n\n');


% POLAR PLOTS
figure(3);
clf;
polaxis(-dBrange_config,20,5,15);
polplot(TAYtheta,TAYpat,-dBrange_config,'r','LineWidth',2);
polplot(CHBtheta,CHBpat,-dBrange_config,'b','LineWidth',2);
polplot(BINtheta,BINpat,-dBrange_config,'g','LineWidth',2);
plegend(0.8,0.20,'r','Taylor');
plegend(0.8,0.17,'b','Chebyshev');
plegend(0.8,0.14,'g','Binomial');
textsc(-0.10,1.00,'Theta Cuts for Phi=0');
textsc(-0.10,0.97,'Directivity (dBi)');

% RECTANGULAR PLOTS
figure(4);
clf;
hold on;
plot(TAYtheta,TAYpat,'r-','LineWidth',2);
plot(CHBtheta,CHBpat,'b-','LineWidth',2);
plot(BINtheta,BINpat,'g-','LineWidth',2);

plot(TAYtheta,TAYpat,'r-',CHBtheta,CHBpat,'b-',BINtheta,BINpat,'g-');
legend('Taylor','Chebyshev','Binomial'); 
axis([-90 90 -dBrange_config,20]);
title('Amplitude Taper Comparison for Patch Array');
xlabel('Theta (degrees)');
ylabel('Directivity (dBi)');
grid on;

textsc(0.05,0.97,'Theta Cuts for Phi=0');
textsc(0.05,0.93,'Directivity (dBi)');

fprintf('Element TAYamp(dB) CHBamp(dB) BINamp(dB) \n');
for n=1:N
  fprintf('%5i%10.2f%11.2f%11.2f',n,TAYdB(n,1),CHBdB(n,1),BINdB(n,1)); 
  fprintf('\n'); 
end


