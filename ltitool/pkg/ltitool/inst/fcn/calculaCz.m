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


function [Cz]=calculaCz(Cs,Kr,TI,TD,Ts);

s=tf('s');

%Paràmetro del modo derivativo
N=10; %Parametro para realizabilidad del modo derivativo

Kr_NaN=isnan(Kr);
TI_NaN=isnan(TI);
TD_NaN=isnan(TD);
if (Kr_NaN==1), %Busco el controlador que no fue calculado
      Cs=1;             %Asumo un valor de Cz para no tener error de calculo
      Cz=1;             %Asumo un valor de Cz para no tener error de calculo
      disp('Error debe especificar un valor de Kr')
      elseif (TI_NaN==1 && TD_NaN==1) %Identifico controlador P
      Cz=Kr;
      elseif (TI_NaN==1 && TD_NaN==0) %Identifico controlador PD
      Cs=Kr*(1+TD*s)*(1/(1+TD*s/N)^2); %Doy realizabilidad al controlador PD
      Cz=c2d(Cs,Ts);
      elseif (Kr_NaN==0 && TI_NaN==0 && TD_NaN==1) %Identifico PI
      Cz=c2d(Cs,Ts);
      else %Identifico PID
      %Armo un PID realizable para obtener su version disctreta
      %N=10;
      %Cs=Kr(cont)*(1+1/(TI(cont)*s)+TD(cont)*s/(s*TD(cont)/10^10+1)^2); %Doy realizabilidad al controlador
      %Cs=Kr(cont)*(1+1/(TI(cont)*s)+TD(cont)*N*s/(s+N)); %Doy realizabilidad al controlador
      Cs=Kr*(1+1/(TI*s)+TD*s)*(1/(1+s*TD/N)^2); %Doy realizabilidad al controlador
      Cz=c2d(Cs,Ts);
  endif

endfunction
