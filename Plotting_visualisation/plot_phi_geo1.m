function [phicut,pwrdBn]=plot_phi_geo1(phimin,phistep,phimax,theta,...
                                         polarisation,normalise,linestyle,fignum)
% Plots a single pattern cut in phi for a specified value of theta.
%
% Adding to specified 3D geometry plot (fignum)
%
% Usage: [phi,pwrdB]=plot_phi_geo1(phimin,phistep,phimax,theta,...
%                                    polarisation,normalise,linestyle,fignum)
%   
% phimin........Minimum value of phi (Deg)
% phistep.......Step value for phi (Deg)
% phimax........Maximum value for phi (Deg)
% theta.........Theta value for phi cut (Deg)
% polarisation..Polarisation (string)
% normalise.....Normalisation (string)
% linestyle.....Line Style (Standard Matlab)
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
%               'yes'     - Normalise pattern cut to its maximum value
%               'no'      - Directivity (dBi), no normalisation
%                           Note : calc_directivity must be run first !
%
%
% e.g. For a 0-360 Deg phi cut for theta value of 90 Deg 
%      normalised to maximum, in red, on figure1, use :
%
%      [phi,pwrdB]=plot_phi(0,1,360,[90],'tot','yes','r-',1)   
%   
%
%      The returned values [phi,pwrdB] correspond to the last cut requested.
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

if direct_config==0 & strcmp(normalise,'none')
 fprintf('\nWarning, directivity = 0 dBi has calc_directivity been run?\n');
 fprintf('Plot may not be scaled correctly.\n');
end

% If absolute values are plotted, setup peak directivity 
% string to add to plots and set dBmax to plot values above 0 dBi
if strcmp(normalise,'none')
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
 fprintf('Phi cut at Theta = %3.2f\n',theta);
 pcolour=linestyle;         % Plot colour string

 % Calculate the phi pattern cut for specified theta values
 [phicut,Emulti]=phi_cut(phimin,phistep,phimax,theta);  
 
 phicut=phicut';            % Theta angles in degrees transposed
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

 phiplot=phicut.*pi./180;                      % Convert phi values to radians
 thetaplot=ones(size(phicut)).*theta.*pi./180; % Set up plot vector of phi values
 R=pwrdBplot;                                  % Radius is equal to pattern power in dB
 R=(R+R.*sign(R))/2;                           % Limit negative values to 0
 [x,y,z]=sph2cart1(R,thetaplot,phiplot);       % Calculate x,y,z coord for plotting
 plot3(x,y,z,pcolour,'linewidth',2);           % Plot


end 
