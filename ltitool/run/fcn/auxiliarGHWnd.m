
%
% Archivo auxiliar para simular ejemplos
%
%

	% package ltitool is loaded.
  	pkg load control
  	pkg load signal  
	pkg load ltitool

	% Clean memory and command window.
  	clear all, clc

	% ------------------------------------------------------------------------
	% Default values for the variables are defined
	% ------------------------------------------------------------------------
  % G(s)H(s):
  s=tf('s');
  Gs=2.0/((5*s+1)*(1*s^2+1*s+1)); delay=0;
  Hs=(5*s+1)/(5*s);
  Kr=1.25;
  GH=minreal(Kr*Gs*Hs);

	%simulation parameters
  AmplitudSP=1; % step amplitude
  tFinal=30;    % simulation time

  % -----------------------------------------
  % Analisys Tools
  % -----------------------------------------
  % Roots locus
  figure(1), clf(figure(1),"reset");
  [Kast,Kast_ult,wultimo,GM,wcg,PM]=GHrlocusplot(GH.num{1,1},GH.den{1,1},Kr,1000);

% Bode diagrams
figure(2), clf(figure(2),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=GHbodeplot(GH.num{1,1},GH.den{1,1},delay,Kr);

% Nyquist diagram
figure(3),  clf(figure(3),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=GHnyquistplot(GH.num{1,1},GH.den{1,1},delay,Kr);

% -----------------------------------------
% Simulation Tools
% -----------------------------------------
% Step response
figure(4),  clf(figure(4),"reset");
GHstepresponse(GH.num{1,1},GH.den{1,1},AmplitudSP,tFinal,1000);

% Impulse response
figure(5), clf(figure(5),"reset");
GHimpulseresponse(GH.num{1,1},GH.den{1,1},tFinal,1000);

% Additional information
[estabilidad,yinf,Test]=info_adicional(GH.num{1,1},GH.den{1,1},AmplitudSP,tFinal,1000);
