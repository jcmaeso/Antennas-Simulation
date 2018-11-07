% VALIDATION EXAMPLE 3
%
% A 3x3 array of 3-turn helicies on a groundplane.
% The array spacing is 0.7 lambda in X and Y directions. Freq=300 MHz
%
% Comparison with NEC model 'helix2p9'
%
% The total field correlation in this example is very good for the
% main lobe and fair for the side-lobe. The results for the Vertical 
% and Horizontal components show significant differences. 
% This is because circular polarisation analysis requires a significantly
% more complex model to obtain accurate results. For this application VP and
% HP components are assumed to be a constant -3dB down on the total field. 

close all
clc

help val3

init;                               % Initialise global variables

lambda=3e8/freq_config;             % Calculate wavelength
helix_config=design_helix(3,300e6); % Design helix 3-turn

rect_array(3,3,0.7*lambda,0.7*lambda,'helix',0); % 3x3 Helix array
list_array(0);                                   % List array details
plot_geom3d(1,0);
fprintf('0 Deg cut \n');
[theta0,Emulti0]=theta_cut(-90,2,90,0);
fprintf('45 Deg cut \n');
[theta45,Emulti45]=theta_cut(-90,2,90,45);
fprintf('90 Deg cut \n');
[theta90,Emulti90]=theta_cut(-90,2,90,90);


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
% ******************** LOAD NEC2 DATA ************************
%
%   ---- ANGLES ----    ---- POWER GAINS ----    ---- POL ----   ---- E-Theta ----  ---- E-Phi ----
%     1         2        3        4        5       6        7        8        9       10       11
% Theta(Deg) Phi(Deg) Vert(dB) Horiz(dB) Tot(dB) ARatio Tilt(Deg) Mag(V) Phase(Deg) Mag(V) Phase(Deg)
%

loadnecpat('helix2p9')

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



%***** TOTAL FIELD *****
figure(10)
plot(theta,Acalc0dBnT,'r-',theta,Nec0dBnT,'r+',theta,Acalc45dBnT,...
    'g-',theta,Nec45dBnT,'g+',theta,Acalc90dBnT,'b-',theta,Nec90dBnT,'b+');
axis([-90 90 -40 0]);
title('TOTAL POWER (dB) Theta Cuts for Phi=0,45,90 Deg   ArrayCalc -   NEC2 +');
legend('Acalc0','Nec0','Acalc45','Nec45','Acalc90','Nec90');

%***** VERT POL *****
figure(11)
plot(theta,Acalc0dBnV,'r-',theta,Nec0dBnV,'r+',theta,Acalc45dBnV,...
    'g-',theta,Nec45dBnV,'g+',theta,Acalc90dBnV,'b-',theta,Nec90dBnV,'b+');
axis([-90 90 -40 0]);
title('VERT POL (dB) Theta Cuts for Phi=0,45,90 Deg    ArrayCalc -   NEC2 +');
legend('Acalc0','Nec0','Acalc45','Nec45','Acalc90','Nec90');

%***** HORIZ POL *****
figure(12)
plot(theta,Acalc0dBnH,'r-',theta,Nec0dBnH,'r+',theta,Acalc45dBnH,...
    'g-',theta,Nec45dBnH,'g+',theta,Acalc90dBnH,'b-',theta,Nec90dBnH,'b+');
axis([-90 90 -40 0]);
title('HORIZ POL (dB) Theta Cuts for Phi=0,45,90 Deg    ArrayCalc -   NEC2 +');
legend('Acalc0','Nec0','Acalc45','Nec45','Acalc90','Nec90');