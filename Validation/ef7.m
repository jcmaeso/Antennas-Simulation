% Ef6 : Verify calc_patchc_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Circular     Patch shape
% Subst = RO4350       Substrate material name
%  Freq = 2.4e9        Frequency (Hz)
%    Er = 3.48         Relative dielectric constant
%     h = 1.66e-3      Substrate thickness (m)
%  tand = 0.004        Loss tangent (units)
% sigma = 5.8e7        Conductivity Copper (Siemens/m)
%  VSWR = 2            VSWR Bandwidth (ratio)
%
% See text output for estimated patch dimensions, efficiency and bandwidth.
%
% See rectangular pattern plot for comparison with Ansoft Designer v2.2
%
clc;
help ef6;

clear all;
close all;

init;

freq_config=2.4e9;

h=1.66e-3;               % Patch height (m)
Er=3.48;                 % Dielectric constant                 
Freq=freq_config;        % Resonant frequency (Hz)
sigma=5.8e7;             % Conductivity (S/m)
tand=0.004;              % Loss tangent
VSWR=2;                  % VSWR value for bandwidth estimate
patchc_config=design_patchc(Er,h,Freq);      % patchr_config format is [Er,a,h].
a=patchc_config(1,2);                        % Radius of circular patch (m)
arrayeff_config=calc_patchc_eff(Er,a,h,tand,sigma,Freq,VSWR);
                                                                                                                           
single_element(0,0,0,'patchc',0,0);                     % Place a single element at the origin excited : 0dB 0deg

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
plot_theta(-90,2,90,[0,90],'tot','none');               % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0 and 90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps
                     
% Ansoft designer data for comparison

Phi0=[-88 -4.43425
-86 -0.953676
-84 0.187833
-82 0.695326
-80 0.97961
-78 1.17171
-76 1.32227
-74 1.45368
-72 1.57685
-70 1.69739
-68 1.81827
-66 1.94103
-64 2.0664
-62 2.1946
-60 2.32556
-58 2.459
-56 2.59454
-54 2.73169
-52 2.86993
-50 3.00871
-48 3.14744
-46 3.28556
-44 3.42251
-42 3.55772
-40 3.69066
-38 3.8208
-36 3.94765
-34 4.07073
-32 4.18959
-30 4.30382
-28 4.413
-26 4.51677
-24 4.61479
-22 4.70675
-20 4.79234
-18 4.87132
-16 4.94344
-14 5.00849
-12 5.0663
-10 5.1167
-8 5.15956
-6 5.19478
-4 5.22228
-2 5.24199
2.08e-013 5.25388
2 5.25796
4 5.25422
6 5.24273
8 5.22353
10 5.19672
12 5.16243
14 5.12077
16 5.07193
18 5.01609
20 4.95345
22 4.88427
24 4.80881
26 4.72734
28 4.6402
30 4.54771
32 4.45024
34 4.34817
36 4.24193
38 4.13194
40 4.01865
42 3.90255
44 3.78412
46 3.66388
48 3.54235
50 3.42005
52 3.29751
54 3.17525
56 3.05378
58 2.93355
60 2.815
62 2.69844
64 2.58408
66 2.47193
68 2.36167
70 2.25252
72 2.14287
74 2.02966
76 1.90722
78 1.76459
80 1.5793
82 1.30066
84 0.797609
86 -0.340702
88 -3.81935];

Phi90=[-88 -24.2251
-86 -18.5297
-84 -15.1922
-82 -12.7912
-80 -10.9093
-78 -9.36187
-76 -8.04878
-74 -6.90941
-72 -5.9041
-70 -5.00554
-68 -4.1941
-66 -3.45525
-64 -2.77795
-62 -2.15361
-60 -1.57547
-58 -1.03808
-56 -0.537031
-54 -0.0687043
-52 0.369899
-50 0.781282
-48 1.16755
-46 1.53046
-44 1.87154
-42 2.19207
-40 2.49313
-38 2.77568
-36 3.04051
-34 3.28833
-32 3.51973
-30 3.73522
-28 3.93526
-26 4.12022
-24 4.29044
-22 4.44619
-20 4.58772
-18 4.71525
-16 4.82893
-14 4.92894
-12 5.01539
-10 5.08838
-8 5.148
-6 5.19432
-4 5.22738
-2 5.24723
2.08e-013 5.25388
2 5.24735
4 5.22762
6 5.19467
8 5.14848
10 5.08898
12 5.01612
14 4.9298
16 4.82993
18 4.71639
20 4.58901
22 4.44763
24 4.29204
26 4.122
28 3.93723
30 3.73739
32 3.52211
34 3.29095
36 3.04339
38 2.77883
40 2.4966
42 2.19588
44 1.87574
46 1.53509
48 1.17267
50 0.786967
52 0.376231
54 -0.0616202
56 -0.529065
58 -1.02907
60 -1.56521
62 -2.14183
64 -2.7643
66 -3.43927
68 -4.17515
70 -4.98274
72 -5.87618
74 -6.87446
76 -8.00389
78 -9.30229
80 -10.827
82 -12.6713
84 -15.0065
86 -18.2239
88 -23.7253];


figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3);






