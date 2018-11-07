function [phicut,pwrdBn]=plot_phi(phimin,phistep,phimax,theta_list,...
                                  polarisation,normalise)
% Plots pattern cuts in phi for specified values of theta
%
% Default figure(4) for cartesian display
% Default figure(5) for polar display
%
% Usage: [phi,pwrdB]=plot_phi(phimin,phistep,phimax,theta_list,...
%                             polarisation,normalise)
%
% phimin........Minimum value of phi (Deg)
% phistep.......Step value for phi (Deg)
% phimax........Maximum value for phi (Deg)
% theta_list....List of Theta values for phi cut (Deg)
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
%               'first'    - Normalise all cuts to first pattern's maximum value
%               'each'     - Normalise each pattern cut to its maximum value
%               'none'     - Directivity (dBi), no normalisation
%                            Note : calc_directivity must be run first !
%
%
% e.g. For two 360Deg phi cuts for theta values of 90 and 45 Deg 
%      normalised to maximum in theta=90 Deg cut use :
%      [phi,pwrdB]=plot_phi(0,1,360,[90,45],'tot','first')   
%
%      The returned values [phi,pwrdB] correspond to the last plot requested
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
dBmin=dBmax-dBrange;            % Minimum dB value for plots

[row,N]=size(theta_list);       % Number of cuts

plotcolourlist=['r','g','b','c','m','y','r','g','b','c','m','y']; 


figure(5);
polaxis(dBmin,dBmax,5,15);   % Plot polar axis
hold on;

fprintf('\n');
normalise_found=0;

for n=1:N
 theta=theta_list(1,n);
 fprintf('Phi cut at Theta = %3.2f\n',theta);
 pcolour=[plotcolourlist(1,n),'-'];             % Plot colour string

 % Calculate the phi pattern cut for specified theta values
 [phicut,Emulti]=phi_cut(phimin,phistep,phimax,theta);  
 
 phicut=phicut';          % Phi angles in degrees transposed
 Efield=Emulti(:,pol);    % Select column vector of pattern data
                          % polarisation Etot / Evp / Ehp as required
 
 Efield=Efield';          % Transpose
 pwrdB=20*log10(abs(Efield));

 if strcmp(normalise,'first') & n==1
  norm=max(pwrdB);
  normalise_found=1;
 end

 if strcmp(normalise,'each')
  norm=max(pwrdB);
  normalise_found=1;
 end

 if strcmp(normalise,'none')
  norm=normd_config-direct_config;
  normalise_found=1;
 end

 
 if normalise_found==0
  fprintf('Invalid normalisation, use "first","each" or "none"\n');
  fprintf('Normalisation set to 0\n');
  norm=0;   
 end

 pwrdBn=pwrdB-norm;

 
 figure(1);                                    % Add plots to 3D geom
 hold on;
 AX=max(axis);
 axis([-AX AX -AX AX -AX AX]);
 SF=AX;
 pwrdBplot=(pwrdBn+dBrange_config).*SF./dBrange_config; 

 phiplot=phicut.*pi./180;                      % Convert phi values to radians
 thetaplot=ones(size(phicut)).*theta.*pi./180; % Set up plot vector of phi values
 R=pwrdBplot;                                  % Radius is equal to pattern power in dB
 R=(R+R.*sign(R))/2;                           % Limit negative values to 0
 [x,y,z]=sph2cart1(R,thetaplot,phiplot);       % Calculate x,y,z coord for plotting
 plot3(x,y,z,pcolour,'linewidth',2);           % Plot


 figure(4); % Cartesiasn plots
 plot(phicut,pwrdBn,pcolour,'LineWidth',2);            % Phi pattern cut
 hold on;
 chartname=sprintf('Phi-cut Rect');
 set(4,'name',chartname);


 figure(5); % Polar plots
 polplot(phicut,pwrdBn,dBmin,pcolour,'LineWidth',2);   % Phi pattern cut
 chartname=sprintf('Phi-cut Polar');
 set(5,'name',chartname);

end 


% Add legend to Cartesian plot
figure(4); 
axis([phimin phimax dBmin dBmax]);
plot([phimin,phimax],[-3,-3],'k:');  % Put -3dB line on plot
lx=0.66;   % Top left of legend list on graph is at (fx,fy)
ly=0.25;   % Screen coords are (0,0) bottom left (1,1) top right

k=1;
for i=1:N,
  pcolour=[plotcolourlist(1,i),'-'];          % Plot colour string
  T1=sprintf('Theta = %g',theta_list(1,i));   % Theta cut label
  plotsc((lx-0.05),(ly-k.*0.03),(lx-0.01),(ly-k.*0.03),pcolour);
  textsc(lx,((ly)-(k).*0.03),T1);
  k=k+1;
end
T1=['Phi ',upper(polarisation),' pattern cuts for specified Theta  ',Tdirec];
title(T1);
Tfreq=sprintf('Freq %g MHz',freq_config/1e6);
textsc(-0.085,-0.085,Tfreq);
xlabel('Phi Degrees');
ylabel('dB')
grid on;
zoom on;


% Add legend to Polar plot

figure(5);  
circ((-dBmin-3),'k:');  % Put -3dB circle  (-dBmin is 0 dB on the polar plot)
lx=0.85;    % Top left of legend list on graph is at (fx,fy)
ly=0.2;     % Screen coords are (0,0) bottom left (1,1) top right

k=1;
for i=1:N,
  pcolour=[plotcolourlist(1,i),'-'];            % Plot colour string
  T1=sprintf('Theta = %g',theta_list(1,i));     % Theta cut label
  plotsc((lx-0.05),(ly-k.*0.03),(lx-0.01),(ly-k.*0.03),pcolour);
  textsc(lx,((ly)-(k).*0.03),T1);
  k=k+1;
end
Ttitle=['Phi ',upper(polarisation),' pattern cuts for specified Theta'];
textsc(-0.25,1.05,Ttitle);
textsc(-0.25,1.00,Tdirec);
Tfreq=sprintf('Freq %g MHz',freq_config/1e6);
textsc(-0.25,0,Tfreq);