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
## This function estimates the settlingtime of system based on
## its step response.
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function [Test, posicion]=settlingtime(t,resp_escalon,sigma_domin,yinf,gamma_tol);

% Determino la banda de tolerancia de tiempo de establecimiento
ymax_tol=(1+gamma_tol)*yinf;
ymin_tol=(1-gamma_tol)*yinf;


vector1=NaN;
vector2=NaN;
for cont=1:length(t)
	if (resp_escalon(cont)>=ymax_tol)
		vector1=[vector1 cont];		%Va por arriba de la banda de tolerancia
	endif
	if (resp_escalon(cont)<=ymin_tol)
		vector2=[vector2 cont];		%Va por abajo de la banda de tolerancia
	endif
endfor


cont1_max=max(vector1);
cont2_max=max(vector2);
%y1=resp_escalon(cont1_max);
y2=resp_escalon(cont2_max);

if (cont1_max>cont2_max)
	posicion=cont1_max;
else
	posicion=cont2_max;
end

longitud_vector=length(t);
if (posicion<longitud_vector)
	Test=t(posicion);		%Encontro el tiempo de establecimiento
else
	Test_aprox=4/abs(sigma_domin);
	Test=Test_aprox;		%No encontro el tiempo de establecimiento
end

endfunction
