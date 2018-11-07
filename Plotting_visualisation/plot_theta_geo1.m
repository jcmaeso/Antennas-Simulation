function [thetacut,pwrdBn]=plot_theta_geo1(thetamin,thetastep,thetamax,phi,...
                                         polarisation,normalise,linestyle,fignum)
% Plots a single pattern cut in theta for a specified value of phi.
%
% Adding to specified 3D geometry plot (fignum)
%
% Usage: [theta,pwrdB]=plot_theta_geo1(thetamin,thetastep,thetamax,phi,...
%                                    polarisation,normalise,linestyle,fignum)
%   
% thetamin......Minimum value of theta (Deg)
% thetastep.....Step value for theta (Deg)
% thetamax......Maximum value for theta (Deg)
% phi...........Phi value for theta cut (Deg)
% polarisation..Polarisation (string)
% normalise.....Normalisation (string) 
% linestyle.....Line style (Standard Matlab)
% fignum........Figure number (integer)
% 
% Options for polarisation are :
%  
%               'tot' - Total E-field
%               'vp'  - Vertical polarisation
%               'hp'  - Horizontal polarisation
%               'lhcp' - Left Hand circular polarisation
%               'rhcp' - Right Hand circular polarisation
%
% Options for normalise are : 
%
%               'yes'    - Normalise pattern cut to its maximum value     
%               'no'     - Directivity (dBi), no normalisation
%                          Note : calc_directivity must be run first !
%
%
% e.g. For a -90 to +90 Deg theta cut for phi value of 0,  
%      normalised to maximum, in red, on figure1, use :
%
%      [theta,pwrdB]=plot_theta_geo1(-90,1,90,[0],'tot','yes','r-',1)   
%
%      The returned values [theta,pwrdB] correspond to the last cut requested.
%
%         z
%         |-theta   (theta 0-180 measured from z-axis)
%         |/
%         |_____ y
%        /\
%       /-phi       (phi 0-360 measured from x-axis)
%      x    
%

figure(fignum);
hold on;

AX=max(axis);
AX=AX*(1.0);
axis([-AX AX -AX AX -AX AX]);
SF=AX;

global direct_config;
global dBrange_config;
global normd_config;
global freq_config;
global arrayeff_config;

dBrange=dBrange_config;   % dB range for plots

switch polarisation
 case 'tot',pol=1;
 case 'vp',pol=2;
 case 'hp',pol=3;
 case 'lhcp',pol=4;
 case 'rhcp',pol=5;
 otherwise,fprintf('\n\nUnknown polarisation options are : "tot","vp","hp","lhcp","rhcp"\n');...
           fprintf('Polarisation set to "tot"\n');pol=1;polarisation='tot'; 
end

if direct_config==0 & strcmp(normalise,'no')
 fprintf('\nWarning, directivity = 0 dBi has calc_directivity been run?\n');
 fprintf('Plot may not be scaled correctly.\n');
end

% If absolute values are plotted, setup peak directivity 
% string to add to plots and set dBmax to plot values above 0 dBi
if strcmp(normalise,'no')
 dBmax=(ceil((direct_config)/5))*5;    % Maximum dB value for plots
  if arrayeff_config<100
      Tdirec=sprintf('(Peak Gain = %3.2f dB)',direct_config);
  else
     Tdirec=sprintf('(Peak Directivity = %3.2f dBi)',direct_config);
  end   
else 
 dBmax=0;
 Tdirec=' ';
end
dBmin=dBmax-dBrange;          % Minimum dB value for plots


fprintf('\n');
normalise_found=0;

for n=1:1
 
 fprintf('Theta cut at Phi = %3.2f\n',phi);
 pcolour=linestyle;          % Plot colour string

 % Calculate the theta pattern cut for specified phi values
 [thetacut,Emulti]=theta_cut(thetamin,thetastep,thetamax,phi);  
 
 thetacut=thetacut';        % Theta angles in degrees transposed
 Efield=Emulti(:,pol);      % Select column vector of pattern data
                            % polarisation Etot / Evp / Ehp as required
 
 Efield=Efield';            % Transpose
 pwrdB=20*log10(abs(Efield));


 if strcmp(normalise,'yes')
  norm=max(pwrdB);
  normalise_found=1;
 end

 if strcmp(normalise,'no')
  %norm=normd_config-direct_config;
  norm=normd_config;
  normalise_found=1;
 end

 
 if normalise_found==0
  fprintf('Invalid normalisation, use "yes" or "no"\n');
  fprintf('Normalisation set to 0\n');
  norm=0;   
 end

 pwrdBn=pwrdB-norm;                                     % Apply appropriate normalisation

 % Scale the pattern to fit on the geometry axes
 % pwrdBplot=(pwrdBn+dBrange_config).*SF./(max(pwrdBn)+dBrange_config); 
  pwrdBplot=(pwrdBn+dBrange_config).*SF./dBrange_config; 

 thetaplot=thetacut.*pi./180;                  % Convert theta values to radians
 phiplot=ones(size(thetacut)).*phi.*pi./180;   % Set up plot vector of phi values
 R=pwrdBplot;                                  % Radius is equal to pattern power in dB
 R=(R+R.*sign(R))/2;                           % Limit negative values to 0
 [x,y,z]=sph2cart1(R,thetaplot,phiplot);       % Calculate x,y,z coord for plotting
 plot3(x,y,z,pcolour,'linewidth',2);           % Plot


end 

