clear clc
init;                      % Initialise global variables
%Generate Parameters file
generateParameters('array_parameter_multiplebeam.mat');
beamFileName = 'beamData';
%Multiple beams formation
%Angles
beamWidth = 6.3; %degrees
totalWidth = 75; %degrees
numberOfBeams = ceil(totalWidth/beamWidth) + 2;
limitAngle = 37.5; %degree
thetaAngles = linspace(-limitAngle,limitAngle,numberOfBeams);
for currentAngle = 1:numberOfBeams
    %load parameters
    load('array_parameter_multiplebeam.mat');
    %Array generation
    alphac = 0;
    for i = 0:1:(M-1)
        alphac = rad2deg(2*pi*i*xspc*sin(deg2rad(thetaAngles(currentAngle))));
        fprintf("phase %f \n",alphac);
        for j = 0:1:(N-1)
            single_element(i*xspc*lambda,j*yspc*lambda,0,'patchr',wind(j+1,i+1),alphac);
        end
    end
    %Field diagram plotting
    centre_array;
    [thetaMax,phiMax] = calc_directivity(3,15);
    %plot_geopat3d(3,15,'tot','no','surf',1);

    [thetacut,Emulti]=theta_cut(-90,0.1,90,0);  
    thetacut=thetacut';        % Theta angles in degrees transposed
    Efield=Emulti(:,1);
    figure(4);
    pwrdB=20*log10(abs(Efield));
    plot(thetacut,pwrdB);          % Theta pattern cut
    filename = strcat(beamFileName,num2str(currentAngle));
    save(filename,'pwrdB');
    clear clc
    fprintf('Generated %d',currentAngle);
end 
