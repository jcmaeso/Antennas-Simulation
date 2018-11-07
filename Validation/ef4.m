% Ef4 : Verify calc_patchr_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Rectangular  Patch shape
% Subst = Air          Substrate material name
%  Freq = 2.4e9        Frequency (Hz)
%    Er = 1.0          Relative dielectric constant
%     h = 6.0e-3       Substrate thickness (m)
%  tand = 0.00         Loss tangent (units)
% sigma = 5.8e7        Conductivity Copper (Siemens/m)
%  VSWR = 2            VSWR Bandwidth (ratio)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%
clc;
help ef4;

clear all;
close all;

init;

freq_config=2.4e9;


h=6.0e-3;                % Patch height (m)
Er=1.0;                  % Dielectric constant                 
Freq=freq_config;        % Resonant frequency (Hz)
sigma=5.8e7;             % Conductivity (S/m)
tand=0.00;               % Loss tangent
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
                     

% Ansoft designer data for comparison

Phi0=[-88 -6.8084
-86 -6.73109
-84 -6.60347
-82 -6.41756
-80 -6.16685
-78 -5.84645
-76 -5.45445
-74 -4.99276
-72 -4.46729
-70 -3.88723
-68 -3.26384
-66 -2.60915
-64 -1.93476
-62 -1.25112
-60 -0.567105
-58 0.110053
-56 0.774679
-54 1.42245
-52 2.05016
-50 2.6555
-48 3.23684
-46 3.7931
-44 4.32356
-42 4.82781
-40 5.30563
-38 5.75697
-36 6.18183
-34 6.58033
-32 6.95258
-30 7.29873
-28 7.61893
-26 7.91333
-24 8.18207
-22 8.42526
-20 8.643
-18 8.83536
-16 9.0024
-14 9.14414
-12 9.26057
-10 9.35165
-8 9.41732
-6 9.45748
-4 9.47199
-2 9.46069
2.08e-013 9.42335
2 9.35974
4 9.26953
6 9.15237
8 9.00784
10 8.83546
12 8.63466
14 8.40478
16 8.14506
18 7.85463
20 7.53248
22 7.17741
24 6.78805
26 6.36278
28 5.89971
30 5.39661
32 4.8508
34 4.2591
36 3.61766
38 2.9218
40 2.16574
42 1.34228
44 0.442273
46 -0.546066
48 -1.6383
50 -2.85553
52 -4.22726
54 -5.7966
56 -7.62984
58 -9.8363
60 -12.614
62 -16.3679
64 -21.9602
66 -26.4684
68 -20.7645
70 -16.4827
72 -13.7314
74 -11.8068
76 -10.3885
78 -9.31518
80 -8.49631
82 -7.87727
84 -7.42371
86 -7.114
88 -6.93663];

Phi90=[-88 -6.7628
-86 -6.53177
-84 -6.17434
-82 -5.71458
-80 -5.17965
-78 -4.59426
-76 -3.97858
-74 -3.34791
-72 -2.71328
-70 -2.08231
-68 -1.46016
-66 -0.850196
-64 -0.254559
-62 0.325411
-60 0.888908
-58 1.43546
-56 1.96481
-54 2.47681
-52 2.97139
-50 3.44849
-48 3.90807
-46 4.35008
-44 4.77447
-42 5.18116
-40 5.57005
-38 5.94105
-36 6.29404
-34 6.62889
-32 6.94546
-30 7.24363
-28 7.52326
-26 7.7842
-24 8.02631
-22 8.24948
-20 8.45356
-18 8.63845
-16 8.80402
-14 8.95017
-12 9.07682
-10 9.18389
-8 9.27129
-6 9.33898
-4 9.38691
-2 9.41504
2.08e-013 9.42335
2 9.41185
4 9.38053
6 9.3294
8 9.25852
10 9.16791
12 9.05764
14 8.92777
16 8.77839
18 8.60958
20 8.42146
22 8.21414
24 7.98773
26 7.74237
28 7.47819
30 7.19533
32 6.89394
34 6.57417
36 6.23617
38 5.88007
40 5.50602
42 5.11415
44 4.70458
46 4.27744
48 3.83283
50 3.37084
52 2.89156
54 2.39509
56 1.88152
58 1.35101
60 0.803787
62 0.240194
64 -0.339186
66 -0.933423
68 -1.54104
70 -2.15973
72 -2.78598
74 -3.4145
76 -4.03756
78 -4.64417
80 -5.21924
82 -5.74313
84 -6.19205
86 -6.54014
88 -6.76476];

figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)






