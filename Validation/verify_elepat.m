% Simple plotting routine to plot raw element model data.
% Used for diagnostics only.

init;

velocity_config=3e8;
freq_config=1e9;
lambda=velocity_config/freq_config;


% Dipoles
dipole_config=lambda/2;
dipoleg_config=[lambda/2,lambda/4];

% Patches
Er=3.43;
h=0.76e-3;
patchr_config=design_patchr(Er,h,freq_config);
patchc_config=design_patchc(Er,h,freq_config);

% Apertures
aprect_config=[lambda*4,lambda*0.5];
apcirc_config=lambda*3;

% Waveguides
wgr_config=[0.653*lambda,0.327*lambda];
wgc_config=lambda*0.7;

% Dish
Diam=5;
Taper=2;
Edge=10;
dish_config=[Diam,Taper,Edge];

% Helix
Turns=6;
helix_config=design_helix(Turns,freq_config);

phi=0*pi/180;
m=0;

thetamin=-90;
thetastep=0.5;
thetamax=90;

theta=thetamin:thetastep:thetamax;
for th=thetamin*pi/180 : thetastep*pi/180 : thetamax*pi/180
   m=m+1;
   Pdipole(m,1)=dipole(th,phi);
   Pdipoleg(m,1)=dipoleg(th,phi);
   
   Ppatchr(m,1)=patchr(th,phi);
   Ppatchc(m,1)=patchc(th,phi);
   
   Pwgr(m,1)=wgr(th,phi);
   Pwgc(m,1)=wgc(th,phi);
   
   Pdish(m,1)=dish(th,phi);
   Phelix(m,1)=helix(th,phi);
   
   Paprect(m,1)=apcirc(th,phi);
   Papcirc(m,1)=apcirc(th,phi);
end   

maxPdipole=max(Pdipole)
maxPdipoleg=max(Pdipoleg)

maxPpatchr=max(Ppatchr)
maxPpatchc=max(Ppatchc)

maxPaprect=max(Paprect)
maxPapcirc=max(Papcirc)

maxPwgr=max(Pwgr)
maxPwgc=max(Pwgc)

maxPdish=max(Pdish)
maxPhelix=max(Phelix)


close all
figure(1);
plot(theta,Pdipole);
title('Dipole')
set(gcf,'name','Dipole');
axis([-90,90,0,1]);

figure(2);
plot(theta,Pdipoleg);
title('Dipoleg')
set(gcf,'name','Dipoleg');
axis([-90,90,0,1]);

figure(3);
plot(theta,Ppatchr);
title('Patchr')
set(gcf,'name','Patchr');
axis([-90,90,0,1]);

figure(4);
plot(theta,Ppatchc);
title('Patchc')
set(gcf,'name','Patchc');
axis([-90,90,0,1]);

figure(5);
plot(theta,Pwgr);
title('Wgr')
set(gcf,'name','Wgr');
axis([-90,90,0,1]);

figure(6);
plot(theta,Pwgc);
title('Wgc')
set(gcf,'name','Wgc');
axis([-90,90,0,1]);

figure(7);
plot(theta,Pdish);
title('Dish')
set(gcf,'name','Dish');
axis([-90,90,0,1]);

figure(8);
plot(theta,Phelix);
title('Helix')
set(gcf,'name','Helix');
axis([-90,90,0,1]);

figure(9);
plot(theta,Paprect);
title('Rect Aperture')
set(gcf,'name','Aprect');
axis([-90,90,0,1]);

figure(10);
plot(theta,Phelix);
title('Circ Aperture')
set(gcf,'name','Apcirc');
axis([-90,90,0,1]);

