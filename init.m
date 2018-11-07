% Initialise main variables

% Un-comment the line below if you are getting messages : 'Warning: Unrecognized OpenGL version, defaulting to 1.0.'
% opengl neverselect     % Change the OpenGL select mode

% Define global configuration variables

global array_config;    % Array of element data : position, excitation, and type
global arraypwr_config; % Total power input into the array in Watts, used in field-slice calculations.
global arrayeff_config; % Array efficiency (percent)
global interp_config;   % Either empty or a copy of array_config, used to pass geometry info to interp_geom.m
global freq_config;     % Analysis frequency (Hz)
global velocity_config; % Wave Propagation velocity (m/s)
global impedance_config;% Impedance of propagation medium (ohms)

global range_config;    % Radius at which to sum element field contributions in (m),
                        % max recommended value 200,000 lambda => max aperture of 316 lambda
                        % and still satisfy (2*D^2)/lambda condition for far-field.  

global direct_config;   % Directivity value (dBi)
global phaseq_config;   % Quantisation of phase shifter (n bits) 
                        % number of levels=360/(2^n)
                        
global normd_config;    % Normalisation factor for pattern i.e. the value
                        % of the Etot pattern at the point of max directivity.
                        % Value is used to normalise pattern before directivity
                        % is added (dB)
                        
global dBrange_config;  % Dynamic range for plots (min dB value)
global waveanim_config; % View angle and movie parameters for wave animation

global patchr_config;   % Rectangular patch element parameters
global patchc_config;   % Circular patch element parameters
global dipole_config;   % Dipole parameters
global dipoleg_config;  % Dipole over ground parameters
global helix_config;    % Helix parameters
global aprect_config;   % Rectangular aperture parameters
global apcirc_config;   % Circular aperture paramters
global wgr_config;      % Rectangular waveguide parameters
global wgc_config;      % Circular waveguide parameters
global dish_config;     % Parabolic dish paramters
global pattern_config;  % Pattern data for interpolated element pattern
global user1_config;    % User element parameters


% array_config : Array of form (3x5xN)
%                Defining element orientation, location, 
%                excitation and type.
%
% For each of n=1:N elements there is a 3x5 element
% matrix which defines the element's location, orientation
% excitation and type.
%
%                     /---------- 3x3 rotation matrix
%                    /    /------ 3x1 offset matrix
%                   /    /   /--- Amplitude,Phase,ElementType (1,2,3..)
%                  /    /   /
%               ----- ---- ---
%               L M N Xoff Amp
%   3x5 matrix  O P Q Yoff Pha
%               R S T Zoff Elt
%
%   Valid strings for eltype are listed below. 
%              STRING    VALUE IN array_config
%              'iso'             0
%              'patchr'          1
%              'patchc'          2
%              'dipole'          3
%              'dipoleg'         4
%              'helix'           5
%              'aprect'          6
%              'apcirc'          7
%              'wgr'             8
%              'wgc'             9
%              'dish'            10
%              'interp'          11
%              'user1'           12
%
%    Amplitude is stored as (linear volts)  
%    Phase is stored as (radians)


array_config=-ones(3,5,1);  % Initialise element array for a single element
interp_config=[];           % Initialise interp_config 
arraypwr_config=100;        % Set total input power into the array to 100 (W)
arrayeff_config=100;        % Set array efficiency to 100%
freq_config=300e6;          % Set analysis frequency to 300MHz (lambda=1m)
velocity_config=3e8;        % Set wave propagation velocity to 3e8 (m/s)
impedance_config=377;       % Set impedance of propagation medium to 377 (ohms)
range_config=999;           % Set radius for summation of field contributions to 999 (m) 
                            % max recommended value 200,000 lambda (m)

direct_config=0;            % Set Directivity to 0dBi
phaseq_config=16;           % Set quantisation of phase shifter to 16 bits 
                            % (360/65535=0.0055deg)

normd_config=0;             % Set normalisation factor to 0dB
dBrange_config=40;          % Set dynamic range for plots to 40dB (min dB value)

AZ=140;                     % Set Azimuth view angle for the 3D plot to 140 (deg)      
EL=40;                      % Set Elevation angle for the 3D plot to 40 (deg)     
phastep=30;                 % Set Phase increment for the animation to 30 (deg)
cycles=10;                  % Set Number of cycles of the movie to 10
fps=8;                      % Set Number of frames per second to 8
plotgeom=1;                 % Option to add 3D geometry to wave animation
waveanim_config=[AZ,EL,phastep,cycles,fps,plotgeom];     % Define vector of parameters                      
                          
% Dipole parameters
length=0.5;              % Length (m)
dipole_config=length;    % Define vector of parameters

% Dipole over ground parameters
len=0.5;                 % Length (m)
h=0.25;                  % Height above ground (m)
dipoleg_config=[len,h];  % Define vector of parameters

% Rectangular patch parameters
Er=1;                     % Dielectric constant for substrate
W=0.5;                    % Patch width (m) affects H-plane beamwidth
L=0.431;                  % Patch length (m) affects E-plane beamwidth
h=0.05;                   % Patch height (m) affects E & H plane beamwidth
patchr_config=[Er,W,L,h]; % Define vector of parameters

% Circular patch parameters
Er=1;                     % Dielectric constant for substrate
a=0.2;                    % Patch radius (m) affects H-plane beamwidth
h=0.05;                   % Patch height (m) affects E & H plane beamwidth
patchc_config=[Er,a,h];   % Define vector of parameters

% Helix parameters
N=6;                     % Number of turns
S=0.27;                  % Turn spacing (m)
helix_config=[N,S];      % Define vector of parameters

% Rectangular aperture parameters
a=0.1;                   % Aperture dimension in x-axis (m)
b=0.5;                   % Aperture dimension in y-axis (m)
aprect_config=[a,b];

% Circular aperture parameters
d=0.5;                   % Aperture diameter (m)
apcirc_config=[d];

% Rectangular waveguide parameters
a=0.1;                   % Guide dimension in x-axis (m)
b=0.5;                   % Guide dimension in y-axis (m)
wgr_config=[a,b];

% Circular waveguide parameters
d=0.5;                   % Guide diameter (m)
wgc_config=[d];

% Parabolic dish parameters
d=4.0;                   % Dish diameter (m)
n=2.0;                   % Aperture taper factor (unitless)
t=10;                    % Taper value at edge of dish, relative to maximum (dB)
dish_config=[d,n,t];


% User Element1 params
Parameter1=1;              
Parameter2=2;
user1_config=[Parameter1,Parameter2];