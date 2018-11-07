clear clc
init;                      % Initialise global variables

freq_config=7.804e9;        % Specify frequency
lambda=3e8/freq_config;    % Calculate wavelength

AngBarrido=deg2rad([-37.5,-18.75,0,18.75,37.5]);

alpha=-2*pi*0.5*cos(AngBarrido);        % Desfasaje necesario
alpha = alpha(1);
patchr_config=design_patchr(3.43,1.6e-3,freq_config);

% Array Parameters

M=18;       % Number of elements in X-direction
N=22;       % Number of elements in Y-direction
T=M*N;     % Total number of circ-pol elements
xspc=0.5;  % Array spacing in the X-direction
yspc=0.5;  % Array spacing in the Y-direction

sll = 25;
rwind = chebwin1(M, sll)';
rwind = repmat(rwind,N,1);
%Calculate Column Taper
sll = 25;
cwind = chebwin(N, sll)';
cwind = repmat(cwind.',1,M);
%Calculate taper
wind = 20*log10(rwind.*cwind);
% % Increase beamsize for phi = 0;
% k = 5;
% for i = 1:1:20
%    wind(:,i) = wind(:,i) - k
%     if i < 11
%         k = k - 0.5;
%     else 
%         k = k + 0.5;
%     end 
% end

alphac = 0;
for i = 0:1:(M-1)
    alphac = rad2deg(2*pi*i*xspc*sin(deg2rad(-18.75)));
    fprintf("phase %f \n",alphac);
    for j = 0:1:(N-1)
        single_element(i*xspc*lambda,j*yspc*lambda,0,'patchr',wind(j+1,i+1),alphac);
    end
end
 
centre_array;
plot_geom3d(1,0);
[thetaMax,phiMax] = calc_directivity(3,15);
plot_theta(-90,0.1,90,[0],'tot','none');
%plot_geopat3d(3,15,'tot','no','surf',1);

%% Extract current settings
[thetacut,Emulti]=theta_cut(-90,0.1,90,0);  
thetacut=thetacut';        % Theta angles in degrees transposed
Efield=Emulti(:,1);
figure(4);
pwrdB=20*log10(abs(Efield));
plot(thetacut,pwrdB);          % Theta pattern cut


