function Eff=calc_patchr_eff(Er,W,L,h,tand,sigma,Freq,VSWR)
% Returns the efficiency of a rectangular microstrip patch as a percentage.
%
% Usage: Eff=calc_patchr_eff(Er,W,L,h,tand,sigma,Freq,VSWR)
%
% Er.....Relative dielectric constant
% W......Patch width (m)
% L......Patch length (m)
% h......Substrate thickness (m)
% tand...Loss tangent (units)
% sigma..Conductivity (Siemens/m)
% Freq...Frequency (Hz)
% VSWR...VSWR for bandwidth estimate (ratio)
%
% E.g. For a rectangular patch on 0.76mm Rogers Ro4350 Er=3.48, tand=0.004, 
%      sigma=5.8e7 (copper) Operating at 2.4GHz use :
%
%      h=0.76e-3;      
%      Er=3.48;
%      Freq=2.4e9;
%      sigma=5.8e7;
%      tand=0.004;
%      VSWR=2.0;
%      patchr_config=design_patchr(Er,h,Freq);      % patchr_config format is [Er,W,L,h].
%      W=patchr_config(1,2);
%      L=patchr_config(1,3);
%      eff=calc_patchr_eff(Er,W,L,h,tand,sigma,Freq,VSWR);
%
%
%      Some useful numbers :
%
%                CONDUCTORS                                      DIELECTRICS         
%
%        Material             Conductivity S/m           Material         Er     Tand
%
%        Perfect              9.90E+99 (lossless)        FR4_Epoxy        4.4    0.02
%        Silver               6.29E+07                   Arlon 25FR       3.43   0.0035
%        Copper               5.80E+07                   Arlon AD300      3.00   0.003
%        Pure Alumin.         3.77E+07                   Arlon AR1000    10.00   0.0035
%        Al. 6063-T832        3.08E+07                   Rogers RO3003    3.00   0.0013
%        Al. 6061-T6          2.49E+07                   Rogers RO3006    6.15   0.0025
%        Brass                1.56E+07                   Rogers RO3010   10.20   0.0035
%        Phospor bronze       9.09E+06                   Rogers RO4350    3.48   0.004
%        Stainless Steel 302  1.39E+06                   Glass             5.5   0.000
%                                                        Plexiglass        3.4   0.001
%                                                        Polyamide         4.3   0.004
%                                                        Polyester         3.2   0.003
%                                                        Polyethylene      2.25  0.001
%  
% 
%
% References : "Microstrip Antennas" I.J Bahl and P.Bhartia  
%              Published Atrech House
%              Page 60
%
%              "Advances in Microstrip and Printed Antennas"
%               Lee and Chen (Ch5)
%               



global velocity_config

if Er<=1.000001;Er=1.000001;end
if tand<=0.000001;tand=0.000001;end

Eo=8.854185e-12;       % Free space dielectric constant
Ee=Eo*Er;              % Effective dielectric constant
vo=velocity_config;
lambda=vo/Freq;



% Calculation for space and surface wave efficiency factor, gives roughly the same results.
% Reference :  "Advances in Microstrip and Printed Antennas" Lee and Chen(Ch 5) 
% Efficiency due to surface wave component, dominant for larger h/lambda values


Mur=1;
n1=sqrt(Er*Mur);
ko=2*pi*Freq*(sqrt((8.854e-12)*(pi*4e-7)));
Lo=lambda;

Psur=(1/Lo^2)*((ko*h)^3)*(60*pi^3*Mur^3*(1-1/n1^2)^3);    % Power radiated as surface wave

c1=1-1/n1^2+(2/5)/n1^4;
Pr=(1/Lo^2)*(ko*h)^2*(80*pi^2*Mur^2*c1);                  % Total power radiated

Effsw=Pr/(Pr+Psur); % Efficiency factor for surface wave losses




% Efficiency due to ohmic and dielectric losses, dominant for smaller h/lambda values
% ***********************************************************************************
% Reference : "Microstrip Antennas" Bahl and Bartia

if W<lambda
   Rr=90*lambda^2/W^2; % Radiation resistance for W<lambda
else
   Rr=120*lambda/W;    % Radiation resistance for W>lambda
end

Qr=(vo*sqrt(Ee))/(2*(Freq/1e6)*h);         % Quality factor, modified by me, not sure freq was in Ghz, more like MHz !?
Rc=(1/sigma)*0.5*sqrt(Freq)*(L/W)*Qr^2;    % Equivalent resistance for conductor loss (ohms)
Rd=(30*tand/Er)*((h*lambda)/(L*W))*Qr^2;   % Equivalent resistance for dielectric loss (ohms)

Rtot=Rr+Rd+Rc;          % Total resistance (ohms)
Effcd=Rr/Rtot;          % Efficiency factor for combined dielectric and ohmic losses

Eff1=Effsw*Effcd;  
Eff=Eff1*100;           % Total efficiency including ohmic, dielectric and surface wave losses (percent)

Qt=Qr*Eff1/(pi);        % Ref Balanis p762  ( Qtotal = Qradiated*Efficiency ) 
                        % Not the pi factor, I added that, seems necassary get sensible results using Qr from above !?

BW=(VSWR-1)/(Qt*sqrt(VSWR));

BWp=BW*100;             % Bandwidth as a percentage
BWf=BW*Freq/1e6;        % Bandwidth as a frequency span in MHz


fprintf('\nRectangular patch overall efficency %3.2f percent\n',Eff);
fprintf('Surface wave efficiency factor %3.2f\n',Effsw);
fprintf('Ohmic and dielectric efficiency factor %3.2f\n',Effcd);
fprintf('BW=%3.2f MHz for VSWR=%3.2f at Fo=%3.2f MHz\n\n',BWf,VSWR,Freq/1e6);
