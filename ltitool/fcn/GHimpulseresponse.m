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
## Calculate the impulse response of closed loop transfer function
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [resp_impulse,t]=GHimpulseresponse(nGH,dGH,Tstop,nptos); % Impulse Response to closed loop system
	delay=0;
	%dcl=complete_vec(nGH,dGH);
	GH=tf(nGH,dGH); gcl=minreal(feedback(GH));
	
	% Impulse Response
	DT=Tstop/nptos;
	[resp_impulse,t]=impulse(gcl, Tstop,DT); 
  	string_title='Impulse Response of the Feedback System';
	ximpulseresponse(t,resp_impulse,Tstop,string_title)
endfunction
