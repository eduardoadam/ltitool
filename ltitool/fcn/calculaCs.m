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
% Programa para ajustar controladores PID basada en la respuesta al lazo abierto
% sistema en base a la señal muestreada.
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##

function [Cs]=calculaCs(Kr,TI,TD);

s=tf('s');

Kr_NaN=isnan(Kr);
TI_NaN=isnan(TI);
TD_NaN=isnan(TD);
if (Kr_NaN==1)
      Cs=1;             %Asumo un valor de Cz para no tener error de calculo
      disp('Error debe especificar un valor de Kr')
      elseif (TI_NaN==1 && TD_NaN==1) %Identifico controlador P
      Cs=Kr;
      elseif (TI_NaN==1 && TD_NaN==0) %Identifico controlador PD
      Cs=Kr*(1+TD*s);
      elseif (Kr_NaN==0 && TI_NaN==0 && TD_NaN==1) %Identifico PI
      Cs=Kr*(1+1/(s*TI));
      else %Identifico PID
      Cs=Kr*(1+1/(s*TI)+TD*s);
endif

endfunction

