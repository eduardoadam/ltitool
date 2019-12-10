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


function [parametros]=identifica(t,y,Tstop,Ts,option);
if (option ==1)
  %para primer orden con delay
  kK=y(length(y)); T=Tstop/8; theta=0.1*T;
  T1=[]; T2=[];
  else
  %para segundo orden con delay
  %T1=0.8*T; T2=0.5*T;
  kK=y(length(y)); T=Tstop/8; theta=0.1*T;
  T1 = 0.9*T; T2 = 1.1*T;  
endif

parametros=identificaGs(t,y,kK,T,T1,T2,theta,Ts,option);

endfunction
