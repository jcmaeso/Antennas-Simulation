function []=loadnecpat1(file)
% 
% Post processing for '.nou' Nec output files 
% and is designed to be used on any specified .nou file.
%
% Saves 3 columns of pattern data (see below)
%
% Usage   : loadnecpat1('filename')
%
% Note    : filename does not require path or extension as these are defined
%           in variables 'filepath' and 'extension' in this function 
%           (they can of course be changed)
% 
% Example : To process file 'C:\4nec2\out\antenna1.nou' 
%           Set filepath to 'C:\4nec2\out\' (See first 2 variables in this function)
%           Set extension to '.nou'         (See first 2 variables in this function)
%
%           At the command prompt type : loadnecpat1('antenna1')
%
% Each separate pattern found is automatically saved as .mat data file.
% For example if 3 patterns are found, 3 files will be generated :
% 
% Files  : pattern1.mat
%          pattern2.mat
%          pattern3.mat
%
% Matlab's default location for these is c:\matlab\toolbox\bin
%
% To load the data simply type : load 'filemame' The data
% will then be in variable 'pattern_config', regardless of file name.
% The data is in column format.
%
% e.g.     load pattern2
%          x_data=pattern_config(:,1)
%          y_data=pattern_config(:,3)
%          plot(x_data,y_data)
%
% LoadNecPat1 loads only 3 cols of NEC pattern :
%
% Column in raw data :   Col1       Col2      Col5
%                       theta(deg) phi(deg)  Pwr(dB)
%
% SEE ALSO  LoadNecPat to load all 11 cols of NEC pattern

%    FILE PATH EXTENSIONS 
%*******************************

%filepath='c:\4nec2\out\';
%extension='.out';

%filepath='c:\NEC-PRO\examples\';
%extension='.nou';

filepath='c:\matlab\toolbox\arraycalc\validation\';
extension='.out';

%*******************************

global config_pattern;

postproc_filename=[filepath,file,extension];

% Initialise and read files

fid_in=fopen(postproc_filename,'r');

if fid_in==-1
   fprintf('\n File Not Found :   %s   \n',postproc_filename);
   break
end

fprintf('\n Reading NEC pattern data from %s\n',postproc_filename);

F=fread(fid_in);                                     % Load the file as an ASCII array F
fclose(fid_in);                                      % Close input file channel
F=F';
[Rows,Cols]=size(F);                                 % Cols is the number of chrs in the file
file_size=Cols;   



count=0;                                                     % Init counter to read thru ASCII file
Nfreqs=0;                                                    % Init counter for number of Frequencies
Nsource=0;                                                   % Number of sources



% ****************************************************
% ********* Find out how many sources there are ******
% ****************************************************

 S_FRQ='***** DATA';                                 % Define search string '***** DATA'
 P_FRQ=findstr(F,S_FRQ);                             % Find occurances of '***** DATA' in ASCII array F. 
                                                     % P_FRQ is an array of pointers to the letter '*' in '***** DATA'
 [Row,Col]=size(P_FRQ);
 Nfreqs=Col;                                         % Cols is the number of frequencies
 for x=1:Nfreqs                                      % Loop through the array of pointers to the letter '*'
    st_ptr=P_FRQ(1,x)+21;                            % Define a start pointer, offset to the beginning of the numeric value
    end_ptr=st_ptr+107;                              % Define an end pointer offset to the end of the numeric value
    %Freq(1,x)=str2num(char(F(1,st_ptr:end_ptr)));   % Extract the numeric value and pop it in an array called Freq
    A=sscanf(setstr(F(1,st_ptr:end_ptr)),'%f %s %i %i %i %i %f %f %f %f %f %f');
    A=A';
    if char(A(1,2:3))=='EX'                          % Look for occurances of the 'EX' excitation card
       Nsource=Nsource+1;
    end   
 end
Nsource;
fprintf('\n %g Source(s) Found\n',Nsource);


% ****************************************************
% ***** Find out which Frequencies were analysed *****
% ****************************************************


S_FRQ='FREQUENCY=';                                          % Define search string 'FREQUENCY='
P_FRQ=findstr(F,S_FRQ);                                      % Find occurances of 'FREQUENCY=' in ASCII array F. 
                                                             % P_FRQ is an array of pointers to the letter 'F' in 'FREQUENCY='
[Row,Col]=size(P_FRQ);
Nfreqs=Col;                                                  % Cols is the number of frequencies
for x=1:Nfreqs                                               % Loop through the array of pointers to the letter 'F'
   st_ptr=P_FRQ(1,x)+10;                                     % Define a start pointer, offset to the beginning of the numeric value
   end_ptr=st_ptr+11;                                        % Define an end pointer offset to the end of the numeric value
   Freq(1,x)=sscanf(setstr(F(1,st_ptr:end_ptr)),'%f');       % Extract the numeric value and pop it in an array called Freq

end

fprintf(' START Frequency %g MHz\n',Freq(1,1));
fprintf(' STOP  Frequency %g MHz\n',Freq(1,Nfreqs));
fprintf(' Number Of Frequencies : %g \n',Nfreqs);



% ****************************************************
% ******** Extract the Radiation Patterns  ***********
% ****************************************************


S_FRQ='RADIATION PATTERNS';           % Define search string 'RADIATION PATTERNS'
P_FRQ=findstr(F,S_FRQ);               % Find occurances of 'RADIATION PATTERNS' in ASCII array F. 
                                      % P_FRQ is an array of pointers to the letter 'R' in 'RADIATION PATTERNS'
[Row,Col]=size(P_FRQ);
Npats=Col;                            % Number of patterns i.e. number of times S_FRQ was found in F             
Tpat=' ';
                                                             
if ~isempty(P_FRQ);                                          % Extract currents if any have been found                                                             
   fprintf('\n %i Radiation Pattern(s) Found\n',Npats);                                                             
     for x=1:Npats 
       st_ptr=P_FRQ(1,x)+394;                                % Pointer position for data start (394 characters on form the 'R' in RADIATION            
       index=1;
       pattern=ones(1,11);
       while isempty(findstr(Tpat,'*')) & end_ptr<file_size      % Read lines (122 chrs) until the next data card ('*') or the file end.
         end_ptr=st_ptr+122;                                     % Define an end pointer offset to the end of the numeric value
         Tpat=(char(F(1,st_ptr:end_ptr)));                       % Put the characters between the pointers into a string
         Tpat1=[Tpat(1:65),Tpat(72:122)];                        % Get rid of the sense strings 'LEFT', 'RIGHT' or 'LINEAR' that may be present
         if isempty(findstr(Tpat,'*'))                           % Presence of a '*' in the data block indicates the next data card i.e. End of pattern
           P1=sscanf(Tpat1,'%f %f %f %f %f %f %f %f %f %f %f');  % Extract the numeric value and pop it in an array called Current
           pattern(index,:)=P1';                                 % Fill the pattern matrix by rowc
         end       
         index=index+1;           % Increment index
         st_ptr=end_ptr;          % Move the start pointer to the start of the next data block
       end
       Tpat=' ';                  % Clear the Tpat string
       pattern_config=[pattern(:,1),pattern(:,2),pattern(:,5)];  % Construct output array from seleted NEC data
                                                                 % Cols 1,2 & 5 are theta(deg),phi(deg) and Power(dB)
       SavePat=sprintf('save pattern%i pattern_config\n',x);     % Set up command string
       eval(SavePat);                                            % Execute it
       fprintf(' Saving pattern%i\n',x);                         % Tell user
     end
end 

