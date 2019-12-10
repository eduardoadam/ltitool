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


function [Kr_CI,TI_CI,TD_CI]=cituning(parametros)
 

if (length(parametros)==3)
  %Identifico primer orden con delay 
  K=parametros(1); T=parametros(2); theta=parametros(3);
  %---------------------------------------------------
  %disp('Formulas de Rovira')
  % --------------------------------------------------
  % Tabla de Rovira
  % Para PI-IAE:
  a_modoP_iae_PI=0.758; b_modoP_iae_PI=-0.861;
  a_modoI_iae_PI=1.02;  b_modoI_iae_PI=-0.323;
  % Para PI-ITAE:
  a_modoP_itae_PI=0.586; b_modoP_itae_PI=-0.916;
  a_modoI_itae_PI=1.03;  b_modoI_itae_PI=-0.165;
  % Para PID-IAE:
  a_modoP_iae_PID=1.086; b_modoP_iae_PID=-0.869;
  a_modoI_iae_PID=0.740; b_modoI_iae_PID=-0.130;
  a_modoD_iae_PID=0.348; b_modoD_iae_PID=0.914;
  % Para PID-ITAE:
  a_modoP_itae_PID=0.965; b_modoP_itae_PID=-0.855;
  a_modoI_itae_PID=0.796; b_modoI_itae_PID=-0.147;
  a_modoD_itae_PID=0.308; b_modoD_itae_PID=0.9292;
  % --------------------------------------------------
  % Formulas de ajuste de PI formulas de Rovira
  % --------------------------------------------------
  % Controlador PI-IAE:
  Kr_rovPI_iae=(a_modoP_iae_PI*(theta/T)^b_modoP_iae_PI)/K;
  TI_rovPI_iae=T/(a_modoI_iae_PI+b_modoI_iae_PI*(theta/T));
  TD_rovPI_iae=0;
  % Controlador PI-ITAE:
  Kr_rovPI_itae=(a_modoP_itae_PI*(theta/T)^b_modoP_itae_PI)/K;
  TI_rovPI_itae=T/(a_modoI_itae_PI+b_modoI_itae_PI*(theta/T));
  TD_rovPI_itae=0;
  % --------------------------------------------------
  % Formulas de ajuste de PID formulas de Rovira
  % --------------------------------------------------
  % Controlador PID-IAE:
  Kr_rovPID_iae=(a_modoP_iae_PID*(theta/T)^b_modoP_iae_PID)/K;
  TI_rovPID_iae=T/(a_modoI_iae_PID+b_modoI_iae_PID*(theta/T));
  TD_rovPID_iae=T*(a_modoD_iae_PID*(theta/T)^b_modoD_iae_PID);
  % Controlador PID-ITAE:
  Kr_rovPID_itae=(a_modoP_itae_PID*(theta/T)^b_modoP_itae_PID)/K;
  TI_rovPID_itae=T/(a_modoI_itae_PID+b_modoI_itae_PID*(theta/T));
  TD_rovPID_itae=T*(a_modoD_itae_PID*(theta/T)^b_modoD_itae_PID);
 else
  %Identifico segundo orden con delay
  K=parametros(1), T1=parametros(2), T2=parametros(3), theta=parametros(4),
endif


Kr_CI=[Kr_rovPI_iae Kr_rovPI_itae Kr_rovPID_iae Kr_rovPID_itae];
TI_CI=[TI_rovPI_iae TI_rovPI_itae TI_rovPID_iae TI_rovPID_itae];
TD_CI=[TD_rovPI_iae TD_rovPI_itae TD_rovPID_iae TD_rovPID_itae];


endfunction
