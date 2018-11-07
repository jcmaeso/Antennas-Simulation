% LIST OF EXAMPLES FOR V2.5
%
% ex1.......Single microstrip patch
% ex2a/b....5x5 Array of dipoles over groundplane 
% ex3a/b/c..NEC/General pattern import, use of 'interp' element
% ex4.......Endfire array, Hansen Woodyard condition
% ex5.......3x(Vertical arrays of dipoles over ground)
%
% exap1...........Comparison of aperture and array antennas
% exap2...........As above with varying numbers of sources
% excirc1.........Circular polarisation using crossed dipoles (method1)
% excirc2.........Circular polarisation using crossed dipoles (method2)
% excirc3a/b/c....Circularly polarised patch array (3-methods)
% exdist..........Comparison of different amplitude distributions
% exfourier1/2/3..Beam synthesis using fourier transform
% exlms1..........Beam synthesis using least mean square optimisation
% exgeopat........Overlaying patterns and array geometry
% exinter.........Interferometer using 2 dishes
% exrhomb.........Example using the rhombic array
% exloop..........Loop antenna modelled with very short dipoles
% exstatvar1/2....Statistical variation of element excitations
% extaywin1/2.....Amplitude tapering of a 2D array using taywin_array
% exspinlin1/2....Simulations of spin-linear axial ratio measurements
%
% extpgeo.........Display theta (EL) and phi (AZ) patterns on 3D geom plot  
%
% exlogo..........ArrayCalc Logo : 3D plot of 64-element rectangular array,
%                 takes about 10mins on a 1GHz machine - time for a coffee!
%
% extestsub1/2/3..Examples showing the use of sub-arrays.
% exparab.........Highly simplified reflector modelling.
% exparabpol......Slighty more advanced reflector modelling.
% exoffreflector..Illustrates standing waves in the near-field of an offset reflector.
%
% expointsrce1....Example using plot_field_slice to show field pattern from a point source.
% exdipoles.......Field pattern around a pair of dipoles.
%
% extotpower......Verification of the plot_field_slice function's ability to 
%                 calculate absolute values of power density (W/m^2)
%
% exdoubleslit....Example using plot_field_slice to illustrate the classic
%                 double-slit fringe pattern.
%
% exoam1/2/3......Examples showing the production of Orbital Angular Momentum
%                 (OAM) and the use of plot_field_slice to analyse it.
%                 For more information on OAM, see 'Orbital Angular Momentum.pdf'
%                 in the Additional Information folder of the documentation.
%
% excoverage......Example showing the calculation of antenna coverage in W/m^2 
%
% exrtpslice......Example showing how to place a field slice aperture using spherical (R,theta,phi)
%                 coordinates, and then calculate the total power intercepted by it in Watts. 
%                 It also includes use of the calculate patch efficiency function. 
%
% exanim1/2/3.....Examples using plot_wave_anim to make and show movies of wave
%                 propagation. IMPORTANT : These examples are likely to be very
%                 dependent on Matlab version and graphics card. If you have problems
%                 running old versions of Matlab on new machines, try reducing the 
%                 colour range on your display driver e.g. 16bit instead of 32 or 24bit.
%
% exultrason1/2...Examples of ultrasound modelling of a simple sonar array and a sparce version.
% exultrason3.....Example analysis of a multi-focal-point medical imaging transducer.
%
% extransducer....Patterns for circular aperture transducers of different diameter/wavelength ratios.
%
% tutorial1a/b....Simple dipole directivity and patterns
% tutorial2a......Comparing patterns for different array geometrys
% 
% VALIDATION DIRECTORY
%
% val1/2/3-6......Validation examples against NEC2
% valdipoles1/2/3.Validation of near-field calculations against 4NEC2
% ef1/2/3-7.......Validation examples of various single patches against Ansoft Designer v2.2
% ef1_4element....Validation of 4-element array against Ansoft Designer v2.2
%
% verify_elepat...Plots of element model patterns in linear form.
%

help exlist
