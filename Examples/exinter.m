% RADIO TELESCOPE INTERFEROMETER (exinter)
% 
% In this example 2 x 4m diameter dishes are positioned
% 10m apart to form an interferometer. An arrangement frequently
% used in radio-astronomy applications.
%
% Notice how the fringing pattern in the phi=0 cut, follows
% the envelope of the phi=90 pattern.
%
% If the antenna is swept past a celestial radio-source in the phi=0
% plane. There are two main possibilities for the received signal :
%
% 1) If the radio-source is dimensionally small and subtends an angle 
%    approximately the same or smaller than the width of a single fringe
%    lobe. Then the received signal will appear as a replication of the 
%    fringing pattern.
%
% 2) If the radio-source is dimensionally large and subtends an angle
%    covering many fringe lobes. Then the received signal will appear 
%    as an integration of the fringing pattern and more like the phi=90 
%    pattern.
%
% By making measurements of the same radio-source with different dish 
% spacings, the point at which 'pattern integration' begins can give
% the astronomer a good indication as to the size of the radio source.
% In this way dimensionally small radio-sources can be resolved without
% the need for a huge dish (of diameter equal to the separation of the
% smaller dishes). 
%  
% There is of course a downside to this approach, which is that it does
% not provide the same directive gain as a single large dish and is 
% therefore less able to detect weak radio-sources.
%  
%
% Note : When using large apertures the default range_config value of 999m
%        may not be large enough to meet the (2*D^2)/Lambda far-field criteria.
%        I have found that the maximum value for range_config is around 200,000 lambda.
%        This corresponds to an aperture of 316 lambda and hence the maximum
%        antenna aperture that can be analysed.
% 
%        Beyond 200,000 lambda and the internal trig calculations begin to break down.



close all
clc

help exinter;

init;                      % Initialise global variables

Dia=4;                     % Dish diameter (m)
Sep=10;                    % Dish separation (m)  Max is about 200(m) at 1420 MHz


freq_config=1420e6;        % Specify frequency (Hz)  Hydrogen Line reception
lambda=3e8/freq_config;    % Calculate wavelength (m)
dish_config=[Dia,2.5,10];  % Set up dish parameters, (Dia)m dish with 10dB edge taper
range_config=2e6;          % Set summing distance commensurate with larger apertures
                           % The upper limit for range_config is around 2e6 corresponding
                           % to an aperture of around 1000 lambda, using (2*D^2)/Lambda.

rect_array(2,1,Sep,0,'dish',0)
list_array(0);

plot_geom3d(1,0);
figure(1);
view(-50,25);
ax=axis;
axis(ax);
plot_theta(-30,0.05,30,[0,90],'tot','each'); 
