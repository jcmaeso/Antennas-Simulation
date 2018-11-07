% Ef3 : Verify calc_patchr_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Rectangular  Patch shape
% Subst = FR4          Substrate material name
%  Freq = 2.4e9        Frequency (Hz)
%    Er = 4.4          Relative dielectric constant
%     h = 3.0e-3       Substrate thickness (m)
%  tand = 0.02         Loss tangent (units)
% sigma = 5.8e7        Conductivity Copper (Siemens/m)
%  VSWR = 2            VSWR Bandwidth (ratio)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%
clc;
help ef3;

clear all;
close all;

init;

freq_config=2.4e9;


h=3.0e-3;                % Patch height (m)
Er=4.4;                  % Dielectric constant                 
Freq=freq_config;        % Resonant frequency (Hz)
sigma=5.8e7;             % Conductivity (S/m)
tand=0.02;               % Loss tangent
VSWR=2;                  % VSWR value for bandwidth estimate
patchr_config=design_patchr(Er,h,Freq);      % patchr_config format is [Er,W,L,h].
W=patchr_config(1,2);    % Get patch width from patchr_config (m)
L=patchr_config(1,3);    % Get patch length from patchr_config (m)
arrayeff_config=calc_patchr_eff(Er,W,L,h,tand,sigma,Freq,VSWR);
                                                                                                                           
single_element(0,0,0,'patchr',0,0);                     % Place a single element at the origin excited : 0dB 0deg

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
plot_theta(-90,2,90,[0,90],'tot','none');               % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0 and 90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps

% Ansoft Designer data for comparison

Phi0=[-88 -9.54403
-86 -4.44945
-84 -2.12039
-82 -0.867304
-80 -0.122316
-78 0.3591
-76 0.694325
-74 0.944106
-72 1.14186
-70 1.3069
-68 1.45088
-66 1.58104
-64 1.70199
-62 1.81671
-60 1.92712
-58 2.03446
-56 2.13949
-54 2.24266
-52 2.34418
-50 2.44411
-48 2.5424
-46 2.6389
-44 2.73343
-42 2.82573
-40 2.91556
-38 3.00264
-36 3.08667
-34 3.16737
-32 3.24445
-30 3.31764
-28 3.38665
-26 3.45122
-24 3.51112
-22 3.56609
-20 3.61593
-18 3.66043
-16 3.6994
-14 3.73268
-12 3.76012
-10 3.78158
-8 3.79697
-6 3.80618
-4 3.80914
-2 3.8058
2.08e-013 3.79613
2 3.78012
4 3.75777
6 3.72911
8 3.6942
10 3.65308
12 3.60587
14 3.55266
16 3.49359
18 3.4288
20 3.35847
22 3.28278
24 3.20195
26 3.1162
28 3.02578
30 2.93095
32 2.83199
34 2.7292
36 2.62288
38 2.51336
40 2.40094
42 2.28597
44 2.16875
46 2.0496
48 1.9288
50 1.80661
52 1.68322
54 1.55877
56 1.43325
58 1.30653
60 1.17825
62 1.04771
64 0.913766
66 0.774575
68 0.627243
70 0.467244
72 0.287417
74 0.0761961
76 -0.185668
78 -0.531518
80 -1.02204
82 -1.77456
84 -3.03355
86 -5.36685
88 -10.464];

Phi90=[-88 -25.0925
-86 -19.3676
-84 -16.1664
-82 -13.9381
-80 -12.2062
-78 -10.7746
-76 -9.54727
-74 -8.47032
-72 -7.50993
-70 -6.64322
-68 -5.85385
-66 -5.12961
-64 -4.46117
-62 -3.84121
-60 -3.26388
-58 -2.72447
-56 -2.21912
-54 -1.74466
-52 -1.29845
-50 -0.878281
-48 -0.482301
-46 -0.108948
-44 0.243098
-42 0.57496
-40 0.887592
-38 1.18181
-36 1.4583
-34 1.71765
-32 1.96037
-30 2.1869
-28 2.39758
-26 2.59275
-24 2.77265
-22 2.93753
-20 3.08755
-18 3.2229
-16 3.34369
-14 3.45005
-12 3.54206
-10 3.6198
-8 3.68333
-6 3.7327
-4 3.76794
-2 3.78908
2.08e-013 3.79613
2 3.7891
4 3.76799
6 3.73277
8 3.68342
10 3.61991
12 3.54219
14 3.45021
16 3.34387
18 3.2231
20 3.08778
22 2.93777
24 2.77292
26 2.59303
28 2.39789
30 2.18722
32 1.96071
34 1.71801
36 1.45867
38 1.1822
40 0.887995
42 0.575377
44 0.243527
46 -0.108508
48 -0.48185
50 -0.877822
52 -1.29799
54 -1.74419
56 -2.21865
58 -2.724
60 -3.26341
62 -3.84075
64 -4.46073
66 -5.12919
68 -5.85345
70 -6.64287
72 -7.50962
74 -8.47008
76 -9.54712
78 -10.7745
80 -12.2063
82 -13.9384
84 -16.167
86 -19.3686
88 -25.0937];

figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)




