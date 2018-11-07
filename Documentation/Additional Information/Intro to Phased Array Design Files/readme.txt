Description of files associated with document : 

       Introduction to Array Design
       ============================

Excel Files
===========
6-Way Splitter.xls        6-way power splitter design, gives the 
                          required 1/4 wave transformer impedances.

Aperture_Calculation.xls  Gives 3dB beam widths and directivity for       
                          specified rectangular aperture.

ArrayCalc Files
===============
These are MATLAB m-files that require the Array Design Toolbox v1.1
to be present (MATLAB v5.1 on).

ExAp1.m                   Models a 4-lambda by 1-lambda rectangular
                          aperture as an array of lambda/100 dipoles

ExAp2.m                   Models a 4-lambda line source using decreasing      
                          numbers of dipole elements

ExDip1.m                  Models the 6-element dipole array



MATLAB Files
============
These require only basic MATLAB 5.1 onwards

Chebwin1.m                Calculates Chebyshev coefficients for an N-element array
                          to give specified sidelobe suppression, for all sidelobes.
                          Gives the same results as the MATLAB chebwin.m
                          except the algorithm is a little easier to follow.

ModTaylor.m               Calculates Modified Taylor coefficients for an N-element array
                          to give specified sidelobe suppression for 1st side-lobe, others
                          decrease as for unifom distribution.

QUCS Files
==========
6-way2.sch                Schematic for 6-way power splitter.

6-way2.dpl                Results display configuration.



4NEC2 Files
===========
Input files for use with 4NEC2 by Arie Voors


Array 6-ele (a/b).nec            Array of 6 dipoles fed using individual excitations 
                                 over a finite gridded ground plane. Dipoles tuned for
                                 resonance in the presence of the ground plane.
                                 (Version a Amplitude taper only)
                                 (Version b Amplitude and Phase taper)

Array 6-ele feed.nec             Array of 6 dipoles fed using 6-way power splitter, 
                                 dipoles tuned for free-space.
                               
Array 6-ele feed corr dip.nec    Array of 6 dipoles fed using 6-way power splitter, 
                                 dipoles tuned for operation over ground plane.

Array 6-ele feed corr full.nec   Array of 6 dipoles fed using 6-way power splitter,
                                 dipoles tuned for operation over ground plane and
                                 matched to correct for mutual coupling.