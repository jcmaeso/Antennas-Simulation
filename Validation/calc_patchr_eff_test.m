% Test calc_patchr_eff function
%
% Er.....Relative dielectric constant
% W......Patch width (m)
% L......Patch length (m)
% h......Substrate thickness (m)
% tand...Loss tangent (units)
% sigma..Conductivity (Siemens/m)
% Freq...Frequency (Hz)
% VSWR...VSWR Bandwidth (ratio)
%

init;

freq_config=2.4e9;


h=3e-3;               % Patch height (m)
Er=4.4;                 % Dielectric constant                 
Freq=freq_config;        % Resonant frequency (Hz)
sigma=5.8e7;             % Conductivity (S/m)
tand=0.02;              % Loss tangent
VSWR=2;                  % VSWR value for bandwidth estimate
patchr_config=design_patchr(Er,h,Freq);      % patchr_config format is [Er,W,L,h].
W=patchr_config(1,2);    % Get patch width from patchr_config (m)
L=patchr_config(1,3);    % Get patch length from patchr_config (m)
arrayeff_config=calc_patchr_eff(Er,W,L,h,tand,sigma,Freq,VSWR);
                                                                                                                           
single_element(0,0,0,'patchr',0,0);                     % Place a single element at the origin excited : 0dB 0deg

plot_geom3d(1,0);                                       % Plot 3D geometry with axis
list_array(0);                                          % List the array x,y,z locations and excitations only
calc_directivity(5,15);                                 % Calc directivity using 5deg theta steps and 15deg phi steps
plot_theta(-90,2,90,[0,45,90],'tot','none');            % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0,45,90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps
                     








