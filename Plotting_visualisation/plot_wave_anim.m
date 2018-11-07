function [M]=plot_wave_anim(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
                 xoff,yoff,zoff,polarisation,fignum1,fignum2) 
% Plot E-field parameters visualised as a 3D wave surface added to the figure 
% specified by fignum1 and then animate it in the figure specified in fignum2.
% Note that this function is for visualisation only. The parameters for the 
% animation are stored in the global variable waveanim_config see init.m
%
% The plotted wave is based on the relation : WaveAmp=Amp*cos(Phase)
%
% Where : Amp   is 20*log10(E(x,y,z)) normalised and then scaled to lambda (m)
%         Phase is Phase(E(x,y,z))
%
% This gives a 3D repesentation of the wave that is well proportioned for plotting
% and decays with increasing distance from the source.
%
% The plot_wave_slice function is used to dynamically illustrate the propagation of
% waves. A series of plots are made with different element phases and then 
% animated using Matlab's 'movie' function. See the exanim1 and exanim2 examples.
%
%
% Usage: [M]=plot_wave_anim(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,...
%                 xoff,yoff,zoff,polarisation,fignum1,fignum2)
%
% M.........Movie data, use command : movie(M,10,8) to play returned movie 10 times at 8 fps 
%
% xrng......Slice dimensions in x-direction before rotations and offsets are applied (m)
% xsteps....Number of steps in x-direction (m)
% yrng......Slice dimensions in y-direction before rotations and offsets are applied (m)
% ysteps....Number of steps in y-direction (m)
%
% xrot......Rotation about x-axis (Deg)
% yrot......Rotation about y-axis (Deg)
% zrot......Rotation about z-axis (Deg)
% 
% xoff......Offset in x direction (m)
% yoff......Offset in y direction (m)
% zoff......Offset in z direction (m)
%
%
% Options for polarisation are :
%  
%               'tot'   - Total E-field
%               'vp'    - Vertical polarisation (Z-axis in global coords)
%               'hp'    - Horizontal polarisation (X-Y plane in global coords)
%
% fignum1...Figure for ploting the wave-slice frames for the animation
% fignum2...Figure for playing the movie
%
%
% Notes on using the plot_wave_anim function :-
%
%  The wave slice is defined as a grid in a 'local' coordinate system according
%  to the definition : X=-xrng/2:xstep:xrng/2, Y=-yrng/2:ystep:yrng/2), Z=0.
%  This grid is then subject to 3 rotations and 3 offsets to place it in the 'global'
%  system of coordinates used for the antenna.
%
%  IMPORTANT ! The rotations are applied to the fixed X,Y,Z axes in the order : 
%              X-rotation,Y-rotation,Z-rotation followed by the X,Y,Z offsets.
%
%              Positive rotation is defined as :  
%              Clockwise about axis looking towards the origin
%
%                +Z
%                 |
%                 | Field slice, local coordinate system : origin os
%                 |                                        x-axis xs
%                 |                                        y-axis ys
%            os---|----ys   <----- -xrng/2
%            /    |___ /_______ +Y    
%           /    /    /             
%         xs ---/----    <----- +xrng/2
%              /
%        /    /    /
%   -yrng/2  /  +yrng/2
%           /
%         +X
%
% If you want save the frames as individual image files for compilation into an 
% animated gif, look at lines 170 to 180 in this file.
%
% See the Animated GIFs sub-directory in the documentation for the exanim1/2/3 examples
% compiled as animations.

global freq_config
global waveanim_config
global array_config
global velocity_config;


vo=velocity_config;
lambda=vo/(freq_config);        % Calculate wavelength (m)

% Parameters for 3D view and animation
AZ=waveanim_config(1,1);        % Azimuth angle for 3D view (deg)
EL=waveanim_config(1,2);        % Elevation angle for 3D view (deg)
phastep=waveanim_config(1,3);   % Phase increment for animation (deg)
cycles=waveanim_config(1,4);    % Number of cycles for the movie
fps=waveanim_config(1,5);       % Number of frames per second
plotgeom=waveanim_config(1,6);  % Plot 3D array geometry option 1=yes 0=no

% *************  Plot patterns *************

[Trow,Tcol,Nsrce]=size(array_config);  % Number of elements in array N

plot_geom3d1(1,0,fignum1);             % Plot 3D geometry with axis in fignum1
figure(fignum1);
view([AZ,EL]);                         % Select view
Xdim=600;
Ydim=500;
Xorig=200;
Yorig=100;
set(gcf,'Position',[Xorig Yorig (Xorig+Xdim) (Yorig+Ydim)]);


% Make first plot so axis scaling can be found for all subsequent calls to generate the movie frames
% **************************************************************************************************

warning off;         % Somes Matlab version compatibility issues with plot shading and scaling
plot_wave_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation,fignum1)
figure(fignum1);     % Select figure to plot frames for the animation
axis equal
shading interp;
colorbar;
ax=axis;      % Store axis values for use in the next section

% ***************************************************************************
% Store the amplitudes and phases of each element before phase is incremented
% ***************************************************************************
for n=1:1:Nsrce
   Amp(n)=20*log10(array_config(1,5,n));
   Phase(n)=(array_config(2,5,n))*180/pi;
end

% *********************
% Generate movie frames
% *********************

Nsteps=360/phastep;
M = moviein(Nsteps,gcf);    % Reserve space for movie frames using the number of frames and (gcf)
j=0;
fprintf('\nGenerating movie frames....\n');
for PhaseInc=0:phastep:(360-Nsteps)
   j=j+1;
   fprintf('\nFRAME %g of %g  (Phase= %3.1f Deg)\n\n',j,Nsteps,PhaseInc);
   for srce=1:Nsrce
      excite_element(srce,Amp(srce),mod((Phase(srce)+PhaseInc),360));
   end   
   figure(fignum1)
   clf;
   if plotgeom==1
      plot_geom3d1(1,0,fignum1);   % Plot 3D geometry with axis in current frame
   end   
   view([AZ,EL]);         % Select view
    
   plot_wave_slice1(xrng,xsteps,yrng,ysteps,xrot,yrot,zrot,xoff,yoff,zoff,polarisation,fignum1);
   figure(fignum1);     % Select figure to plot frames in
   axis('equal');       % Set axis parameters using previously stored values
   axis(ax);
   shading interp;
   colorbar;

   Tunit='m';
   Ttext=sprintf('3D Geometry %s Wave Animation (%s)\n%3.2f MHz',upper(polarisation),Tunit,freq_config/1e6);
   title(Ttext);
   
   h=gcf;
   M(:,j)=getframe(gcf); % Store the frame in matrix M
   
   
   % Un-comment and modify as required the lines below to write the 'Frames' to separate
   % image files, in a suitable directory. Use the free 'UnFREEz 2.1' software (or many others)
   % to turn the individual images into an animated gif. 'IrfanView' is useful for batch 
   % conversion of tiffs to gifs.
   %                                      Save frames as individual files
   % ===================================================================================================================
     %DirName='c:\Temp\';          % Put your preferred directory in here.
     %FMT='tif';                   % Format of image files 'jpeg','tiff','bmp' and possibly 'gif' on later Matlab vers.
     %FileName=sprintf('%sframe%s.%s',DirName,char(j+64),FMT)   % Use filename format frameA,frameB..
     %[X,MAP]=frame2im(M(:,j));    % Convert the j(th) movie frame to an image
     %imwrite(X,MAP,FileName,FMT); % Write the image to file
   % ===================================================================================================================
end

% *****************
% Display the movie
% *****************

figure(fignum1);  %  Plot window for frames of movie
set(gcf,'name','Wave Frames');
figure(fignum2);  % Plot window to show movie in
set(gcf,'name','Wave Animation');

set(gcf,'Position',[Xorig Yorig (Xorig+Xdim) (Yorig+Ydim)]);
movie(gcf,M,cycles,fps,[10,10,0,0]); % Play movie 10 cycles, 8 fps in current figure at 10,10 pix from lower left
warning on;
fprintf('\nTo replay movie (now stored in variable M) in figure %g, type : ''replay(M,%g)'' \n\n',fignum2,fignum2);
