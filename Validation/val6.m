% VALIDATION EXAMPLE 6
%
% 4 tiers (0.8 lambda separation) of :
% 3 half-wave dipoles in free space, 45 deg to the vertical and
% spaced evenly around the Z-axis on radias of 0.4 lambda. Freq 300MHz
%
% Comparison with NEC model '3dipoles4t'
%
% The correlation in this example is reasonable, the mutual coupling
% between the tiers is responsible for the differences in sidelobe
% levels.


close all
clc

help val6

init;                    % Initialise global variables

freq_config=300e6;
lambda=3e8/freq_config;  % Calculate wavelength

% Dipole over ground parameters
len=0.5*lambda;          % Length (m)
h=0.25*lambda;           % Height above ground (m)
dipole_config=len;       % Define vector of parameters

% Construct the array
N=1;
rect_array(1,N,0,0,'dipole',-90);          % Place the dipole at 90 Deg to X-axis
xrot_array(-45,1,1);                       % Slant the dipole to 45 Deg
move_array(0.4,0,0,1,N);                   % Move whole array along the X-axis by 0.4m (radius for sector rotation)
zrotc_array(120,1,N);                      % Rotate copy the original element 120(deg) around the Z-axis
zrotc_array(-120,1,N);                     % Rotate copy the original element 120(deg) around the Z-axis
movec_array(0,0,1*0.8,1,3);                % Tier2
movec_array(0,0,2*0.8,1,3);                % Tier3
movec_array(0,0,3*0.8,1,3);                % Tier4
list_array(0);
plot_geom3D(1,0);

% THETA CUTS
fprintf('0 Deg theta cut \n');
[theta0,Emulti0]=theta_cut(-180,2,180,0);
fprintf('45 Deg theta cut \n');
[theta45,Emulti45]=theta_cut(-180,2,180,45);
fprintf('90 Deg theta cut \n');
[theta90,Emulti90]=theta_cut(-180,2,180,90);

% PHI CUTS
fprintf('30 Deg phi cut \n');
[phi30p,Emulti30p]=phi_cut(0,2,360,30);
fprintf('60 Deg phi cut \n');
[phi60p,Emulti60p]=phi_cut(0,2,360,60);
fprintf('90 Deg phi cut \n');
[phi90p,Emulti90p]=phi_cut(0,2,360,90);




% THETA PATTERNS
%***** TOTAL POL *****
Acalc0=Emulti0(:,1);
Acalc0dB=20*log10(Acalc0);            % Convert to dB
Acalc0dBnT=Acalc0dB-max(Acalc0dB);

Acalc45=Emulti45(:,1);
Acalc45dB=20*log10(Acalc45);          % Convert to dB
Acalc45dBnT=Acalc45dB-max(Acalc45dB);

Acalc90=Emulti90(:,1);
Acalc90dB=20*log10(Acalc90);          % Convert to dB
Acalc90dBnT=Acalc90dB-max(Acalc90dB);

%***** VERTICAL POL *****
Acalc0=Emulti0(:,2);
Acalc0dB=20*log10(Acalc0);            % Convert to dB
Acalc0dBnV=Acalc0dB-max(Acalc0dB);

Acalc45=Emulti45(:,2);
Acalc45dB=20*log10(Acalc45);          % Convert to dB
Acalc45dBnV=Acalc45dB-max(Acalc45dB);

Acalc90=Emulti90(:,2);
Acalc90dB=20*log10(Acalc90);          % Convert to dB
Acalc90dBnV=Acalc90dB-max(Acalc90dB);

%***** HORIZ POL *****
Acalc0=Emulti0(:,3);
Acalc0dB=20*log10(Acalc0);            % Convert to dB
Acalc0dBnH=Acalc0dB-max(Acalc0dB);

Acalc45=Emulti45(:,3);
Acalc45dB=20*log10(Acalc45);          % Convert to dB
Acalc45dBnH=Acalc45dB-max(Acalc45dB);

Acalc90=Emulti90(:,3);
Acalc90dB=20*log10(Acalc90);          % Convert to dB
Acalc90dBnH=Acalc90dB-max(Acalc90dB);

theta=theta0;







% PHI PATTERNS
%***** TOTAL POL *****
Acalc30p=Emulti30p(:,1);
Acalc30pdB=20*log10(Acalc30p);            % Convert to dB
Acalc30pdBnT=Acalc30pdB-max(Acalc30pdB);

Acalc60p=Emulti60p(:,1);
Acalc60pdB=20*log10(Acalc60p);          % Convert to dB
Acalc60pdBnT=Acalc60pdB-max(Acalc60pdB);

Acalc90p=Emulti90p(:,1);
Acalc90pdB=20*log10(Acalc90p);          % Convert to dB
Acalc90pdBnT=Acalc90pdB-max(Acalc90pdB);

%***** VERTICAL POL *****
Acalc30p=Emulti30p(:,2);
Acalc30pdB=20*log10(Acalc30p);            % Convert to dB
Acalc30pdBnV=Acalc30pdB-max(Acalc30pdB);

Acalc60p=Emulti60p(:,2);
Acalc60pdB=20*log10(Acalc60p);          % Convert to dB
Acalc60pdBnV=Acalc60pdB-max(Acalc60pdB);

Acalc90p=Emulti90p(:,2);
Acalc90pdB=20*log10(Acalc90p);          % Convert to dB
Acalc90pdBnV=Acalc90pdB-max(Acalc90pdB);

%***** HORIZ POL *****
Acalc30p=Emulti30p(:,3);
Acalc30pdB=20*log10(Acalc30p);            % Convert to dB
Acalc30pdBnH=Acalc30pdB-max(Acalc30pdB);

Acalc60p=Emulti60p(:,3);
Acalc60pdB=20*log10(Acalc60p);          % Convert to dB
Acalc60pdBnH=Acalc60pdB-max(Acalc60pdB);

Acalc90p=Emulti90p(:,3);
Acalc90pdB=20*log10(Acalc90p);          % Convert to dB
Acalc90pdBnH=Acalc90pdB-max(Acalc90pdB);

phi=phi30p;



% ******************** LOAD NEC2 DATA ************************
%
%   ---- ANGLES ----    ---- POWER GAINS ----    ---- POL ----   ---- E-Theta ----  ---- E-Phi ----
%     1         2        3        4        5       6        7        8        9       10       11
% Theta(Deg) Phi(Deg) Vert(dB) Horiz(dB) Tot(dB) ARatio Tilt(Deg) Mag(V) Phase(Deg) Mag(V) Phase(Deg)
%

loadnecpat('3dipoles4t')


% THETA PATTERNS
load pattern1
Pat0=pattern_config; % Theta cut for phi=0
Nec0dBnV=Pat0(:,3)-max(Pat0(:,3));
Nec0dBnH=Pat0(:,4)-max(Pat0(:,4));
Nec0dBnT=Pat0(:,5)-max(Pat0(:,5));

load pattern2
Pat45=pattern_config; % Theta cut for phi=45
Nec45dBnV=Pat45(:,3)-max(Pat45(:,3));
Nec45dBnH=Pat45(:,4)-max(Pat45(:,4));
Nec45dBnT=Pat45(:,5)-max(Pat45(:,5));

load pattern3
Pat90=pattern_config; % Theta cut for phi=90
Nec90dBnV=Pat90(:,3)-max(Pat90(:,3));
Nec90dBnH=Pat90(:,4)-max(Pat90(:,4));
Nec90dBnT=Pat90(:,5)-max(Pat90(:,5));

% PHI PATTERNS
load pattern4
Pat30p=pattern_config; % Theta cut for phi=30
Nec30pdBnV=Pat30p(:,3)-max(Pat30p(:,3));
Nec30pdBnH=Pat30p(:,4)-max(Pat30p(:,4));
Nec30pdBnT=Pat30p(:,5)-max(Pat30p(:,5));

load pattern5
Pat60p=pattern_config; % Theta cut for phi=60
Nec60pdBnV=Pat60p(:,3)-max(Pat60p(:,3));
Nec60pdBnH=Pat60p(:,4)-max(Pat60p(:,4));
Nec60pdBnT=Pat60p(:,5)-max(Pat60p(:,5));

load pattern6
Pat90p=pattern_config; % Theta cut for phi=90
Nec90pdBnV=Pat90p(:,3)-max(Pat90p(:,3));
Nec90pdBnH=Pat90p(:,4)-max(Pat90p(:,4));
Nec90pdBnT=Pat90p(:,5)-max(Pat90p(:,5));




% THETA PATTERNS
%***** TOTAL FIELD *****
figure(10)
plot(theta,Acalc0dBnT,'r-',theta,Nec0dBnT,'r+',theta,Acalc45dBnT,...
    'g-',theta,Nec45dBnT,'g+',theta,Acalc90dBnT,'b-',theta,Nec90dBnT,'b+');
axis([-180 180 -40 0]);
title('TOTAL POWER (dB) Theta Cuts for Phi=0,45,90 Deg   ArrayCalc -   NEC2 +');
legend('Acalc0','Nec0','Acalc45','Nec45','Acalc90','Nec90');

%***** VERT POL *****
figure(11)
plot(theta,Acalc0dBnV,'r-',theta,Nec0dBnV,'r+',theta,Acalc45dBnV,...
    'g-',theta,Nec45dBnV,'g+',theta,Acalc90dBnV,'b-',theta,Nec90dBnV,'b+');
axis([-180 180 -40 0]);
title('VERT POL (dB) Theta Cuts for Phi=0,45,90 Deg    ArrayCalc -   NEC2 +');
legend('Acalc0','Nec0','Acalc45','Nec45','Acalc90','Nec90');

%***** HORIZ POL *****
figure(12)
plot(theta,Acalc0dBnH,'r-',theta,Nec0dBnH,'r+',theta,Acalc45dBnH,...
    'g-',theta,Nec45dBnH,'g+',theta,Acalc90dBnH,'b-',theta,Nec90dBnH,'b+');
axis([-180 180 -40 0]);
title('HORIZ POL (dB) Theta Cuts for Phi=0,45,90 Deg    ArrayCalc -   NEC2 +');
legend('Acalc0','Nec0','Acalc45','Nec45','Acalc90','Nec90');


% PHI PATTERNS
%***** TOTAL FIELD *****
figure(13)
plot(phi,Acalc30pdBnT,'r-',phi,Nec30pdBnT,'r+',phi,Acalc60pdBnT,...
    'g-',phi,Nec60pdBnT,'g+',phi,Acalc90pdBnT,'b-',phi,Nec90pdBnT,'b+');
axis([0 360 -10 0]);
title('TOTAL POWER (dB) Phi Cuts for Theta=30,60,90 Deg   ArrayCalc -   NEC2 +');
legend('Acalc30','Nec30','Acalc60','Nec60','Acalc90','Nec90');

%***** VERT POL *****
figure(14)
plot(phi,Acalc30pdBnV,'r-',phi,Nec30pdBnV,'r+',phi,Acalc60pdBnV,...
    'g-',phi,Nec60pdBnV,'g+',phi,Acalc90pdBnV,'b-',phi,Nec90pdBnV,'b+');
axis([0 360 -10 0]);
title('VERT POL (dB) Phi Cuts for Theta=30,60,90 Deg    ArrayCalc -   NEC2 +');
legend('Acalc30','Nec30','Acalc60','Nec60','Acalc90','Nec90');

%***** HORIZ POL *****
figure(15)
plot(phi,Acalc30pdBnH,'r-',phi,Nec30pdBnH,'r+',phi,Acalc60pdBnH,...
    'g-',phi,Nec60pdBnH,'g+',phi,Acalc90pdBnH,'b-',phi,Nec90pdBnH,'b+');
axis([0 360 -10 0]);
title('HORIZ POL (dB) Phi Cuts for Theta=30,60,90 Deg    ArrayCalc -   NEC2 +');
legend('Acalc30','Nec30','Acalc60','Nec60','Acalc90','Nec90');


