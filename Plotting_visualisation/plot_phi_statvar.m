function [phicut,minpat,maxpat]=plot_phi_statvar(phimin,phistep,phimax,theta,...
                                                   polarisation,normalise,phavar,ampvar,Nruns)
% Plots pattern cuts in phi for specified value of theta and specified 
% 3sigma variations in phase and amplitude of the element excitations.
%
% Default figure(13) for cartesian display
%
% Usage: [phicut,minpat,maxpat]=plot_phi_statvar(phimin,phistep,phimax,theta,...
%                                             polarisation,normalise,phavar,ampvar,Nruns)
%
% phimin........Minimum value of phi (Deg)
% phistep.......Step value for phi (Deg)
% phimax........Maximum value for phi (Deg)
% theta.........Theta value for phi cut (Deg)
% polarisation..Polarisation (string)
% normalise.....Normalisation (string) 
% phavar........Phase variation +/- (Deg)
% ampvar........Amplitude variation +/- (dB)
% Nruns.........Number of runs (integer)
%
% Notes :
%
% The phase and amplitude variations 'phavar' and 'ampvar' are applied to the
% array as normal distributions about a mean of zero. The variance is scaled
% such that the value supplied defines the +/- 3sigma of the distribution.
%
% In other words 99.7 pcnt of the random phase values lie in the range of +/- phavar. 
% and 99.7 pcnt of the random amplitude values lie in the range of +/- ampvar. 
%
% For each of Nruns the array's phase and amplitude excitations are randomised 
% according to 'phavar' and 'ampvar'. The plots build to form an envelope of maximum
% and minimum pattern values. These are returned in minpat and maxpat, see below 
%
% Also output to the text screen is a summary of the variation statistics for each
% element. Nruns needs to be sufficiently large so the the 3sigma values are close
% the supplied values of 'phavar' and 'ampvar'
%
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
%
%               'yes'     - Normalise each pattern cut to its maximum value
%               'no'      - Directivity (dBi), no normalisation
%                            Note : calc_directivity must be run first !
%
%
%      The returned values [phicut,minpat,maxpat] are :
%               
%               phicut    - angle vector (Deg)
%               minpat    - minimum pattern values for all variations applied 
%               maxpat    - maximum pattern values for all variations applied
%
%               Each vector is of form [1,npoints]
%
% e.g. For a -90 to +90 Deg phi cut for a theta value of 90 Deg, 
%      normalised to maximum in phi=0 Deg         
%      3sigma phase variation +/- 10 Deg
%      3sigma amplitude variation +/- 1 dB
%      Run 25 times 
%
%      use :  [phicut,minpat,maxpat]=plot_phi_statvar(-90,1,90,90,'tot','yes',10,1,25);  
%
%
%         z
%         |-theta   (theta 0-180 measured from z-axis)
%         |/
%         |_____ y
%        /\
%       /-phi       (phi 0-360 measured from x-axis)
%      x    
%

global array_config;
global direct_config;
global normd_config;
global dBrange_config;
global range_config;
global freq_config;
global arrayeff_config;

[Trow,Tcol,Nele]=size(array_config);    % Number of elements in array
dBrange=dBrange_config;                 % dB range for plots

switch polarisation
 case 'tot',pol=1;
 case 'vp',pol=2;
 case 'hp',pol=3;
 case 'lhcp',pol=4;
 case 'rhcp',pol=5;
 otherwise, fprintf('\n\nUnknown polarisation options are : "tot","vp","hp","lhcp" or "rhcp"\n');...
            fprintf('Polarisation set to "tot"\n');pol=1;polarisation='tot'; 
end


switch normalise
  case 'yes',% OK
  case 'no', % OK
  otherwise, disp('\nUnknown normalisation, options are : "yes" or "no"');...
            fprintf('Normalisation set to "yes"\n');normalise='yes';
end


if direct_config==0 & strcmp(normalise,'no')
 fprintf('\nWarning, directivity = 0 dBi has calc_directivity been run?\n');
 fprintf('Plot may not be scaled correctly.\n');
end

% If absolute (no normalisation ) is requested, setup peak directivity 
% string to add to plots and set dBmax to plot values above 0 dBi
if strcmp(normalise,'no')
 dBmax=(ceil((direct_config)/5))*5;                                    % Maximum dB value for plots
   if arrayeff_config<100
      Tdirec=sprintf('(Peak Gain = %3.2f dB)',direct_config);
   else
      Tdirec=sprintf('(Peak Directivity = %3.2f dBi)',direct_config);
   end 
else 
 dBmax=0;
 Tdirec='(Normalised to 0dB)';
end
dBmin=dBmax-dBrange;                                                     % Minimum dB value for plots

                                                                           


fprintf('\n\nCalculating the effect of phase and or amplitude variations\n');
fprintf('Specified max Phase range is +/- %g Deg for 99.7 pcnt of values\n',phavar);
fprintf('Specified max Ampl  range is +/- %g dB  for 99.7 pcnt of values\n',ampvar);

fprintf('\nReference Run (1 of %i)\n',Nruns);    
tic;
[phi,RefPat]=calc_phi(phimin,phistep,phimax,...
                          theta,polarisation,normalise);                % Calculate pattern with no errors applied
cut_time=toc;
fprintf('Estimated calculation time %5.1f seconds\n',cut_time*Nruns);

BarLen=40;                                                              % Progress bar length (space characters)
BarStep=(Nruns)/(BarLen);                                               % Bar step length as a proportion of theta(max)=pi
BarProg=0;
fprintf('|');
for n=1:1:(BarLen)
 fprintf(' ');
end
fprintf('|\n..');


array_config1=array_config;                                             % Make a copy of the array configuration file

Ntheta=((phimax-phimin)/phistep)+1;                                     % Number of theta steps
Pats=zeros(Nruns,Ntheta);                                               % Init array to store patterns
PhaErr=zeros(Nruns,Nele);                                               % Init array for Phase variations
AmpErr=zeros(Nruns,Nele);                                               % Init array for Amplitude variations

figure(12);
clf;
hold on;
chartname=sprintf('Phi-cut StatVar');
set(12,'name',chartname);

for n=1:Nruns                                                           % Loop through the desired number of runs (Nruns)
 while (n>BarProg) & ((BarProg+BarStep)<=Nruns)
  fprintf('.');                                                         % Progress bar
  BarProg=BarProg+BarStep;
end

array_config=array_config1;                                             % Reset the array_config to original design values
 for elenum=1:1:Nele;                                                   % Loop through elements
   PhaErr(n,elenum)=(randn(1)*(phavar/3))*pi/180;                       % Random Phase Error (Deg)
   AmpErr(n,elenum)=10.^((randn(1)*((ampvar/3)))/20);                   % Random Amplitude Error (Lin Volts)
   array_config(2,5,elenum)=array_config(2,5,elenum)+PhaErr(n,elenum);  % Add random phase variation to array_config values
   array_config(1,5,elenum)=array_config(1,5,elenum)*AmpErr(n,elenum);  % Add random amplitude variation to array_config values
 end
 
 % list_array(0)
 
 % Calculate the pattern cut data
 [phicut,Emulti]=phi_cut(phimin,phistep,phimax,theta);  
 phicut=phicut';                                                        % Theta angles in degrees transposed
 Efield=Emulti(:,pol);                                                  % Select column vector of pattern data
                                                                        % polarisation Etot / Evp / Ehp as required
 Efield=Efield';                                                        % Transpose
 pwrdB=20*log10(abs(Efield));                                           % Convert to log power

 switch normalise
  case 'yes',norm1=max(pwrdB);                                          % Normalised to 0dB
  case 'no', norm1=normd_config-direct_config;                          % Absolute in dBi
 end

 pwrdBn=pwrdB-norm1;                                                    % Apply appropriate normalisation
 Pats(n,:)=pwrdBn;                                                      % Store the patterns as rows in matrix Pats
 plot(phi,pwrdBn,'color',[0.4,1,0.4],'linewidth',2);                    % Plot statistically varied patterns
end

array_config=array_config1;                                             % Restore original array configuration
minpat=min(Pats);
maxpat=max(Pats);

plot(phi,maxpat,'color',[0,0.85,0],'linewidth',2);                      % Plot max envelope of pattern variations
plot(phi,minpat,'color',[0,0.85,0],'linewidth',2);                      % Plot min envelope of pattern variations
plot(phi,RefPat,'color',[0.8,0,0],'linewidth',2);                       % Plot reference pattern, with no variations

axis([phimin,phimax,-dBrange,dBmax]);
xlabel('Phi Degrees');
ylabel('dB');
T1=sprintf('Patterns for 3-sigma excitation variations of +/- %g Deg and +/- %g dB',phavar,ampvar);
title(T1);

textsc(0.02,0.95,[upper(polarisation),' Phi-Cut']);
T2=sprintf('Theta = %4.2f',theta);
T3=sprintf('Nruns = %i',Nruns);
textsc(0.02,0.91,T2);
textsc(0.02,0.87,T3);

grid on;
zoom on;

PhaErrStd3=std(PhaErr*180/pi)*3;    % 3-sigma value for phases, for all elements (Deg)
PhaErrMin=min(PhaErr*180/pi);       % min phase for all elements (Deg)
PhaErrMax=max(PhaErr*180/pi);       % max phase for all elements (Deg)

AmpErrStd3=std(20*log10(AmpErr))*3; % 3-sigma value for amplitudes for all elements (dB)
AmpErrMin=min(20*log10(AmpErr));    % min amplitude for all elements (dB)
AmpErrMax=max(20*log10(AmpErr));    % max amplitude for all elements (dB)

fprintf('\n\n                     Element Excitation Statistics\n');
fprintf('                     =============================\n\n');

fprintf('                PHASE (Deg)                  AMPLITUDE (dB)\n')
fprintf('Element  3*StdDev  Min       Max       3*StdDev  Min       Max\n');

for n=1:Nele
 fprintf('%5i%10.4f%10.4f%10.4f%10.4f%10.4f%10.4f\n',n,...
          PhaErrStd3(1,n),PhaErrMin(1,n),PhaErrMax(1,n),...
          AmpErrStd3(1,n),AmpErrMin(1,n),AmpErrMax(1,n)); 
end


