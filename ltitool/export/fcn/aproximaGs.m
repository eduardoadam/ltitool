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
## based on 
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function [numGs,denGs,delay]=aproximaGs(Gp,delayGp,opt);
 
 plantdelay=delayGp.num{1,1}(1);
 [ysal,tsal] = step(Gp);
 Tstop = tsal(length(tsal)); Ts=Tstop/100;

 %Paso datos para preparar la estimación de parámetros
 [parametros]=identifica(tsal,ysal,Tstop,Ts,opt);
 s=tf('s');
 if (opt==1), %FOPTD
	Kp=parametros(1);
	Tp=parametros(2);
	theta=parametros(3);
	numGs=Kp; denGs=[Tp 1]; delay=theta;
   else       %SOPTD
	Kp=parametros(1);
	T1=parametros(2);
	T2=parametros(3);
	theta=parametros(4);
	numGs=Kp; denGs=conv([T1 1],[T2 1]); delay=theta;
 endif


endfunction




