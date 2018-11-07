% 6 Element Array Scanned Beam Plots (ex6elescanbeams)
%

close all;
clc;
help ex6elescanbeams

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


squint_array(-45,0,1);
list_array(0);
[thm45,Pwrm45]=plot_theta(-90,1,90,[0],'tot','first');


squint_array(-30,0,1);
list_array(0);
[thm30,Pwrm30]=plot_theta(-90,1,90,[0],'tot','first');


squint_array(-15,0,1);
list_array(0);
[thm15,Pwrm15]=plot_theta(-90,1,90,[0],'tot','first');


squint_array(0,0,1);
list_array(0);
[th0,Pwr0]=plot_theta(-90,1,90,[0],'tot','first');


squint_array(15,0,1);
list_array(0);
[thp15,Pwrp15]=plot_theta(-90,1,90,[0],'tot','first');


squint_array(30,0,1);
list_array(0);
[thp30,Pwrp30]=plot_theta(-90,1,90,[0],'tot','first');


squint_array(45,0,1);
list_array(0);
[thp45,Pwrp45]=plot_theta(-90,1,90,[0],'tot','first');




plot_geom3d(1,0);
 

figure(3);
clf;
polaxis(-dBrange_config,0,5,10);                               % Set up polar axis (min(dB) max(dB) d(dB) d(Ang))
hold on;
polplot(thm45,Pwrm45,-dBrange_config,'m','LineWidth',2);       % Plot -45 Deg pattern
polplot(thm30,Pwrm30,-dBrange_config,'g','LineWidth',2);       % Plot -30 Deg pattern
polplot(thm15,Pwrm15,-dBrange_config,'r','LineWidth',2);       % Plot -15 Deg pattern
polplot(th0,Pwr0,-dBrange_config,'b','LineWidth',2);           % Plot  0  Deg pattern
polplot(thp15,Pwrp15,-dBrange_config,'r','LineWidth',2);       % Plot +15 Deg pattern
polplot(thp30,Pwrp30,-dBrange_config,'g','LineWidth',2);       % Plot +30 Deg pattern
polplot(thp45,Pwrp45,-dBrange_config,'m','LineWidth',2);       % Plot +45 Deg pattern

textsc(-0.10,1.00,'Scan Beam Patterns');                       % Title line1 at screen coords
textsc(-0.10,0.96,'Calculated');                               % Title line2 at screen corrds

hold off;

