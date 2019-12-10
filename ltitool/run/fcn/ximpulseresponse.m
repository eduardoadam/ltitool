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

%function ximpulseresponce(t,resp_escalon,Tstop,yinf,delay,sigma_domin,Test);
%
% Plot a impulse response diagram from the following data:
%      t: time vector
%      resp_escalon: step response vector
%      Tstop: stop time
%      yinf: final value of step response
%      delay: delay
%      sigma_domin: domain pole
%      Test: settling time
%       
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function ximpulseresponse(t,resp_impulso,Tstop,string_title);

%figure;
graf=plot(t,resp_impulso);
set(graf,'linewidth',1.5);
tit=title(string_title);
set(tit,'fontsize',14);  
h=legend('Salida');
grid;
axis([0 Tstop min(resp_impulso) max(resp_impulso)]);

hold off

endfunction
