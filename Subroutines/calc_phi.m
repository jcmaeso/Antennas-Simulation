function [phicut,pwrdBn]=calc_phi(phimin,phistep,phimax,theta_val,...
                                  polarisation,normalise)
% Calculates single pattern cut data in phi for specified value of theta
% no plots are generated.
%
% Usage: [phicut,pwrdBn]=calc_phi(phimin,phistep,phimax,theta_val,...
%                             polarisation,normalise)
%
% phimin........Minimum value of phi (Deg)
% phistep.......Step value for phi (Deg)
% phimax........Maximum value for phi (Deg)
% theta_val.....Theta value for phi cut (Deg)
% polarisation..Polarisation (string)
% normalise.....Normalisation (string) 
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
%               'yes'      - Normalise each pattern cut to its maximum value
%               'no'       - Directivity (dBi), no normalisation
%                            Note : calc_directivity must be run first !
%
% Returned values :
%
% phicut is of the form phicut[1,npoints]    Where npoints is the size of vector 
%                                            phimin:phistep:phimax
% pwrdBn is of the form pwrdBn[1,npoints]
%
%
% e.g. For a (0:5:360) phi cut for a theta value of 45Deg 
%      normalised to maximum use :
%      [phicut,pwrdBn]=calc_phi(0,5,360,45,'tot','yes')   
%
%         z
%         |-theta   (theta 0-180 measured from z-axis)
%         |/
%         |_____ y
%        /\
%       /-phi       (phi 0-360 measured from x-axis)
%      x    
%
global direct_config;
global normd_config;
global dBrange_config;

dBrange=dBrange_config;   % dB range for plots

 switch polarisation
 case 'tot',pol=1;
 case 'vp',pol=2;
 case 'hp',pol=3;
 case 'lhcp',pol=4;
 case 'rhcp',pol=5;
 otherwise,disp('Unknown polarisation option, use "tot","vp","hp","lhcp" or "rhcp"');...
           fprintf('Polarisation set to "tot"\n');pol=1;polarisation='tot'; 
end


if direct_config==0 & strcmp(normalise,'no')
 fprintf('Warning, directivity = 0 dBi has calc_directivity been run?\n');
 fprintf('Plot may not be scaled correctly.\n');
end


% If absolute values are plotted, setup peak directivity 
% string to add to plots and set dBmax to plot values above 0 dBi
if strcmp(normalise,'no')
 dBmax=(ceil((direct_config)/5))*5;    % Maximum dB value for plots
 Tdirec=sprintf('(Peak Directivity = %3.2f dBi)',direct_config);
else 
 dBmax=0;
 Tdirec=' ';
end
dBmin=dBmax-dBrange;            % Minimum dB value for plots

normalise_found=0;

 theta=theta_val;
 fprintf('Phi cut at Theta = %3.2f\n',theta);
 
 % Calculate the phi pattern cut for specified theta values
 [phicut,Emulti]=phi_cut(phimin,phistep,phimax,theta);  
 
 phicut=phicut';          % Phi angles in degrees transposed
 Efield=Emulti(:,pol);    % Select column vector of pattern data
                          % polarisation Etot / Evp / Ehp as required
 
 Efield=Efield';          % Transpose
 pwrdB=20*log10(abs(Efield));

 if strcmp(normalise,'yes')
  norm=max(pwrdB);
  normalise_found=1;
 end

 if strcmp(normalise,'no')
  norm=normd_config-direct_config;
  normalise_found=1;
 end

 
 if normalise_found==0
  fprintf('Invalid normalisation, use "yes" or "no"\n');
  fprintf('Normalisation set to 0\n');
  norm=0;   
 end

 pwrdBn=pwrdB-norm;
 
