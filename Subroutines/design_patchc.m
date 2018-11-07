function patchcfg=design_patchc(Er,h,Freq)
% Returns the patch_config parameters for standard lambda/2 circular
% microstrip patch. Patch radius 'a' is calculated
% and returned together with supplied parameters Er and h.
%
% Returned values are in the same format as the global patchc_config
% variable, so can be assigned directly. The patchc_config variable is
% of the following form [Er,a,h].
%
% Usage: patchc_config=design_patchc(Er,h,Freq)
%
% Er.....Relative dielectric constant
% h......Substrate thickness (m)
% Freq...Frequency (Hz)
%
% e.g. patchc_config=design_patchc(2.2,1.588e-3,10e9)

global velocity_config

Eo=8.854185e-12;
vo=velocity_config;
h=h*100;         % Formula uses (cm)

lambda=vo/Freq;
lambdag=lambda/sqrt(Er);

F=8.791e9/(Freq*sqrt(Er));

F1=(2*h)/(pi*Er*F);
F2=log((pi*F)/(2*h))+1.7726;

a=F/sqrt(1+F1*F2);   % Formula gives a in cm

patchcfg=[Er,a/100,h/100];

fprintf('\nCircular Microstrip Patch Design\n');
fprintf('Frequency       : %1.3f MHz\n',Freq/1e6);
fprintf('Dielec Const Er : %1.3f\n',Er);
fprintf('Patch Radius a  : %1.3f cm\n',a);
fprintf('Patch Height h  : %1.3f cm\n\n',h);