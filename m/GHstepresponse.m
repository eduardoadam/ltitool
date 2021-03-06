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
## Calculate the step response based closed loop transfer function
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [estabilidad,yinf,Test,t,resp_escalon]=GHstepresponse(nGH,dGH,AmplitudSP,Tstop,nptos); %Step Response of the Feedback System

	% Determinate additional information
	[estabilidad,yinf,Test,t,resp_escalon,gamma_tol,delay,sigma_domin,cont_Test] = additionalinfoFB(nGH,dGH,AmplitudSP,Tstop,nptos);
	
	% Step Response of the Feedback System
	string_title='Step Response of the Feedback System';
	xstepresponse(t,resp_escalon,AmplitudSP,Tstop,yinf,gamma_tol,delay,sigma_domin,Test,cont_Test,string_title);
  %hold off
endfunction

