function [EleAmp,CPflag]=sumcode(Elt,thloc,philoc)
% Returns element pattern data and circ-pol flag showing whether or not 
% it is inherently circularly polarised e.g. Helix.
%
% Usage: [EleAmp,CPflag]=sumcode(Elt,thloc,philoc)
%
% Elt.....Element type (numeric code)
% thloc...Local theta coords (radians)
% philoc..Local phi coords (radians)
%
%
% Returned value:
%
% EleAmp........Element pattern value in direction of 
%               local (theta,phi) coords
%
% CPflag........Circular polarisation flag.


  CPflag=0;
  switch Elt
   case 0,[EleAmp,CPflag]=iso(thloc,philoc);      % Use CP for iso so that VP=HP=-3dBi
   case 1,[EleAmp,CPflag]=patchr(thloc,philoc);
   case 2,[EleAmp,CPflag]=patchc(thloc,philoc);
   case 3,[EleAmp,CPflag]=dipole(thloc,philoc);
   case 4,[EleAmp,CPflag]=dipoleg(thloc,philoc);
   case 5,[EleAmp,CPflag]=helix(thloc,philoc);    % Circular pol for helix (VP=HP=-3dB down on Total)
   case 6,[EleAmp,CPflag]=aprect(thloc,philoc);
   case 7,[EleAmp,CPflag]=apcirc(thloc,philoc);
   case 8,[EleAmp,CPflag]=wgr(thloc,philoc);
   case 9,[EleAmp,CPflag]=wgc(thloc,philoc);
   case 10,[EleAmp,CPflag]=dish(thloc,philoc);
   case 11,[EleAmp,CPflag]=interpl(thloc,philoc);
   case 12,[EleAmp,CPflag]=user1(thloc,philoc);
   otherwise,disp('Invalid element type, isotropic used');EleAmp=1;
  end;
