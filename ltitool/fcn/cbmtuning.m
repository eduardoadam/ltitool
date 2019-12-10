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
% Programa para ajustar controladores PID basado en la parametrizacion IMC.
% Ref.: Astrom y Hagglund, Control PID Avanzado, Prentice Hall, 2009
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##

function [Kr_CBM,TI_CBM,TD_CBM]=cbmtuning(parametros);



if (length(parametros)==3)
  %Identifico primer orden con delay 
  Kp=parametros(1); T=parametros(2); L=parametros(3);
  %--------------------------------------------
  % Metodo S-IMC (Skogestad 2003):
  % ------------------------------
  %               Asume SOTD, Gp(s) = Kp e^(-L.s)/(T.s+1)
  %
  % Parametros del controlador:
  % Kr = T/Kp.(Tcl+L)
  % TI = min{T1,4.(Tcl+L)}
  %
  % donde Tcl es un parametro de ajuste. Astrom y Hagglum recomiendan Tcl=L
  % con lo que las formulas de Kr y TI resultan
  % Kr = T/(Kp.2.L)
  % TI = min{T,8.L}
  %
  % PI-SIMC
  Kr_PI_SMIC = T/(Kp*2*L);
  TI_PI_SMIC = min([T 8*L]);
  TD_PI_SMIC = 0;
  % PID-SIMC
  Kr_PID_SMIC = NaN;
  TI_PID_SMIC = NaN;
  TD_PID_SMIC = NaN;

  %--------------------------------------------
  % Metodo AMIGO:
  %---------------
  %               Asume FOTD, Gp(s) = Kp e^(-L.s)/(T.s+1)
  % 
  % Parametros del controlador PI:
  % Kr = (0.15/Kp)+(0.35-L.T/(L+T)^2).(T/(Kp.L))
  % TI = T + L/2
  % 
  % Parametros del controlador PID:
  % Kr = (1/Kp).(0.2+0.45.T/L)
  % TI = (0.4.L+0.8.T).L/(L+0.1.T)
  % TD = 0.5.L.T/(0.3.L+T)
  %
  %
  % PI-AMIGO
  Kr_PI_AMIGO = (0.15/Kp)+(0.35-L*T/(L+T)^2)*(T/(Kp*L));
  TI_PI_AMIGO = 0.35*L+(13*L*T^2)/(T^2+12*L*T+7*L^2);
  TD_PI_AMIGO = 0;
  % PID-AMIGO
  Kr_PID_AMIGO = (1/Kp)*(0.2+0.45*T/L);
  TI_PID_AMIGO = (0.4*L+0.8*T)*L/(L+0.1*T);
  TD_PID_AMIGO = 0.5*L*T/(0.3*L+T);


  %--------------------------------------------
  % Metodo Lambda:
  %---------------
  %               Asume FOTD, Gp(s) = Kp e^(-L.s)/(T.s+1)
  % 
  %
  % Parametros del controlador PI:
  % Kr = (1/Kp).T/(L+Tcl)
  % TI = T
  %
  % Parametros del controlador PID:
  % Kr = (L/2 + T)/Kp.(L/2 + Tcl)
  % TI = T + L/2
  % TD = T.L/L + 2.T
  %
  % donde Tcl es un parametro de ajuste. Para PI se aconseja: Tcl=3T para un
  % controlador robusto y Tcl = T para una sintonizacion agresiva
  %
  %disp('Metodo Lambda:')
  % PI-Metodo Lambda
  Tcl=L;
  Kr_PI_LAMBDA = (1/Kp)*T/(L+Tcl);
  TI_PI_LAMBDA = T;
  TD_PI_LAMBDA = 0;
  % PID-Metodo Lambda
  Tcl=L;
  Kr_PID_LAMBDA = (L/2 + T)/(Kp*(L/2 + Tcl));
  TI_PID_LAMBDA = T + L/2;
  TD_PID_LAMBDA = T*L/(L + 2*T);


 else
  %Identifico segundo orden con delay
  Kp=parametros(1), T1=parametros(2), T2=parametros(3), L=parametros(4),
  
  % Metodo S-IMC (Skogestad 2003):
  % ------------------------------
  %               Asume SOTD, Gp(s) = Kp e^(-L.s)/(T1.s+1)(T2.s+1)
  %                                   con T1 > T2
  %
  % Parametros del controlador:
  % Kr = T1/Kp.(Tcl+L)
  % TI = min{T1,4.(Tcl+L)}
  % TD = T2
  %
  % donde Tcl es un parametro de ajuste. Astrom y Hagglum recomiendan Tcl=L
  % con lo que las formulas de Kr y TI resultan
  % Kr = T1/Kp.2.L
  % TI = min{T1,8.L}
  % TD = T2
  %
  %
  % PI-SIMC
  Kr_PI_SMIC = NaN;
  TI_PI_SMIC = NaN;
  TD_PI_SMIC = NaN;
  % PID-SIMC
  Kr_PID_SIMC = T1/(Kp*2*L);
  TI_PID_SIMC = min([T1 8*L]);
  TD_PID_SIMC = T2;


endif


Kr_CBM=[Kr_PI_SMIC Kr_PID_SMIC  Kr_PI_AMIGO Kr_PID_AMIGO Kr_PI_LAMBDA Kr_PID_LAMBDA];
TI_CBM=[TI_PI_SMIC TI_PID_SMIC  TI_PI_AMIGO TI_PID_AMIGO TI_PI_LAMBDA TI_PID_LAMBDA];
TD_CBM=[TD_PI_SMIC TD_PID_SMIC  TD_PI_AMIGO TD_PID_AMIGO TD_PI_LAMBDA TD_PID_LAMBDA];


endfunction
