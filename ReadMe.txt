To add the ArrayCalc V2.5 toolbox to MATLAB :

UnZip the files, resulting in a directory structure
that should look like this :

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


Ideally the path to ArrayCalc should be :

c:\matlab\toolbox\ArrayCalc

If not then the validation examples val1-6 & ex3a will
not run, the path to the NEC output files will need to be
changed in LoadNecPat1.m in the Validation directory. 
Type help LoadNecPat1 for more information.

Once copied into the MATLAB directory the appropriate
paths will have to be added in the usual way.

help ArrayCalc : Gives the contents file listing
help Exlist    : Lists all the example files.

Tip : If you get odd errors with some but not all examples,
      check that there is not a command conflict with another
      Matlab command, most likely in another toolbox. 
      
      Type help 'offending command' and check the help information
      against that listed in the commands section of the user Guide.

      Toolboxes that may cause conflicts : Control System
                                           RF Toolbox
                                           Robust Control
                                           System Control


Tip : To zoom in/out on plots in early versions of 
      Matlab try using the following at the command
      prompt.  

      ax=axis;
      axis=(ax/zoomfactor);

      % Zoomfactor>1 to zoom in
      % Zoomfactor<1 to zoom out 

Have fun !!!!!

