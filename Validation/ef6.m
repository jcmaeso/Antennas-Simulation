% Ef6 : Verify calc_patchc_eff function for estimating patch efficiency and
%       thereby the plotting of gain rather than directivity.
%
% Patch input parameters :
%
%  Type = Circular     Patch shape
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
clc;
help ef6;

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
                     
% Ansoft data for comparison

Phi0=[-88 -1.56381
-86 -0.0985672
-84 0.260007
-82 0.419616
-80 0.524546
-78 0.612919
-76 0.697966
-74 0.785032
-72 0.876411
-70 0.973036
-68 1.07516
-66 1.18267
-64 1.29523
-62 1.41238
-60 1.53359
-58 1.65824
-56 1.78574
-54 1.91542
-52 2.04665
-50 2.17878
-48 2.31118
-46 2.44323
-44 2.57432
-42 2.70386
-40 2.8313
-38 2.9561
-36 3.07775
-34 3.19575
-32 3.30965
-30 3.41902
-28 3.52346
-26 3.62258
-24 3.71605
-22 3.80353
-20 3.88474
-18 3.95942
-16 4.02731
-14 4.08822
-12 4.14195
-10 4.18834
-8 4.22725
-6 4.25859
-4 4.28225
-2 4.2982
2.08e-013 4.30638
2 4.30679
4 4.29944
6 4.28438
8 4.26166
10 4.23138
12 4.19366
14 4.14862
16 4.09644
18 4.0373
20 3.97142
22 3.89904
24 3.82043
26 3.73588
28 3.6457
30 3.55025
32 3.4499
34 3.34504
36 3.23611
38 3.12354
40 3.00782
42 2.88944
44 2.76894
46 2.64684
48 2.52373
50 2.40018
52 2.2768
54 2.15418
56 2.03294
58 1.9137
60 1.79706
62 1.68362
64 1.57392
66 1.46848
68 1.36771
70 1.27191
72 1.18114
74 1.09513
76 1.0129
78 0.932122
80 0.847419
82 0.745532
84 0.588316
86 0.231465
88 -1.23274];

Phi90=[-88 -25.4315
-86 -19.7325
-84 -16.3065
-82 -13.8476
-80 -11.9312
-78 -10.3624
-76 -9.03543
-74 -7.88666
-72 -6.87472
-70 -5.97132
-68 -5.15627
-66 -4.41467
-64 -3.73521
-62 -3.10918
-60 -2.52967
-58 -1.99118
-56 -1.48923
-54 -1.02015
-52 -0.580929
-50 -0.169027
-48 0.217673
-46 0.580961
-44 0.922354
-42 1.24315
-40 1.54444
-38 1.82718
-36 2.09218
-34 2.34015
-32 2.57167
-30 2.78727
-28 2.9874
-26 3.17244
-24 3.34273
-22 3.49854
-20 3.64012
-18 3.76769
-16 3.88141
-14 3.98144
-12 4.0679
-10 4.1409
-8 4.20053
-6 4.24685
-4 4.27991
-2 4.29974
2.08e-013 4.30638
2 4.29981
4 4.28005
6 4.24707
8 4.20082
10 4.14127
12 4.06835
14 3.98196
16 3.88202
18 3.76838
20 3.6409
22 3.49941
24 3.3437
26 3.17352
28 2.98859
30 2.78857
32 2.57309
34 2.3417
36 2.09389
38 1.82904
40 1.54647
42 1.24537
44 0.924797
46 0.583645
48 0.220629
50 -0.16576
52 -0.577306
54 -1.01612
56 -1.4847
58 -1.98608
60 -2.52389
62 -3.10256
64 -3.72756
66 -4.40572
68 -5.14568
70 -5.95857
72 -6.85905
74 -7.86695
76 -9.00988
78 -10.3279
80 -11.8823
82 -13.7729
84 -16.1794
86 -19.4774
88 -24.7835];


figure(2);
hold on;
p1=plot(Phi0(:,1),Phi0(:,2),'r:','linewidth',2);
p2=plot(Phi90(:,1),Phi90(:,2),'g:','linewidth',2);
fprintf('\nMax Gain Ansoft Theta Cut for Phi=0  %3.2f dB\n',max(Phi0(:,2)));
fprintf('\nMax Gain Ansoft Theta Cut for Phi=90  %3.2f dB\n',max(Phi90(:,2)));
legend([p1,p2],'Ansoft Phi=0','Ansoft Phi=90',3)



