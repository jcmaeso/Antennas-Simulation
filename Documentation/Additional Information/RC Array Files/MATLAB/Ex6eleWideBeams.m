% 6 Element Array Wide beam Plots (ex6elewidebeams)
%

close all;
clc;
help ex6elewidebeams

init;

dBrange_config=30;
freq_config=1e9;
lambda=velocity_config/freq_config;

 ErRogers=3.48;
 hRogers=0.76e-3;
 ErFoam=1.00;
 hFoam=6e-3;
 hTotal=hFoam+hRogers;
 Ndiv=hTotal/hRogers;
 
 
 ErFoam_prop=ErFoam*(hFoam/hTotal)
 ErRogers_prop=ErRogers*(hRogers/hTotal)
 ErTotal=ErFoam_prop+ErRogers_prop
 
Er=ErTotal               % Dielectric constant for substrate
h=hTotal                 % Patch height (m) affects E & H plane beamwidth

patchr_config=design_patchr(Er,h,freq_config);        % Use design_patchr to assign the patchr_config


            
Dx=0.55*lambda;
N=6;
% Define Array Geometry
% N-element array
rect_array(N,1,Dx,0,'patchr',90); 

taywin_array(20.5,'x');

% Wide Beam -35 to +35 (70deg BW)
excite_element(1,-6.19,110);
excite_element(2,-1.88,110); 
excite_element(3,+0.00,0);
excite_element(4,+0.00,0); 
excite_element(5,-1.88,110);
excite_element(6,-6.19,110); 


list_array(0);
[thWB,PwrWB]=plot_theta(-90,1,90,[0],'tot','first');


% Ultra Wide Beam -45 to +45 (90deg BW)
excite_element(1,-6.19,45);
excite_element(2,-1.88,135); 
excite_element(3,+0.00,0);
excite_element(4,+0.00,0); 
excite_element(5,-1.88,135);
excite_element(6,-6.19,45); 

list_array(0);
[thUWB,PwrUWB]=plot_theta(-90,1,90,[0],'tot','first');

% Twin Beam -50 and +50 
excite_element(1,-6.19,180);
excite_element(2,-1.88,0); 
excite_element(3,+0.00,180);
excite_element(4,+0.00,0); 
excite_element(5,-1.88,180);
excite_element(6,-6.19,0); 


list_array(0);
[thTB,PwrTB]=plot_theta(-90,1,90,[0],'tot','first');

plot_geom3d(1,0);
 

figure(3);
clf;
polaxis(-dBrange_config,0,5,10);                               % Set up polar axis (min(dB) max(dB) d(dB) d(Ang))
polplot(thWB,PwrWB,-dBrange_config,'b','LineWidth',2);         % Plot Wide Beam pattern
polplot(thUWB,PwrUWB,-dBrange_config,'g','LineWidth',2);       % Plot Ultra Wide Beam pattern
polplot(thTB,PwrTB,-dBrange_config,'r','LineWidth',2);         % Plot Ultra Wide Beam pattern

%plegend(0.8,0.20,'b','Wide Beam');                             % WB Label at screen coords               
%plegend(0.8,0.17,'g','Ultra Wide Beam');                       % UWB Label at screen coords
%plegend(0.8,0.14,'r','Ultra Wide Beam');                       % UWB Label at screen coords

textsc(-0.10,1.00,'Wide Beam Patterns');                       % Title line1 at screen coords
textsc(-0.10,0.96,'Calculated ');                              % Title line2 at screen corrds


