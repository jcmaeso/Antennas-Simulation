% Ef2 : Verify calc_patchr_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Rectangular  Patch shape
% Subst = FR4          Substrate material name
%  Freq = 2.4e9        Frequency (Hz)
%    Er = 4.4          Relative dielectric constant
%     h = 0.76e-3      Substrate thickness (m)
%  tand = 0.02         Loss tangent (units)
% sigma = 5.8e7        Conductivity Copper (Siemens/m)
%  VSWR = 2            VSWR Bandwidth (ratio)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%
clc;
help ef2;

clear all;
close all;

init;

freq_config=2.4e9;


h=0.76e-3;               % Patch height (m)
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

Phi0=[-88 -4.56611
-86 -2.90485
-84 -2.49458
-82 -2.32219
-80 -2.2198
-78 -2.14217
-76 -2.07332
-74 -2.00657
-72 -1.93889
-70 -1.86882
-68 -1.79573
-66 -1.71939
-64 -1.63986
-62 -1.55731
-60 -1.47203
-58 -1.38437
-56 -1.29472
-54 -1.20351
-52 -1.11115
-50 -1.01811
-48 -0.924811
-46 -0.831712
-44 -0.739248
-42 -0.647847
-40 -0.557929
-38 -0.4699
-36 -0.384151
-34 -0.301056
-32 -0.220974
-30 -0.144242
-28 -0.071183
-26 -0.00209656
-24 0.0627357
-22 0.123053
-20 0.178615
-18 0.229201
-16 0.274613
-14 0.314673
-12 0.349222
-10 0.378126
-8 0.401267
-6 0.418553
-4 0.429908
-2 0.43528
2.08e-013 0.434637
2 0.427968
4 0.415284
6 0.396614
8 0.372011
10 0.341548
12 0.305319
14 0.263439
16 0.216045
18 0.163294
20 0.105366
22 0.042461
24 -0.0251984
26 -0.0973693
28 -0.173787
30 -0.254166
32 -0.338201
34 -0.425563
36 -0.515907
38 -0.608867
40 -0.704058
42 -0.801079
44 -0.899512
46 -0.998924
48 -1.09887
50 -1.1989
52 -1.29855
54 -1.39736
56 -1.49485
58 -1.59059
60 -1.68413
62 -1.77506
64 -1.863
66 -1.94765
68 -2.02879
70 -2.10637
72 -2.18057
74 -2.25202
76 -2.32214
78 -2.39396
80 -2.47413
82 -2.57863
84 -2.75267
86 -3.16413
88 -4.8261];

Phi90=[-88 -28.4233
-86 -23.4136
-84 -20.2423
-82 -17.8904
-80 -16.0255
-78 -14.4834
-76 -13.1703
-74 -12.0281
-72 -11.018
-70 -10.1132
-68 -9.29458
-66 -8.54765
-64 -7.86153
-62 -7.22777
-60 -6.63966
-58 -6.09186
-56 -5.58003
-54 -5.10062
-52 -4.6507
-50 -4.22783
-48 -3.82997
-46 -3.45541
-44 -3.10271
-42 -2.77065
-40 -2.45817
-38 -2.16441
-36 -1.8886
-34 -1.6301
-32 -1.38836
-30 -1.16292
-28 -0.953366
-26 -0.759365
-24 -0.580624
-22 -0.416896
-20 -0.267971
-18 -0.133672
-16 -0.0138494
-14 0.0916212
-12 0.182843
-10 0.259902
-8 0.322864
-6 0.371785
-4 0.406704
-2 0.427649
2.08e-013 0.434637
2 0.427673
4 0.406751
6 0.371856
8 0.322958
10 0.260019
12 0.182984
14 0.0917848
16 -0.0136631
18 -0.133463
20 -0.26774
22 -0.416643
24 -0.58035
26 -0.75907
28 -0.953051
30 -1.16258
32 -1.38801
34 -1.62973
36 -1.88821
38 -2.164
40 -2.45775
42 -2.77021
44 -3.10226
46 -3.45495
48 -3.82949
50 -4.22734
52 -4.65021
54 -5.10013
56 -5.57954
58 -6.09137
60 -6.63918
62 -7.2273
64 -7.86109
66 -8.54723
68 -9.29421
70 -10.1129
72 -11.0177
74 -12.028
76 -13.1704
78 -14.4838
80 -16.0264
82 -17.8921
84 -20.2456
86 -23.4206
88 -28.4394];

figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)





