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
## Calculate the step response of closed loop transfer function
## with a feedforward control system
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [resp_escalon,resp_escalon_sinFF,t]=FFstepresponse(Gp,Gl,Gv,C,Gm,Gt,Gtl,Cff,delay,AmplitudR,AmplitudL,TiniR,TiniL,Tstop,haChCons,haChCarga,nptos);

    % FF-FB Response Simulation
    [t,resp_escalon,resp_escalon_sinFF,AmplitudR,Tstop,yinf, ...
          gamma_tol,delay,sigma_domin,Test,cont_Test]=simulstepFFFB(Gp,Gl,Gv,C,Gm,Gt,Gtl,Cff,delay, ...
                                                                   AmplitudR,AmplitudL,TiniR,TiniL,Tstop,haChCons,haChCarga,nptos);

    % Grafico las respuestas
    xstepresponsesimultaneoFF(t,resp_escalon,resp_escalon_sinFF,AmplitudR,Tstop,yinf,gamma_tol,delay,sigma_domin,Test,cont_Test);
endfunction
