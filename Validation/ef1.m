% Ef1 : Verify calc_patchr_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Rectangular  Patch shape
% Subst = RO4350       Substrate material name
%  Freq = 2.4e9        Frequency (Hz)
%    Er = 3.48         Relative dielectric constant
%     h = 0.76e-3      Substrate thickness (m)
%  tand = 0.004        Loss tangent (units)
% sigma = 5.8e7        Conductivity Copper (Siemens/m)
%  VSWR = 2            VSWR Bandwidth (ratio)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%

clc
help ef1;

clear all;
close all;

init;

freq_config=2.4e9;


h=0.76e-3;               % Patch height (m)
Er=3.48;                 % Dielectric constant                 
Freq=freq_config;        % Resonant frequency (Hz)
sigma=5.8e7;             % Conductivity (S/m)
tand=0.004;              % Loss tangent
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

Phi0=[-88 -0.877049
-86 0.590676
-84 0.948101
-82 1.10505
-80 1.20625
-78 1.29
-76 1.3696
-74 1.45045
-72 1.5349
-70 1.62392
-68 1.71783
-66 1.81655
-64 1.91981
-62 2.02719
-60 2.1382
-58 2.2523
-56 2.36892
-54 2.48745
-52 2.6073
-50 2.72787
-48 2.84856
-46 2.9688
-44 3.08801
-42 3.20565
-40 3.32118
-38 3.43409
-36 3.54391
-34 3.65017
-32 3.75243
-30 3.85029
-28 3.94336
-26 4.03128
-24 4.11372
-22 4.19036
-20 4.26094
-18 4.3252
-16 4.38289
-14 4.43382
-12 4.47781
-10 4.5147
-8 4.54435
-6 4.56666
-4 4.58155
-2 4.58894
2.08e-013 4.58881
2 4.58114
4 4.56594
6 4.54325
8 4.51311
10 4.47562
12 4.43088
14 4.37901
16 4.32017
18 4.25455
20 4.18234
22 4.10377
24 4.0191
26 3.92862
28 3.83263
30 3.73146
32 3.62548
34 3.51508
36 3.40067
38 3.28271
40 3.16165
42 3.03799
44 2.91226
46 2.785
48 2.65678
50 2.52818
52 2.39981
54 2.27228
56 2.14622
58 2.02227
60 1.90103
62 1.78312
64 1.66912
66 1.55955
68 1.45485
70 1.35534
72 1.26112
74 1.17192
76 1.08678
78 1.00341
80 0.916411
82 0.81251
84 0.65345
86 0.294501
88 -1.17414];

Phi90=[-88 -25.3865
-86 -19.917
-84 -16.5608
-82 -14.1263
-80 -12.2175
-78 -10.6483
-76 -9.31629
-74 -8.15934
-72 -7.13688
-70 -6.22107
-68 -5.39202
-66 -4.63504
-64 -3.93903
-62 -3.29539
-60 -2.69738
-58 -2.13961
-56 -1.61774
-54 -1.12822
-52 -0.668145
-50 -0.235101
-48 0.172917
-46 0.557587
-44 0.920319
-42 1.2623
-40 1.58452
-38 1.88784
-36 2.17298
-34 2.44052
-32 2.691
-30 2.92484
-28 3.1424
-26 3.34401
-24 3.52992
-22 3.70035
-20 3.85548
-18 3.99547
-16 4.12044
-14 4.2305
-12 4.32573
-10 4.40621
-8 4.47199
-6 4.52312
-4 4.55961
-2 4.58151
2.08e-013 4.58881
2 4.58153
4 4.55966
6 4.52319
8 4.47209
10 4.40633
12 4.32588
14 4.23067
16 4.12063
18 3.99569
20 3.85573
22 3.70062
24 3.53022
26 3.34434
28 3.14276
30 2.92523
32 2.69142
34 2.44098
36 2.17347
38 1.88838
40 1.5851
42 1.26292
44 0.920988
46 0.55831
48 0.173699
50 -0.234252
52 -0.667221
54 -1.12721
56 -1.61663
58 -2.13839
60 -2.69602
62 -3.29386
64 -3.9373
66 -4.63307
68 -5.38973
70 -6.21837
72 -7.13362
74 -8.15532
76 -9.31116
78 -10.6415
80 -12.208
82 -14.1119
84 -16.5366
86 -19.869
88 -25.267];

figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)


