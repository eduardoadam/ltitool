

%
% Archivo auxiliar para simular ejemplos con ventana Gla
%
%

	% Cargo Paquetes
	pkg load control
	pkg load signal
	
	% Limpio la memoria y la ventana de comandos
	clear all, clc
	
	% ------------------------------------------------------------------------
	% Defino valores por defecto para las variables
	% ------------------------------------------------------------------------
	% Defino variable "s"
	s = tf("s");
	% planta
	GLA=(s+1)/(s^2+0.5*s+1);
	% parametros de simulacion
	k=1;        % amplitud del escalon
	tFinal=15;  % tiempo de simulacion
	
	
	% ------------------------------------------------------------------------
	% Mapa de polos y ceros
	% ------------------------------------------------------------------------
	title_string='Mapa de Polos y Ceros G(s) de Lazo Abierto';
	legend_ceros_string='Ceros de Lazo Abierto';
	legend_polos_string='Polos de Lazo Abierto';
	
	figure(1), 
	xpzmap(title_string,legend_ceros_string,legend_polos_string, ... 
	       GLA.num{1,1},GLA.den{1,1});
	
	% ------------------------------------------------------------------------
	% Simulacion
	% ------------------------------------------------------------------------
	% Respuesta al escalon
	figure(2), step_resp_Gol(k*GLA.num{1,1},GLA.den{1,1},0.0,tFinal,1000);
	
	% Respuesta al impulso
	figure(3), impulse_resp_Gol(GLA.num{1,1},GLA.den{1,1},0.0,tFinal,1000);
	
	% ------------------------------------------------------------------------
	% Informacion Adicional
	% ------------------------------------------------------------------------
	[estabilidad,yinf,Test]=info_adicional(GLA.num{1,1},GLA.den{1,1}, ...
	                                       tFinal,1000)

