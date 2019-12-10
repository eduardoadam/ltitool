## Copyright (C) 2012
##
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## 
## This function is used for identified parameters of a transfer function
## based on time response.
## 
%
% Permite calcular los parametros de una funcion de transferencia de un sistema en base a la sen~al muestreada.
% Datos necesarios,
%       t = vector de tiempo
%       y = vector de variables muestreadas
%       condiciones iniciales para el tanteo:
%           kK : ganancia
%            T : constante de tiempo
%          teta: delay
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [x]=identificaGs(t,y,kK,T,T1,T2,theta,Ts,opt);

% Opcion,
%opt=menu('Escoja el Tipo de Aproximacion', ...
%         'Primer Orden con Retardo', ...
%         'Segundo Orden con Retardo (sobreamortiguado)');


if (opt==1),
	% calculo los parametros de la func. de transf.
	% asumiendo primer orden con retardo.
	x0=[kK,T,theta];
	x=fmins('fident11',x0,[],[],t,y);
	kK=x(1); T=x(2); theta=x(3);
  	% si el tiempo muerto es negativo, corrijo tomando uno positivo cercano a cero.
  	if (theta <= 0),theta = Ts/100; x(3)=theta; endif


	% Graficos,
	% ---------
	for k=2:length(t),
		if t(k)<theta,
			y1(k)=0;
		else
			y1(k)=kK*(1-exp(-(t(k)-theta)/T));
		end
	end
	plot(t,y,'k',t,y1,'r')
	xlabel('tiempo'), ylabel('salida')
  	grid
 else
	% calculo los parametros de la func. de transf.
	% asumiendo segundo orden con retardo.
	x0=[kK,T1,T2,theta];
	x=fmins('fident12',x0,[],[],t,y);
	kK=x(1); T1=x(2); T2=x(3); theta=x(4); if (theta<0), x(4)=0; theta=x(4); endif
  	% si el tiempo muerto es negativo, corrijo tomando uno positivo cercano a cero.
  	if (theta <= 0),theta = Ts/100; x(4)=theta; endif

	for k=1:length(t),
		if t(k)<theta,
			y1(k)=0;
		else
			y1(k)=kK*(1 + (T1/(T2-T1))*exp(-(t(k)-theta)/T1) ...
	                            - (T2/(T2-T1))*exp(-(t(k)-theta)/T2));
		endif
	endfor
endif

% si el tiempo muerto es negativo, corrijo tomando uno positivo cercano a cero.
%if (x(length(x)) <= 0), x(length(x)) = 0.01; endif

% Graficos,
% ---------
figure(1), graf=plot(t,y,'b',t,y1,'r');
set(graf,'linewidth',1.8);
legend(graf,'Resp. de G(s)','Resp. de G_{aprox}(s)');
xlabel('tiempo'), ylabel('Salidas'),
tit=title('Respuestas a Lazo Abierto');
set(tit,'fontsize',14);
grid

endfunction
