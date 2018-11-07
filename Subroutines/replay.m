function replay(M,fignum)
% Replay movie stored in movie_config in current figure using parameters
% stored in waveanim_config to set the number of cycles and 
% frames per second.
%
% Usage : replay(M,fignum)
% 
%      M.....Movie data
% fignum.....Window to play movie in
%
% M is created by calling plot_wave_anim
 

global waveanim_config

figure(fignum);
Xdim=600;
Ydim=500;
Xorig=200;
Yorig=100;
set(gcf,'Position',[Xorig Yorig (Xorig+Xdim) (Yorig+Ydim)]);

cycles=waveanim_config(1,4);    % Number of cycles for the movie
fps=waveanim_config(1,5);       % Number of frames per second

movie(gcf,M,cycles,fps,[10,10,0,0]); % Play movie in current figure at 10,10 pix from lower left
