% ArrayCalc V2.5
%
% Directories : ArrayCalc
%                       |___ Beam_synthesis
%                       |___ Documentation
%                       |___ Element_indexing
%                       |___ Element_models
%                       |___ Examples
%                       |___ Geometry_construction
%                       |___ Plotting_visualisation
%                       |___ Subroutines
%                       |___ Validation
%
%   MAIN DIRECTORY
%
%   init              - Initialise global variables
%   exlist            - Display a list of the examples
%
%   BEAM SYNTHESIS
%
%   Utilities, hopefully to be expanded with beam profiling, nulling etc 
%
%   modtaylor         - Modified taylor distribution for discrete elements
%   chebwin1          - Chebyshev distribution for discrete elements
%   binomial1         - Binomial distribution for discrete elements
%   fourier1          - Fourier transform based beam synthesis
%   lmsoptimise       - Signal to noise optimisation for array 
%   norm_array        - Rescale the linear amplitudes of the element excitations such
%                       that they sum to unity, the relative power levels remain un-changed.
%
%   ELEMENT INDEXING
%   
%   Main routines that need to be altered when adding new element models.
%
%   ELEMENT MODELS
%
%   patchr            - Rectangular microstrip patch element model
%   patchr_geom       - Patch geometry (pictorial only)
%  
%   patchc            - Circular microstrip patch element model
%   patchc_geom       - Patch geometry (pictorial only)
%
%   helix             - Endfire helix element model
%   helix_geom        - Helix geometry (pictorial only)
%
%   dipole            - Thin wire dipole model
%   dipole_geom       - Dipole geometry (pictorial only)
%
%   dipoleg           - Thin wire dipole over groundplane model
%   dipoleg_geom      - Dipole over ground geometry (pictorial only)
%
%   aprect            - Rectangular aperture model
%   aprect_geom       - Rectangular aperture geometry (pictorial only)
%
%   apcirc            - Circular aperture model
%   apcirc_geom       - Circular aperture geometry (pictorial only)
%
%   wgr               - Rectangular waveguide model
%   wgr_geom          - Rectangular waveguide geometry (pictorial only)
%
%   wgc               - Circular waveguide model
%   wgc_geom          - Circular waveguide geometry (pictorial only)
%
%   dish              - Parabolic dish model
%   dish_geom         - Dish geometry (pictorial only)
%
%   interpl           - Interpolated data option (filename is interpl not interp due to naming confilt)
%   interp_geom       - User defined geometry (pictorial only)
%
%
%   GEOMETRY CONSTRUCTION
%
%   place_element     - Place an element in specified orientation and location
%   single_element    - As above, but without orientation (default values used)
%   excite_element    - Set amplitude and phase for specified element
%
%   rect_array        - Generate rectangular array geometry using specified elements
%   rhomb_array       - As rectangular except alternate rows can be offset
%   cylin_array       - Generate cylindrical array geometry using specified elements
%   circ_array        - Generate circular array geometry using specified elements
%
%   squint_array      - Sets element phases to point main beam in specified direction
%   focus_array       - As for squint_array except there is a focal distance argument
%   taywin_array      - Apply modified Taylor amplitude distribution to array
%
%   move_array        - Move selected array elements in x, y and z
%   movec_array       - Copy selected elements to relative x,y,z location
%   centre_array      - Moves entire array so the extents are equidistant from the origin
%
%   xrot_array        - Rotate selected elements around X-axis
%   yrot_array        - Rotate selected elements around Y-axis
%   zrot_array        - Rotate selected elements around Z-axis
%
%   xrotc_array       - Copy and rotate selected elements around X-axis
%   yrotc_array       - Copy and rotate selected elements around Y-axis
%   zrotc_array       - Copy and rotate selected elements around Z-axis
%
%   cpol_array        - Circularly polarises an existing array by duplicating array 
%                       elements with versions orthogonal in phase and orientation. 
%
%   clear_array       - Delete all array elements
%
%
%   PLOTTING and VISUALISATION
%
%   plot_theta         - Calculate and plot theta patterns for specified values of phi
%   plot_squint_theta  - Calc and plot theta patterns for specified theta squint values
%   plot_theta_statvar - Calculate max/min theta pattern envelope due to normally distributed
%                        variations in ampl and phase excitations.
%
%   plot_phi           - Calculate and plot phi patterns for specified values of theta
%   plot_squint_phi    - Calc and plot phi patterns for specified phi squint values
%   plot_phi_statvar   - Calculate max/min phi pattern envelope due to normally distributed
%                        variations in ampl and phase excitations.
%
%   plot_geom3D        - Display array geometry as 3D plot
%   plot_geom3D1       - As above except figure number can be specified
%
%   plot_geom2D        - Display array geometry as 2D plot
%
%   plot_pattern3D     - Plot 3D pattern surface
%   plot_pattern3D1    - As above except with additional parameter of figure number 
%
%   plot_geopat3D      - Plot 3D pattern and array geometry on the same plot
%   plot_geopat3D1     - As above except with additional parameter of figure number
%
%   plot_theta_geo1    - Add theta pattern cuts to 3D geometry plot
%
%   plot_phi_geo1      - Add phi pattern cuts to 3D geometry plot
%
%   list_array         - List array element locations and excitations
%   plegend            - Put a single legend line on a plot at specified screen co-ordinates
%
%
%   Near Field Plotting Functions
%   -----------------------------
% 
%   plot_field_slice   - Plot E-field parameters as a slice through 3D space
%   plot_field_slice1  - As above except with additional parameter of figure numbers
%
%   plot_wave_slice    - Plot E-field parameters visualised as a 3D wave surface added
%                        to the 3D geometry plot if present (default figure1)
%   plot_wave_slice1   - Plot E-field parameters visualised as a 3D wave surface added
%                        to the specified figure
%
%   plot_wave_anim     - Plot E-field parameters visualised as a 3D wave surface and then
%                        animate it. Separate figures are specifed for the frames and the 
%                        subsequent animation.
%   replay             - Replay movie generated by plot_wave_anim
%
%   plot_line_slice    - Plot E-field parameters as a function of distance along a line through 
%                        3D space.
%
%
%   CALCULATION SUBROUTINES
%
%   calc_directivity  - Calculate array directivity using numerical integration
%                       the value can then be used by plot routines, to plot
%                       absolute directivity in dBi
%
%   fieldsum          - Calculate tot,vert,horiz,lhcp,rhcp,AR,TauDeg,Phase,Phavp and Phahp at specified farfield point
%   polaxis           - Draw a set of polar axis
%   polplot           - Plot pattern data in polar form
%   circ              - Plot circle (used for polar axis)
%   local2global      - Convert local element coords to global coord system 
%   coord2troff       - Generate rotn & offset matrices from 4pts specified in 2 coord systems
%   sph2cart1         - Spherical to cartesian coord conversion, see Note1
%   cart2sph1         - Cartesian to spherical coord conversion, see Note1 
%                       Note1 : Different angle definitions to Matlab's standard
%
%   theta_cut         - Calculate E-field [theta,[tot,vp,hp,lhcp,rhcp,AR,TauDeg,Phase,Phavp,Phahp]] pattern cut data
%                       over theta range for specified phi
%
%   phi_cut           - Calculate E-field [phi,[tot,vp,hp,lhcp,rhcp,AR,TauDeg,Phase,Phavp,Phahp]] pattern cut data
%                       over phi range for specified theta
%
%   calc_theta        - Calculate theta pattern data [theta,Pwr(dB)] 
%                       for specified value of phi
%
%   calc_phi          - Calculate phi pattern cut data [phi,Pwr(dB)]
%                       for specified value of theta
%
%   rotx              - Generate rotation matrix for rotation about X-axis
%   roty              - Generate rotation matrix for rotation about Y-axis
%   rotz              - Generate rotation matrix for rotation about Z-axis
%
%   textsc            - Put text on plot at screen coords
%   plotsc            - Plot lines at screen coords
%
%   design_helix      - Returns helix_config parameters for optimum endfire helix, given
%                       number of turns and the frequency
%
%   design_patchr     - Returns patchr_config parameters for optimum half-wave rectangular
%                       microstrip patch, given the substrate Er & h and the frequency 
%
%   design_patchc     - Returns patchc_config parameters for optimum half-wave circular
%                       microstrip patch, given the substrate Er & h and the frequency 
%
%   calc_patchr_eff   - Estimate efficiency and bandwidth of a rectangular patch
%   calc_patchc_eff   - Estimate efficiency and bandwidth of a circular patch
%
%  
%   VALIDATION
%
%   Comparisons between ArrayCalc and NEC2 results
%
%   loadnecpat        - Load NEC2 radiation pattern data into 
%                       pattern_config (11 columns)
%
%   loadnecpat1       - Load NEC2 radiation pattern data into 
%                       pattern_config (3 columns) theta,phi,Pwr(tot)
%
%   val1              - Validation1 : 2 dipoles 0.7 lambda spacing,
%                       rotated 25Deg about the Y-axis.
%
%   val2	      - A 5x5 array of half-wave dipoles 0.25 lambda 
%		        above a groundplane.
%
%   val3	      - A 3x3 array of 3-turn helicies on a groundplane, 
%                       0.7 lambda spacing.
%
%   val4	      - A 2x2 array of 6-turn helicies on a groundplane,
%                       1.2 lambda spacing.
%
%   val5              - 3 slant (45deg) dipoles spaced evenly around a
%                       circle radius 0.4 lambda.
%
%   val6              - 4 tiers of 3 slant dipoles spaced evenly around a
%                       circle radius 0.4 lambda. Tier spacing 0.8 lambda
%
%   Comparisons between ArrayCalc and AnsoftDesigner v2.2
%
%   ef1/2/3-7         - Validation examples of various single patches.
%   ef1_4element      - Validation of 4-element array.
%
%
%   GLOBAL VARIABLES (defined in init.m)
%
%   array_config      - Array of element data : position, excitation, and type
%   arraypwr_config   - Total power input into the array in Watts, used in field-slice calculations.
%   arrayeff_config   - Array efficiency (percent)
%   freq_config       - Analysis frequency (Hz)
%   velocity_config   - Wave propagation velocity (m/s)
%   impedance_config  - Impedance of propagation medium (ohms)
%   range_config      - Radius at which to sum element field contributions (m)
%                       should be set to value >>(2D^2/lambda) D=max aperture dimension
%
%   direct_config     - Directivity (dBi)
%   phaseq_config     - Phase quantisation for beam steering (n-bits) 
%                       giving 360/(2^n) phase step size
%
%   normd_config      - Pattern normalisation value, used with directivity calc.  
%   dBrange_config    - Dynamic range for plots (dB)
%
%   waveanim_config   - View angle and movie parameters for wave animation
%
%   patchr_config     - Rectangular patch element parameters
%   patchc_config     - Circular patch element parameters
%   dipole_config     - Dipole parameters
%   dipoleg_config    - Dipole over ground parameters
%   helix_config      - Helix parameters
%   aprect_config     - Rectangular aperture parameters
%   apcirc_config     - Circular aperture parameters
%   wgr_config        - Rectangular waveguide parameters
%   wgc_config        - Circular waveguide parameters
%   dish_config       - Parabolic dish parameters
%   pattern_config    - Pattern data for interpolated element pattern
%   user1_config      - User element parameters
%
%
%   N. Tucker www.activefrance.com 2015