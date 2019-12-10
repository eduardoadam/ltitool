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
% Programa para ajustar controladores PID basado en la curva de reaccion de procesos,
% en oscilaciones sostenidas, en criterios de conducta integral y en la parametrizacion IMC.
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##

function [Kr_OS,TI_OS,TD_OS]=ostuning(GH,delay);

% Calculo un w que necesito,
[mag, pha, w]= bode(GH);
% Llamo a xmargin para calcular Kru y w180
[GM,PM,w180,wg,ix,ipmx]=xmargin(GH,delay,w)
Pu=2*pi/w180;
if (GM~=Inf),
  %Kru=GM*Kr
  Kru=GM;
endif



%Controladores de Ziegler y Nichols
Pu=2*pi/w180
%P:
Kr_znP_OS=Kru/2;
TI_znP_OS=NaN;
TD_znP_OS=0;
%PI:
Kr_znPI_OS=0.45*Kru;
TI_znPI_OS=Pu/1.2;
TD_znPI_OS=0;
%PID
Kr_znPID_OS=0.6*Kru;
TI_znPID_OS=Pu/2;
TD_znPID_OS=Pu/8;

%Controlador PI de Tyreus y Luyben
Kr_tlPI_OS=Kru/3.2;
TI_tlPI_OS=2.2*Pu;
TD_tlPI_OS=0;

%Controlador PID de Luyben
Kr_lPID_OS=Kru/2.2;
TI_lPID_OS=2.2*Pu;
TD_lPID_OS=Pu/6.28;

%Controlador PID de Adam et. al. (AVG)
Kr_avgPID_OS=Kru/2.8;
TI_avgPID_OS=2.5*Pu;
TD_avgPID_OS=Pu/3.8;


Kr_OS=[Kr_znP_OS Kr_znPI_OS Kr_znPID_OS Kr_tlPI_OS Kr_lPID_OS Kr_avgPID_OS];
TI_OS=[TI_znP_OS TI_znPI_OS TI_znPID_OS TI_tlPI_OS TI_lPID_OS TI_avgPID_OS];
TD_OS=[TD_znP_OS TD_znPI_OS TD_znPID_OS TD_tlPI_OS TD_lPID_OS TD_avgPID_OS];

endfunction
