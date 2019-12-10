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


%function  [estabilidad,yinf,Test,t,resp_escalon,gamma_tol,delay,sigma_domin,cont_Test]=additionalinfoFB(nGol,dGol,Tini,Tstop,Nptos);
%
% Calculate aditional information related to:
%      estability condition
%      fyinf: inal value from step response
%      Test:  settling time
%      yinf: final value of step response
%       

## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [estabilidad,yinf,Test,t,resp_escalon,gamma_tol,delay,sigma_domin,cont_Test]=additionalinfoFB(nGH,dGH,AmplitudSP,Tstop,nptos);

	delay=0;
	GH=tf(nGH,dGH);
	Gcl = feedback(GH);		%función de transferencia de lazo cerrado
	dcl=complete_vec(nGH,dGH);  	%denominador de lazo cerrado
	
	%Respuesta al escal´on
	DT=Tstop/nptos;			%Intervalo de tiempo
	[resp_escalon,t]=step(AmplitudSP*Gcl,Tstop,DT);	%Respuesta al escalon

	[ceros_lc,polos_lc,kz] = tf2zp(Gcl);	%kz es la ganancia asociada a los ceros. No es la ganancia de lazo abierto.
	
	sigma_domin=max(real(polos_lc));
	if abs(sigma_domin)<10^(-8), sigma_domin=0;endif
	if (sigma_domin < 0)
		estabilidad="Asympt. Stable";
		nGH0=nGH(length(nGH)); dcl0=dcl(length(dcl));
		yinf=AmplitudSP*nGH0/dcl0;
		
		gamma_tol=0.02;	%settling time tolerance
		[Test,cont_Test]=settlingtime(t,resp_escalon,sigma_domin,yinf,gamma_tol);
		
		elseif (sigma_domin == 0)
			estabilidad="Crit. Stable";
			yinf=NaN;
			gamma_tol=NaN;
			Test=NaN;
			cont_Test=NaN;
		else
			estabilidad="Unestable";
			yinf=Inf;
			gamma_tol=NaN;
			Test=NaN;
			cont_Test=NaN;
	endif

endfunction
