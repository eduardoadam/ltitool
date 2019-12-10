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


function [tu,u,ty,y]=simula_con_delay(Gp,plantdelay,Cs,Cz,Ts,Tstop)
 

if (plantdelay==0)
    %Funciones de Transferencia de lazo cerrado (Y/R y U/R)
    Gcl=Gp*Cs/(1+Gp*Cs); %Y/R: variable controlada y referencia
    Gur=Cs/(1+Gp*Cs);    %U/R: variable manipulada y referencia
    % Obtengo respuesta al escalon y escribo en variables de desviacion la salida
    [ysal2,ty]=step(Gcl,Tstop,Ts);
    y = ysal2-ysal2(1);
    [usal2,tu]=step(Gur,Tstop,Ts);
    u = usal2-usal2(1);
    
    % respuesta al escalon
    %figure(1), plot(ty,y), title('Respuesta al seguimiento de referencia')
    %figure(2), plot(tu,u), title('Respuesta de la variable manipulada')
    else
    %CASO: Delay distinto de cero
    %----------------------------
    Gpz=c2d(Gp,Ts);         %Planta sin delay en el dominio Z
    %[nc,dc]=tfdata(C,'v');
    %if (length(nc)==1 && length(dc)==1)
    %  Cz=1;%tf(1,Ts)
    %else
    %  Cz=c2d(C,Ts);         %Controlador en el dominio Z
    %endif
    %Cz=c2d(C,Ts);           %Controlador en el dominio Z
    delayaux=tf(1,[1 0],Ts);
    n=round(plantdelay/Ts); %retorna el valor entero mas grande no mayor a plantdelay/Ts
    if (n==0)
                      %-------------OJO----------------
      plantdelayz=Ts; %Si el delay es menor al tiempo de muestreo lo asumo igual a Ts
      else
      plantdelayz=(delayaux)^n;  % tiempo muerto discreto
    endif
    Gpzdelayed=Gpz*plantdelayz;         % planta con delay en el dominio Z
    
    %Funciones de Transferencia de lazo cerrado (Y/R y U/R) en el dominio Z
    Gclz=Gpzdelayed*Cz/(1+Gpzdelayed*Cz); %Y/R: variable controlada y referencia
    Gurz=Cz/(1+Gpzdelayed*Cz);            %U/R: variable manipulada y referencia
    
    % respuesta al escalon
    [yz,ty]=step(Gclz,Tstop); y=yz;
    [uz,tu]=step(Gurz,Tstop); u=uz;
    %figure(1), plot(ty,yz), title('Respuesta al seguimiento de referencia')
    %figure(2), plot(tu,uz), title('Respuesta de la variable manipulada')
endif

endfunction
