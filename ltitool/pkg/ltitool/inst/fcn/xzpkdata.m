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
## Compute zeros, poles and gain from transfer function.
##    nGH: transfer function numerator
##    dGH: transfer function denominator
##     Z: zeros, P: poles and K: gain     
##
## Created:  2008
## updated for new system data structure format:  febrary 2012

## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [Z,P,K] = xzpkdata(nGH,dGH)


% GH transfer function
GH = tf(nGH,dGH);
[cZeros, cPoles, k_la]=zpkdata(GH);
Z = cell2mat(cZeros); P = cell2mat(cPoles);
  
% Computes gain of G(s)H(s)  
 % analizo el numerador de GH
 length_num=length(GH.num{1,1});
 flag_num=0;
for ncont=length_num:-1:1
  %nnonulo=nGH(ncont)
  nnonulo=GH.num{1,1}(ncont);
  if (nnonulo~=0) & (flag_num==0),
    num_element=nnonulo;
    flag_num=1;
  endif
endfor

 % analizo el denominador de GH
 length_den=length(GH.den{1,1});
 flag_den=0;
for dcont=length_den:-1:1
  %dnonulo=dGH(dcont);
  dnonulo=GH.den{1,1}(dcont);
  if (dnonulo~=0) & (flag_den==0),
    den_element=dnonulo;
    flag_den=1;
  endif
endfor

 % Ganancia
 K=num_element/abs(den_element);

endfunction
