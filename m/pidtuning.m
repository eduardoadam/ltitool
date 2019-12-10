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


function [Kr,TI,TD]=pidtuning(Gs,plantdelay,t,y,Tstop,Ts,option)

 %Gs=tf(numGs,denGs);
 %[ysal,tsal] = step(Gs);
 %if Tstop ==0
 %   Tstop = tsal(length(tsal)); Ts=Tstop/100;
 %   else
 %   Ts=Tstop/100;
 %endif
 
if (size(t)==[0 0])
  if (plantdelay==0)
    % Obtengo respuesta al escalon y escribo en variables de desviacion la salida
    [ysal2,t]=step(Gs,Tstop,Ts);
    y = ysal2-ysal2(1);
    plot(t,y)
   else
    Gz=c2d(Gs,Ts);
    delayaux=tf(1,[1 0],Ts);
    n=round(plantdelay/Ts);
    if (n==0)
                      %-------------OJO----------------
      plantdelayz=Ts; %Si el delay es menor al tiempo de muestreo lo asumo igual a Ts
      else
      plantdelayz=(delayaux)^n;  % tiempo muerto
    endif
    Gzdelayed=Gz*plantdelayz;              % planta con delay
    % respuesta al escalon
    [y,t]=step(Gzdelayed,Tstop);
    %figure(1), plot(t,y), title('Respuesta a Lazo Abierto')
  endif
 endif

 %Identifico los parametros de una funcion de trensferencia reducida
[parametros]=identifica(t,y,Tstop,Ts,option);
%if (parametros(length(parametros)) <= 0), parametros(length(parametros)) = 0.01; endif


% Controladores basados en el método CRP
[Kr_CRP,TI_CRP,TD_CRP]=crptuning(parametros);
%-------------------------------------

%  Controladores basados en métodos Oscilaciones Sostenidas
[Kr_OS,TI_OS,TD_OS]=ostuning(Gs,plantdelay)
%-------------------------------------

% Controladores basados en el método CI
[Kr_CI,TI_CI,TD_CI]=cituning(parametros);
%-------------------------------------

% Controladores basados en el método CBM
[Kr_CBM,TI_CBM,TD_CBM]=cbmtuning(parametros);
%-------------------------------------

Kr=[Kr_CRP Kr_OS Kr_CI Kr_CBM];
TI=[TI_CRP TI_OS TI_CI TI_CBM];
TD=[TD_CRP TD_OS TD_CI TD_CBM];



endfunction
