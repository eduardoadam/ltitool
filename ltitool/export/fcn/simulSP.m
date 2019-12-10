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
% Programa para simular un sistema realimentado que incluye un
% Predictor de Smith.
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [tusp,usp,tysp,ysp]=simulSP(Gpud,plantdelay,Cz,Ts,Tstop);

%s=tf('s');

%Calculo Gpud(z) y Gp(z)
Gpudz=c2d(Gpud,Ts);         %Planta sin delay en el dominio Z

delayaux=tf(1,[1 0],Ts);
n=round(plantdelay/Ts); %retorna el valor entero mas grande no mayor a plantdelay/Ts
if (n==0)
      %-------------OJO----------------
      plantdelayz=Ts; %Si el delay es menor al tiempo de muestreo lo asumo igual a Ts
      else
      plantdelayz=(delayaux)^n;  % tiempo muerto discreto
endif
Gpzdelayed=Gpudz*plantdelayz;         % planta con delay en el dominio Z

%Compensador de Smith
%--------------------
Csp=Cz/(1+Cz*(Gpudz-Gpzdelayed));
Csp=minreal(Csp);  %cancelo "z" de numerador y denominador


%Funciones de Transferencia de lazo cerrado (Y/R y U/R) en el dominio Z
Gclz=Gpzdelayed*Csp/(1+Gpzdelayed*Csp); %Y/R: variable controlada y referencia
Gclz=minreal(Gclz);  %cancelo "z" de numerador y denominador
Gurz=Csp/(1+Gpzdelayed*Csp);            %U/R: variable manipulada y referencia
Gurz=minreal(Gurz);  %cancelo "z" de numerador y denominador

% respuesta al escalon
[ysp,tysp]=step(Gclz,Tstop,Ts);
[usp,tusp]=step(Gurz,Tstop,Ts);

%Alternativa para y(t)
%[ysp,tysp]=lsim(Gpzdelayed,usp);


endfunction
