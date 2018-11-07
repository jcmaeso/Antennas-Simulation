% Ef1_4element : Verify calc_patchr_eff function for estimating patch efficiency and
%                thereby the plotting of gain rather than directivity of a 4-element array.
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
%
% Array parameters :
% 
%     N = 4            Number of elements
%   Sep = 0.7*lambda   Element spacing (H-plane)
% Steer = [-10,0]      Squinted to [Theta,Phi]
% Taper = Taylor       Window for sidelobe suppression (-25dB)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%
%
clc;
help ef1_4element;

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
                                                                                                                           
lambda=velocity_config/freq_config;
nx=4;ny=1;
sx=lambda*0.7;sy=0;
eltype='patchr';
Erot=90;
rect_array(nx,ny,sx,sy,eltype,Erot);
squint_array(-10,0,1);                % Squint array to Theta=10 Phi=0, phase referenced to element 1
taywin_array(25,'x');                 % Apply amplitude taper for -25dB sidelobes
norm_array;                           % Normalise array excitations

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
plot_theta(-90,2,90,[0,90],'tot','none');               % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0 and 90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps
                     
% Data from Ansoft Designer v2.2 for comparison

Phi0=[-88 -46.3254
-86 -41.4036
-84 -38.3383
-82 -36.1681
-80 -34.5866
-78 -33.4645
-76 -32.7578
-74 -32.4799
-72 -32.7023
-70 -33.5832
-68 -35.4523
-66 -38.9648
-64 -42.5703
-62 -37.0286
-60 -31.5699
-58 -27.8092
-56 -25.1222
-54 -23.2212
-52 -22.0101
-50 -21.5214
-48 -21.939
-46 -23.7367
-44 -27.6806
-42 -26.1193
-40 -18.5652
-38 -13.1109
-36 -8.98658
-34 -5.6609
-32 -2.88058
-30 -0.510394
-28 1.52922
-26 3.28851
-24 4.80074
-22 6.08863
-20 7.16785
-18 8.04919
-16 8.73977
-14 9.24379
-12 9.56305
-10 9.69713
-8 9.64348
-6 9.39726
-4 8.95106
-2 8.29434
2.08e-013 7.41252
2 6.28556
4 4.88554
6 3.17257
8 1.08729
10 -1.46411
12 -4.64383
14 -8.77465
16 -14.6808
18 -26.245
20 -27.0557
22 -20.1606
24 -18.5375
26 -19.0316
28 -21.2885
30 -26.0674
32 -35.735
34 -28.307
36 -23.0267
38 -20.5766
40 -19.6217
42 -19.8071
44 -21.1766
46 -24.2648
48 -31.2932
50 -32.4332
52 -23.3013
54 -18.649
56 -15.6667
58 -13.5774
60 -12.0678
62 -10.9804
64 -10.2253
66 -9.74795
68 -9.51443
70 -9.50509
72 -9.71146
74 -10.1355
76 -10.7911
78 -11.7074
80 -12.9375
82 -14.5762
84 -16.8026
86 -20.0033
88 -25.3482];

Phi90=[-88 1.96411
-86 3.43177
-84 3.78909
-82 3.94588
-80 4.0469
-78 4.13042
-76 4.20975
-74 4.2903
-72 4.37441
-70 4.46307
-68 4.55659
-66 4.65489
-64 4.75771
-62 4.86464
-60 4.97518
-58 5.08879
-56 5.20491
-54 5.32294
-52 5.44228
-50 5.56233
-48 5.68251
-46 5.80223
-44 5.92093
-42 6.03805
-40 6.15307
-38 6.26549
-36 6.37481
-34 6.48058
-32 6.58236
-30 6.67975
-28 6.77236
-26 6.85983
-24 6.94183
-22 7.01805
-20 7.08821
-18 7.15205
-16 7.20935
-14 7.2599
-12 7.30352
-10 7.34004
-8 7.36935
-6 7.39132
-4 7.40588
-2 7.41295
2.08e-013 7.41252
2 7.40456
4 7.38907
6 7.3661
8 7.33571
10 7.29796
12 7.25298
14 7.20088
16 7.14182
18 7.07598
20 7.00357
22 6.92481
24 6.83996
26 6.7493
28 6.65315
30 6.55182
32 6.4457
34 6.33516
36 6.22062
38 6.10253
40 5.98136
42 5.85759
44 5.73176
46 5.60441
48 5.4761
50 5.34743
52 5.21899
54 5.0914
56 4.96528
58 4.84128
60 4.71999
62 4.60204
64 4.488
66 4.3784
68 4.27367
70 4.17414
72 4.0799
74 3.99068
76 3.90554
78 3.82215
80 3.73514
82 3.63124
84 3.47217
86 3.11322
88 1.64457];

figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
axis([-90 90 -25 15]);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)




