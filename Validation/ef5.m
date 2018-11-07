% Ef5 : Verify calc_patchr_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Rectangular  Patch shape
% Subst = TMM 10i      Substrate material name
%  Freq = 10e9         Frequency (Hz)
%    Er = 9.8          Relative dielectric constant
%     h = 0.76e-3      Substrate thickness (m)
%  tand = 0.002        Loss tangent (units)
% sigma = 5.8e7        Conductivity Copper (Siemens/m)
%  VSWR = 2            VSWR Bandwidth (ratio)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%
clc;
help ef5;

clear all;
close all;

init;

freq_config=10.0e9;


h=0.76e-3;               % Patch height (m)
Er=9.8;                  % Dielectric constant                 
Freq=freq_config;        % Resonant frequency (Hz)
sigma=5.8e7;             % Conductivity (S/m)
tand=0.002;              % Loss tangent
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
                     

% Ansoft data for comparison

Phi0=[-88 -9.88094
-86 -4.45143
-84 -1.76215
-82 -0.208747
-80 0.759659
-78 1.39833
-76 1.84033
-74 2.15973
-72 2.39984
-70 2.58699
-68 2.73781
-66 2.86307
-64 2.96998
-62 3.06345
-60 3.14687
-58 3.22266
-56 3.29252
-54 3.35768
-52 3.41901
-50 3.47714
-48 3.53251
-46 3.58543
-44 3.6361
-42 3.68465
-40 3.73115
-38 3.7756
-36 3.81801
-34 3.85834
-32 3.89652
-30 3.9325
-28 3.9662
-26 3.99752
-24 4.0264
-22 4.05273
-20 4.07645
-18 4.09746
-16 4.1157
-14 4.13108
-12 4.14356
-10 4.15308
-8 4.15958
-6 4.16303
-4 4.1634
-2 4.16067
2.08e-013 4.15482
2 4.14587
4 4.13381
6 4.11867
8 4.10048
10 4.07927
12 4.05509
14 4.02801
16 3.99808
18 3.96538
20 3.92999
22 3.892
24 3.8515
26 3.80858
28 3.76336
30 3.71591
32 3.66636
34 3.61477
36 3.56125
38 3.50587
40 3.44867
42 3.38969
44 3.32893
46 3.26634
48 3.20182
50 3.13519
52 3.06615
54 2.9943
56 2.91903
58 2.83947
60 2.75444
62 2.66224
64 2.5605
66 2.44582
68 2.31333
70 2.15584
72 1.96258
74 1.71696
76 1.39265
78 0.946372
80 0.304053
82 -0.667353
84 -2.22309
86 -4.91406];

Phi90=[-88 -25.291
-86 -19.3023
-84 -15.8204
-82 -13.3615
-80 -11.46
-78 -9.90975
-76 -8.60174
-74 -7.47155
-72 -6.47783
-70 -5.59248
-68 -4.7955
-66 -4.07213
-64 -3.41118
-62 -2.80398
-60 -2.24365
-58 -1.72469
-56 -1.24258
-54 -0.793634
-52 -0.374751
-50 0.0166554
-48 0.382779
-46 0.725486
-44 1.04638
-42 1.34683
-40 1.62802
-38 1.891
-36 2.13666
-34 2.36578
-32 2.57904
-30 2.77704
-28 2.96031
-26 3.12931
-24 3.28444
-22 3.42604
-20 3.55444
-18 3.66988
-16 3.77261
-14 3.86282
-12 3.94069
-10 4.00635
-8 4.05991
-6 4.10148
-4 4.13113
-2 4.1489
2.08e-013 4.15482
2 4.14891
4 4.13116
6 4.10152
8 4.05997
10 4.00642
12 3.94077
14 3.86292
16 3.77272
18 3.67
20 3.55457
22 3.42619
24 3.2846
26 3.12948
28 2.96049
30 2.77723
32 2.57923
34 2.36598
36 2.13687
38 1.89122
40 1.62824
42 1.34705
44 1.0466
46 0.725705
48 0.382994
50 0.0168645
52 -0.374552
54 -0.793448
56 -1.24242
58 -1.72455
60 -2.24354
62 -2.8039
64 -3.41115
66 -4.07216
68 -4.79561
70 -5.5927
72 -6.47817
74 -7.47206
76 -8.60247
78 -9.91076
80 -11.4614
82 -13.3634
84 -15.8228
86 -19.3053
88 -25.2945];



figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)


