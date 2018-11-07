% Test calc_patchr_eff function
%
% Er.....Relative dielectric constant
% a......Patch radius (m)
% h......Substrate thickness (m)
% tand...Loss tangent (units)
% sigma..Conductivity (Siemens/m)
% Freq...Frequency (Hz)
%

init;

freq_config=2.4e9;

h=1.6e-3;                % Patch height (m)
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
plot_theta(-90,2,90,[0,45,90],'tot','none');            % Plot total power theta patterns -90 to +90 deg in 2deg steps
                                                        % for phi angles of 0,45,90.
plot_pattern3d(5,15,'tot','no');                        % Plot a 3D directivity pattern using 5/15 deg theta/phi steps
                     








