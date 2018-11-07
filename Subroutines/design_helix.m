function helixcfg=design_helix(N,Freq)
% Returns the helix_config parameters for endfire helix.
% Helix turn circumference and turn spacing are calculated
% and returned together with supplied parameter N.
%
% Returned values are in the same format as the global helix_config
% variable, so can be assigned directly. The helix_config variable is
% of the following form [N,S].
%
% Usage: helix_config=design_helix(N,Freq)
%
% N.....Number of turns (integer) 
% Freq...Frequency (Hz)
%
% Design is for a helix that is approximated well by the model i.e.
% Number of turns, N > 3
% Ratio of S/C  = 0.2217  (helix pitch angle of 12.5 Deg)
% C is set = (1.2)*Lambda
%
% Note : The printed values are in easier to read units of MHz and cm
%
% e.g. helix_config=design_helix(6,1e9)

% Reference Kraus 2nd Edition Page 273 Fig 7-10 Operating modes
% of helix chart.

global velocity_config

vo=velocity_config;
lambda=vo/Freq;
PitchDeg=12.5;

C=lambda*1.2;
S=C*sin((PitchDeg)*pi/180);

helixcfg=[N,S];

fprintf('\nEndfire Helix Design\n');
fprintf('Frequency       : %1.3f MHz\n',Freq/1e6);
fprintf('Number of Turns : %i\n',N);
fprintf('Turn Spacing S  : %1.3f cm   %1.3f lambda\n',S*100,(S/lambda));
fprintf('Turn Circum C   : %1.3f cm   %1.3f lambda\n',C*100,(C/lambda));
fprintf('S/C Ratio       : %1.3f\n',S/C);
fprintf('Pitch Ang alpha : %1.3f Deg\n\n',PitchDeg);
