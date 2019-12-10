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
% Prepara los datos para la simulacion de un sistema realimentadocon delay
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [tiempo_u,manipulada,tiempo_y,salida]=grafico_simula_con_delay(Gp,plantdelay,Kr,TI,TD,Tstop,flag_simula,color_fig,N)

% Definiciones
Ts=Tstop/500;
s=tf('s');  %Defino Variable s
z=tf('z',Ts);
fig_cont=1;

%longitud del vector de controladores
cantidad=length(Kr);
Kr_NaN=isnan(Kr);
TI_NaN=isnan(TI);
for cont=1:cantidad
  %calcula el controlador en s
  %cont, Kr(cont)
  if (Kr_NaN(cont)==1), %Busco el controlador que no fue calculado
      Cs=1;             %Asumo un valor de Cz para no tener error de calculo
      Cz=1;             %Asumo un valor de Cz para no tener error de calculo
      elseif (TI_NaN(cont)==1) %Identifico controlador P
      Cs=Kr(cont);
      Cz=Kr(cont);       
      elseif (Kr_NaN(cont)==0 && TI_NaN(cont)==0 && TD(cont)==0) %Identifico PI
      Cs=Kr(cont)*(1+1/(s*TI(cont)));
      Cz=c2d(Cs,Ts);
      else %Identifico PID
      Cs=Kr(cont)*(1+1/(s*TI(cont))+TD(cont)*s);
      %Armo un PID realizable para obtener su version disctreta
      %N=10;
      %Cs=Kr(cont)*(1+1/(TI(cont)*s)+TD(cont)*s/(s*TD(cont)/10^10+1)^2); %Doy realizabilidad al controlador
      %Cs=Kr(cont)*(1+1/(TI(cont)*s)+TD(cont)*N*s/(s+N)); %Doy realizabilidad al controlador
      Cs=Kr(cont)*(1+1/(TI(cont)*s)+TD(cont)*s/(1+TD(cont)*s/N)^2); %Doy realizabilidad al controlador
      Cz=c2d(Cs,Ts);
  endif
   
  
  %simulaciones
  if (flag_simula(cont)==1)
    %Cs, Cz, disp('simulacion: '), disp(fig_cont)
    [tu,u,ty,y]=simula_con_delay(Gp,plantdelay,Cs,Cz,Ts,Tstop);
    %pause
    if (Kr_NaN(cont)==1)
      y=y*0;
      u=u*0;
    endif
    tiempo_y(:,fig_cont)=ty;
    salida(:,fig_cont)=y;
    tiempo_u(:,fig_cont)=tu;
    manipulada(:,fig_cont)=u;
    fig_cont=fig_cont+1;
    figure(1), plot(ty,y,'color',color_fig(cont,:)), title('Respuesta Dinamica Variable Controlada'), hold on
    figure(2), plot(tu,u,'color',color_fig(cont,:)), title('Respuesta Dinamica Variable Manipulada'), hold on,
  endif
  
endfor
hold off, hold off




endfunction
