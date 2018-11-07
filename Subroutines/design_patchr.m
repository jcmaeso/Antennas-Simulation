function patchcfg=design_patchr(Er,h,Freq)
% Returns the patch_config parameters for standard lambda/2 rectangular
% microstrip patch. Patch length L and width W are calculated
% and returned together with supplied parameters Er and h.
%
% Returned values are in the same format as the global patchr_config
% variable, so can be assigned directly. The patchr_config variable is
% of the following form [Er,W,L,h].
%
% Usage: patchr_config=design_patchr(Er,h,Freq)
%
% Er.....Relative dielectric constant
% h......Substrate thickness (m)
% Freq...Frequency (Hz)
%
% e.g. patchr_config=design_patchr(3.43,0.7e-3,2e9)

global velocity_config

Eo=8.854185e-12;
vo=velocity_config;

lambda=vo/Freq;
lambdag=lambda/sqrt(Er);

W=(vo/(2*Freq))*sqrt(2/(Er+1));

% Calculate effictive dielectric constant for microstrip
% line of width W on dielectric material of constant Er

Ereff=((Er+1)/2)+((Er-1)/2)*(1+12*(h/W)).^-0.5;

% Calculate increase length dL of patch length L due to fringing
% fields at each end, giving actual length L = Lambda/2 - 2*dL

F1=(Ereff+0.3)*(W/h+0.264);
F2=(Ereff-0.258)*(W/h+0.8);
dL=h*0.412*(F1/F2);

lambdag=lambda/sqrt(Ereff);
L=(lambdag/2)-2*dL;

patchcfg=[Er,W,L,h];

fprintf('\nRectangular Microstrip Patch Design\n');
fprintf('Frequency       : %1.3f MHz\n',Freq/1e6);
fprintf('Dielec Const Er : %1.3f\n',Er);
fprintf('Patch Width  W  : %1.3f cm\n',W*100);
fprintf('Patch Length L  : %1.3f cm\n',L*100);
fprintf('Patch Height h  : %1.3f cm\n\n',h*100);