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
## Calculate the step response of open loop transfer function
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012

## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function [resp_escalon,t]=OLstepresponse(nGol,dGol,step_amplitud,Tini,Tstop,Nptos) % Step response to open loop system
	delay=0;
        nGol=step_amplitud*nGol;
	Gol=tf(nGol,dGol);
	if (Tini==0) 
	  Tini=1; 
	endif

	% Step response
	DT=Tstop/1000;				%Time interval
	[resp_escalon,t]=step(Gol,Tstop,DT);	%Step response

	[ceros_la,polos_la,kz] = tf2zp(Gol);	%kz is the gain asociated to zeros. It is not open loop gain.
	
	% Verify the dominant sigma
	sigma_domin=max(real(polos_la));
	if abs(sigma_domin)<10^(-8), sigma_domin=0;endif
	if (sigma_domin < 0)
		estabilidad="Asimpt. Stable";
		nGol0=nGol(length(nGol)); dGol0=dGol(length(dGol));
		yinf=nGol0/dGol0;
		gamma_tol=0.02;	% settling time tolerance
		[Test,cont_Test]=settlingtime(t,resp_escalon,sigma_domin,yinf,gamma_tol);
		elseif (sigma_domin == 0)
			estabilidad="Crit. Stable";
			yinf=NaN;
			gamma_tol=NaN;
			Test=NaN;
			cont_Test=NaN;
		else
			estabilidad="Unstable";
			yinf=Inf;
			gamma_tol=NaN;
			Test=NaN;
			cont_Test=NaN;
	endif
	string_title='Open Loop System Step Response';
	xstepGOL(t,resp_escalon,step_amplitud,Tstop,yinf,gamma_tol,delay,sigma_domin,Test,cont_Test,string_title);
	hold off
endfunction

