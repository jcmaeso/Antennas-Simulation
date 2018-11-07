<Qucs Schematic 0.0.14>
<Properties>
  <View=-70,-50,1539,936,0.675886,0,0>
  <Grid=10,10,0>
  <DataSet=PhaseShifter2a.dat>
  <DataDisplay=PhaseShifter2a.dpl>
  <OpenDisplay=1>
  <showFrame=0>
  <FrameText0=Title>
  <FrameText1=Drawn By:>
  <FrameText2=Date:>
  <FrameText3=Revision:>
</Properties>
<Symbol>
</Symbol>
<Components>
  <Pac P1 1 50 310 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 1 50 340 0 0 0 0>
  <Pac P2 1 50 660 18 -26 0 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 GHz" 0 "26.85" 0>
  <GND * 1 50 690 0 0 0 0>
  <SUBST Subst1 1 650 60 -30 24 0 0 "3.48" 1 "0.76 mm" 1 "35 um" 1 "0.004" 1 "0.022e-6" 1 "0.15e-6" 1>
  <MCOUPLED MS10 1 370 310 -26 37 0 0 "Subst2" 1 "TrkWidthBM" 1 "LenT1T2B" 1 "SepM" 1 "Kirschning" 0 "Kirschning" 0 "26.85" 0>
  <MCOUPLED MS1 1 240 310 -26 37 0 0 "Subst1" 1 "TrkWidthAM" 1 "LenT1T2A" 1 "SepM" 1 "Kirschning" 0 "Kirschning" 0 "26.85" 0>
  <MCOUPLED MS6 1 240 600 -26 37 0 0 "Subst1" 1 "TrkWidthAM" 1 "LenT3T4A" 1 "SepM" 1 "Kirschning" 0 "Kirschning" 0 "26.85" 0>
  <MCOUPLED MS11 1 370 600 -26 37 0 0 "Subst2" 1 "TrkWidthBM" 1 "LenT3T4B" 1 "SepM" 1 "Kirschning" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS4 1 150 340 -26 15 0 0 "Subst1" 1 "TrkWidthAM" 1 "MinRadM" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS9 1 150 570 -26 -95 1 0 "Subst1" 1 "TrkWidthAM" 1 "MinRadM" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS2 1 480 280 -26 -95 1 0 "Subst2" 1 "TrkWidthBM" 1 "CenSepM" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS8 1 490 570 -26 -95 0 2 "Subst2" 1 "TrkWidthBM" 1 "CenSepM" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <.SP SP1 1 800 280 0 64 0 0 "lin" 1 "0.1 GHz" 1 "3 GHz" 1 "201" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <Eqn Eqn3 1 1000 720 -30 16 0 0 "S11dB=dB(S[1,1])" 1 "S21=S[2,1]" 1 "PhaS21=phase(S[2,1])" 1 "S21dB=dB(S[2,1])" 1 "S21rel=S21[:,:]/S21[0,:]" 1 "S21RelPhase=-phase(S21rel)" 1 "yes" 0>
  <.SW SW1 1 800 480 0 64 0 0 "SP1" 1 "lin" 1 "RotAngle" 1 "0" 1 "60" 1 "9" 1>
  <Eqn Eqn1 1 830 30 -30 16 0 0 "MinRadMM=14.0" 1 "TrkWidthAMM=1.7" 1 "TrkWidthBMM=1.7" 1 "CenSepMM=8" 1 "UseTrk1and2=1" 1 "UseTrk3and4=1" 1 "yes" 0>
  <SUBST Subst2 1 650 310 -30 24 0 0 "3.2" 1 "0.76 mm" 1 "35 um" 1 "0.004" 1 "0.022e-6" 1 "0.15e-6" 1>
  <MLIN MS3 1 150 280 -26 -95 1 0 "Subst1" 1 "TrkWidthAM" 1 "13 mm" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <MLIN MS7 1 150 630 -26 15 0 0 "Subst1" 1 "TrkWidthAM" 1 "13 mm" 1 "Hammerstad" 0 "Kirschning" 0 "26.85" 0>
  <Eqn Eqn2 1 1000 30 -30 16 0 0 "AngleDegA=90" 1 "AngleDegB=RotAngle" 1 "SFA=AngleDegA/360" 1 "SFB=AngleDegB/360" 1 "TrkWidthAM=TrkWidthAMM*1e-3" 1 "TrkWidthBM=TrkWidthBMM*1e-3" 1 "CenSepM=CenSepMM*1e-3" 1 "MinRadM=MinRadMM*1e-3" 1 "SepM=(CenSepM-TrkWidthAM)" 1 "RadT1=MinRadM+0*CenSepM" 1 "RadT2=MinRadM+1*CenSepM" 1 "RadT3=MinRadM+0*CenSepM" 1 "RadT4=MinRadM+1*CenSepM" 1 "LenT1A=2*pi*RadT1*SFA*UseTrk1and2" 1 "LenT1B=2*pi*RadT1*SFB*UseTrk1and2" 1 "LenT2A=2*pi*RadT2*SFA*UseTrk1and2" 1 "LenT2B=2*pi*RadT2*SFB*UseTrk1and2" 1 "LenT3A=2*pi*RadT3*SFA*UseTrk3and4" 1 "LenT3B=2*pi*RadT3*SFB*UseTrk3and4" 1 "LenT4A=2*pi*RadT4*SFA*UseTrk3and4" 1 "LenT4B=2*pi*RadT4*SFB*UseTrk3and4" 1 "LenT1T2A=(LenT1A+LenT2A)/2" 1 "LenT1T2B=(LenT1B+LenT2B)/2" 1 "LenT3T4A=(LenT3A+LenT4A)/2" 1 "LenT3T4B=(LenT3B+LenT4B)/2" 1 "Radii=[RadT1*UseTrk1and2,RadT2*UseTrk1and2,RadT3*UseTrk3and4,RadT4*UseTrk3and4]" 1 "MaxDiamMM=max(Radii)*2/1e-3+TrkWidthAMM" 1 "yes" 0>
</Components>
<Wires>
  <50 280 120 280 "" 0 0 0 "">
  <180 340 210 340 "" 0 0 0 "">
  <180 280 210 280 "" 0 0 0 "">
  <50 630 120 630 "" 0 0 0 "">
  <180 630 210 630 "" 0 0 0 "">
  <180 570 210 570 "" 0 0 0 "">
  <270 280 340 280 "" 0 0 0 "">
  <400 280 450 280 "" 0 0 0 "">
  <270 340 340 340 "" 0 0 0 "">
  <270 570 340 570 "" 0 0 0 "">
  <400 570 460 570 "" 0 0 0 "">
  <520 570 530 570 "" 0 0 0 "">
  <530 570 530 630 "" 0 0 0 "">
  <400 630 530 630 "" 0 0 0 "">
  <270 630 340 630 "" 0 0 0 "">
  <510 280 530 280 "" 0 0 0 "">
  <530 280 530 340 "" 0 0 0 "">
  <400 340 530 340 "" 0 0 0 "">
  <90 340 120 340 "" 0 0 0 "">
  <90 570 120 570 "" 0 0 0 "">
  <90 340 90 570 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
  <Text -30 -10 12 #000000 0 "Edit the values in Eq1, S param and Param sweep as required.\n\nPrototype Values : \n(~360 deg @ 2.45GHz)\n\nMinRadMM=14.0\nTrkWidthAMM=1.7\nTrkWidthBMM=1.7\nCenSep=8\nUseTrk1and2=1\nUseTrk3and4=1\n">
</Paintings>
