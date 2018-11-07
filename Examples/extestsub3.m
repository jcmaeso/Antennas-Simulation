% SUB-ARRAY EXAMPLE3 (extestsub3) 
%
%
% Description :
%
% A sub-array of 7 patches is defined and then used as the array element.
% For verification the array of sub-arrays is only 3x2 elements, this of
% course can be changed as required, see file (line 174).
%
% The actual sub-array configuration of un-equal patch spacing is not the norm
% but is to illustrate the flexibility of the sub-array definition. 
%
% Detail :
% 
% In the first section of code a sub-array is defined and set of 3D pattern data
% calculated. The pattern data is assembled into an array variable pattern_config 
% according to the requirements of the 'interp' element (see help interp). 
% 
% The pattern data variable is saved in a file called subarray1.mat
%
% In the second section (which could easily be a separate m-file) the subarray1.mat 
% is loaded. By loading this file, pattern_config is available as the current
% 'interp' element, which can then be used as normal.
%
% Figure 1  shows the geometry for the sub-array detail (1x7 patches)
% Figure 21 shows the geometry for the array of sub-arrays.
% 
% Figure 22 shows the Phi=90 (z-y plane) cut for the sub-array and array of sub-arrays.
%           These are the same, as you would expect in this cut.
%
% Figure 23 shows the Phi=0 (z-x plane) cut for the sub-array and array of sub-arrays.
%           This shows the effect of the increased number of elements in the x-dimension.
%
% Caution :
%
% This method assumes that the the sub-array has an E-field vector parallel to the x-axis
% when it was defined, as with any of the other elements. Sub-arrays are therefore limited
% to linear polarisation. Rotationally symmetric sub-arrays maybe circularly polarised by
% super-imposing an orthogonal copy (phase and orientation) when the sub-array is arrayed.
%
% The sub-array pattern data must be calculated with a resolution such that the 
% the interpolated values will have all the necessary details. 
%
% For graphical representation a new global variable is used, interp_config. This is actually
% just a copy of array_config and is used to pass the sub-array geometry to interp_geom.
% If you are using measured pattern data for the 'interp' element you may want to specify your
% own graphical representation. See inside interp_geom.m in the element model directory for details.
%
% Note :- When dealing with large numbers of elements, keep an eye on the theta/phi
%         increments for plotting and calculating sub-array pattern data, it is easy
%         to get aliasing problems due to under sampling of the pattern. 
%
% Other possibilities :
%
% For really arbitrary configurations it may be better to write a small routine to define
% sub-arrays using the standard elements. These can then be copied, moved and rotated as
% required using the array construction commands.




close all
clc

help extestsub3


init;                                                  % Initialise global variables
freq_config=2.45e9;                                    % Specify frequency
lambda=3e8/freq_config;                                % Calculate wavelength

Er=3.48;                                               % Dielectric const
h=1.6e-3;                                              % Substrate thickness (m)
patchr_config=design_patchr(Er,h,freq_config);         % Use design_patchr to assign the patchr_config
            

% Simple matrix representation for an arbitrary sub-array,
% each row is of the form :
% x(units) y(units) z(units) Pwr(dB) Pha(Deg)

xyzPwrPha=[...
-2.0,   0, 0, 0, 0; 
-1.2,   0, 0, 0, 0; 
-0.5,   0, 0, 0, 0; 
 0.0,   0, 0, 0, 0; 
+0.5,   0, 0, 0, 0; 
+1.2,   0, 0, 0, 0;
+2.0,   0, 0, 0, 0];

xyzPwrPha(:,1:3)=xyzPwrPha(:,1:3)*lambda; % Scale the x,y,z coordinates by lambda
                                          % just comment out this line if you want the units to be meters.





% **** Use the sub-array description to fill the array_config matrix ****** 

[Row,Col]=size(xyzPwrPha);
Nele=Row;                     % Nele is the number of elements in the sub-array

for r=1:1:Nele                % Loop through the elements
 x=xyzPwrPha(r,1);            % x-coord
 y=xyzPwrPha(r,2);            % y-coord
 z=xyzPwrPha(r,3);            % z-coord

 Pwr=xyzPwrPha(r,4);          % Power (dB)
 Pha=xyzPwrPha(r,5);          % Phase (Deg)

 single_element(x,y,z,'patchr',Pwr,Pha);
end
centre_array;      % Centre the sub-array 



% ***** Draw the sub-array geom and take phi=0,90 cuts for comparison ***** 

list_array(0);         % Print sub-array details to screen
plot_geom3d1(1,0,21);  % Plot sub-array 3D geometry on figure(21)

plot_theta_geo1(-90,1,90,[0],'tot','yes','r-',21);      % Add patterns to 3D geometry plot (fig 21)
plot_theta_geo1(-90,1,90,[90],'tot','yes','g-',21);     % Add patterns to 3D geometry plot (fig 21)
                                                       
[SUBtheta0a,SUBpat0a]=calc_theta(-90,2,90,0,'tot','yes');      % Phi=0 pattern for comparison with 'interp' version
[SUBtheta90a,SUBpat90a]=calc_theta(-90,2,90,90,'tot','yes');   % Phi=90 pattern for comparison with 'interp' version



% ****************** Generate the sub-array pattern data *******************
fprintf('\nGenerating sub-array full-sphere pattern data>>>>>>>\n\n');


dth=2;                                                         % Theta stepsize for sub-array pattern (Deg)
dphi=10;                                                       % Phi stepsize for sub-array pattern (Deg)

for phi=0:dphi:360
 [SUBtheta,SUBpat]=calc_theta(0,dth,180,phi,'tot','yes');      % Theta cut for specified Phi
 SUBphi=phi.*ones(size(SUBtheta));                             % Define a vector for the Phi value
 PatData1=[SUBtheta' SUBphi' SUBpat'];                         % Construct the pattern data array for current Phi value
 if phi==0
  PatData=PatData1;
 else
  PatData=[PatData;PatData1];                                  % Assemble the pattern data array
 end
end

pattern_config=PatData;                                        % Assign the pattern_config variable
save subarray1 pattern_config;                                 % Pattern saved as .mat file and loaded as required
 
% **************************************************************************


fprintf('\n\nPress RETURN to continue\n\n');
pause;
fprintf('Calculating patterns for array of sub-arrays >>>>>>>>\n\n');


% *************************  Array the Sub-array ***************************

% This section could be in a separate m-file, assuming the sub-arrays have already been saved.


global interp_config;                                  % A new variable for graphical display only
interp_config=array_config;                            % Pass coordinates of sub-array elements into interp_geom via global
                                                       % variable interp_config.

clear_array;                                           % Re-initialise array_config matrix, other variables unchanged


load subarray1                                         % Global variable pattern_config now contains the sub-array pattern
                                                       % The data in pattern_config is used by the 'interp' array element

 
rect_array(2,3,lambda*4.5,lambda*0.5,'interp',0);      % Array definition using the sub-array element ('interp')
                                                       % Noting the physical dimensions of the sub-array so they do
                                                       % not overlap.



list_array(0);                                         % List the new array of 'interp' (sub-array) elements to screen
plot_geom3d(1,0);                                      % Plot the array of sub-arrays geometry on figure(1)
plot_theta(-90,1,90,[0,90],'tot','first');             % Plot total power theta patterns -90 to +90 deg in 1deg steps
                                                       % for phi angles of 0,90. Normalise to the max of the 
                                                       % 'first' cut (phi=0).

[SUBtheta0b,SUBpat0b]=calc_theta(-90,1,90,0,'tot','yes');      % Phi=0 pattern using 'interp'
[SUBtheta90b,SUBpat90b]=calc_theta(-90,2,90,90,'tot','yes');   % Phi=90 pattern using 'interp' 


% Plot original sub-array data and 'interp' data for comparison on figures(22 and 23)

figure(22);
plot(SUBtheta90a,SUBpat90a,'r',SUBtheta90b,SUBpat90b,'b');    % Phi=90 comparison
axis([-90 90 -40 0]);
legend('Single Sub-Array','Array of Sub-Arrays',4);
title('Theta-cut for Phi=90');


figure(23);
plot(SUBtheta0a,SUBpat0a,'r',SUBtheta0b,SUBpat0b,'b');        % Phi=0 comparison
axis([-90 90 -40 0]);
legend('Single Sub-Array','Array of Sub-Arrays',4);
title('Theta-cut for Phi=0');
