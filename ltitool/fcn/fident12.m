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

%
% funcion para identificar parametros asumiendo de funciones de 
% transferencia de segundo orden con tiempo muerto.
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function fo=fident12(x0,t,y)

%
%




kK=x0(1); T1=x0(2); T2=x0(3); teta=x0(4);


for k=1:length(t),
	if t(k)<teta,
		y1(k)=0;
	else

		y1(k)=kK*(1 + (T1/(T2-T1))*exp(-(t(k)-teta)/T1) ...
                            - (T2/(T2-T1))*exp(-(t(k)-teta)/T2));
	end
end

y=y';

% funcion objetivo a minimizar,
fo=sum((y-y1).^2);

