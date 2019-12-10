

%
% Archivo auxiliar para simular ejemplos con ventana Gla
%
%

	% package ltitool is loaded.
  pkg load control
  pkg load signal
	pkg load ltitool
	
	% Clean memory and command window.
	clear all, clc
	
	% ------------------------------------------------------------------------
	% Define default values for the variables
	% ------------------------------------------------------------------------
	% Defino variable "s"
	s = tf("s");
	% plant
	Gol=(s+1)/(s^2+0.5*s+1);
	%simulation parameters
	k=1;        % step amplitude
	tFinal=20;  % simulation time
	
	
	% ------------------------------------------------------------------------
	% Mapa de polos y ceros
	% ------------------------------------------------------------------------
	title_string='Poles and Zeros Map of G(s)';
	legend_ceros_string='Zeros of G(s)';
	legend_polos_string='Poles of G(s)';
	
	figure(1), 
	xpzmap(title_string,legend_ceros_string,legend_polos_string, ... 
	       Gol.num{1,1},Gol.den{1,1});
	
	% ------------------------------------------------------------------------
	% Simulation
	% ------------------------------------------------------------------------
	% Step response
	figure(2), OLstepresponse(Gol.num{1,1},Gol.den{1,1},k,0.0,tFinal,1000);
	
	% Impulse response 
	figure(3), OLimpulseresponse(Gol.num{1,1},Gol.den{1,1},0.0,tFinal,1000);
	
	% ------------------------------------------------------------------------
	% Additional information 
	% ------------------------------------------------------------------------
	[stability,yinf,Test]=additionalinfo(Gol.num{1,1},Gol.den{1,1}, ...
	                                       tFinal,1000)

