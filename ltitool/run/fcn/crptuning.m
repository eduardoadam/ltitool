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
% Programa para ajustar controladores PID basado en la respuesta al lazo abierto.
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [Kr_CRP,TI_CRP,TD_CRP]=crptuning(parametros)


if (length(parametros)==3)
  %Identifico primer orden con delay 
  K=parametros(1); T=parametros(2); theta=parametros(3);
  %--------------------------------------------
  %disp('Formulas de Ziegler-Nichos')
  S=K/T;  % pendiente normalizada
  % Formulas de ajuste de P Ziegler y Nichols
  Kr_znP=1/(S*theta);
  TI_znP=NaN;
  TD_znP=0;
  % Formulas de ajuste de PI Ziegler y Nichols
  Kr_znPI=0.9/(S*theta);
  TI_znPI=3.3*theta;
  TD_znPI=0;
  % Formulas de ajuste de PID Ziegler y Nichols
  Kr_znPID=1.2/(S*theta);
  TI_znPID=2.0*theta;
  TD_znPID=0.5*theta;
  %--------------------------------------------
  %disp('Formulas de Cohen-Coon')
  % Formulas de ajuste de P Cohen y Coon
  Kr_ccP=(1/K)*(T/theta)*(1+theta/(3*T));
  TI_ccP=NaN;
  TD_ccP=0;
  % Formulas de ajuste de PI Cohen y Coon
  Kr_ccPI=(1/K)*(T/theta)*(0.9+theta/(12*T));
  TI_ccPI=(30+3*theta/T)/(9+20*theta/T)*theta;
  TD_ccPI=0;
  % Formulas de ajuste de PID Cohen y Coon
  Kr_ccPID=(1/K)*(T/theta)*(4/3+theta/(4*T));
  TI_ccPID=(32+6*theta/T)/(13+8*theta/T)*theta;
  TD_ccPID=4*theta/(11+2*theta/T);
 else
  %Identifico segundo orden con delay
  K=parametros(1), T1=parametros(2), T2=parametros(3), theta=parametros(4),
endif

Kr_CRP=[Kr_znP Kr_znPI Kr_znPID Kr_ccP Kr_ccPI Kr_ccPID];
TI_CRP=[TI_znP TI_znPI TI_znPID TI_ccP TI_ccPI TI_ccPID];
TD_CRP=[TD_znP TD_znPI TD_znPID TD_ccP TD_ccPI TD_ccPID];

endfunction