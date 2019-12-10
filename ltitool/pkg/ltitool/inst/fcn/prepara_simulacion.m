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
% Programa para una simulación de sistemas lineales con delay,
%
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function prepara_simulacion(Gp,plantdelay,Kr,TI,TD,flag_simula) %,N,Tstop

figure(1), clf, figure(2), clf

%Datos
Tstop=10;


% Definiciones
Ts=Tstop/500;
%s=tf('s');  %Defino Variable s
z=tf('z',Ts);

%Defino el vector de colores
color01=[255 0   0]/255;        %P-ZN   - Curva de reaccion
color02=[255 64  0]/255;        %PI-ZN  - Curva de reaccion
color03=[255 128 0]/255;        %PID-ZN - Curva de reaccion
color04=[192 0   64]/255;       %P-CC   - Curva de reaccion
color05=[192 0   128]/255;      %PI-CC  - Curva de reaccion
color06=[128 0   0]/255;        %PID-CC - Curva de reaccion
color07=[128 102 0]/255;        %P-ZN   - Oscilaciones Sostenidas
color08=[212 170 0]/255;        %PI-ZN  - Oscilaciones Sostenidas
color09=[255 204 0]/255;        %PID-ZN - Oscilaciones Sostenidas
color10=[212 128 0]/255;        %PI-TL  - Oscilaciones Sostenidas
color11=[255 192 128]/255;      %PID-Luy- Oscilaciones Sostenidas
color12=[255 230 128]/255;      %PID-Ada- Oscilaciones Sostenidas
color13=[0   0   255]/255;      %PI-Rov - IAE
color14=[0   136 170]/255;      %PID-Rov- IAE
color15=[95  188 255]/255;      %PI-Rov - ITAE
color16=[0   255 255]/255;      %PID-Rov- ITAE
color17=[68  85  0]/255;        %PI-Sko - S-IMC
color18=[136 170 0]/255;        %PID-Sko- S-IMC
color19=[204 255 0]/255;        %PI     - AMIGO
color20=[229 255 128]/255;      %PID    - AMIGO
color21=[64  255 128]/255;      %PI     - Lambda
color22=[170 222 135]/255;      %PID    - Lambda

color_fig= [color01; color02; color03; color04; color05; color06; color07; color08; color09; color10; ...
            color11; color12; color13; color14; color15; color16; color17; color18; color19; color20; ...
            color21; color22];
% Planta
%Gp=1/(s^2+5*s+1);
%plantdelay=0.2;
%Gp=0.99796/(4.6024*s+1);
%plantdelay=0.37374;

%Paràmetro del modo derivativo
N=10; %Parametro para realizabilidad del modo derivativo

%Controladores adoptados para la simulacion
%flag_simula= [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0];


[tiempo_u,manipulada,tiempo_y,salida]=grafico_simula_con_delay(Gp,plantdelay,Kr,TI,TD,Tstop,flag_simula,color_fig,N);


%save("simula_soft","tzn","yzn","tAMIGO","yAMIGO","tLambda","yLambda","-mat")
