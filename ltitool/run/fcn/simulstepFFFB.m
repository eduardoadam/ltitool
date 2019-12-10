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

## 
## Calculate the step response of closed loop transfer function
## with a feedforward control system
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##

function [t,resp_escalon,resp_escalon_sinFF,AmplitudR,Tstop,yinf, ...
          gamma_tol,delay,sigma_domin,Test,cont_Test]=simulstepFFFB(Gp,Gl,Gv,C,Gm,Gt,Gtl,Cff,delay, ...
                                                                   AmplitudR,AmplitudL,TiniR,TiniL,Tstop,haChCons,haChCarga,nptos);
  %---------------------------
  %Funciones de transferencias
  %---------------------------
  %Y-R
  delay=0;
  G=Gp*Gv*C; H=Gm; Gyr=minreal(feedback(G,H)*Gt);
  %Y-L con control feedforward
  Gyl=minreal((Gl-Gtl*Cff*Gp*Gv)/(1+Gp*Gv*C*Gm));
  nGyl=Gyl.num{1,1}; dGyl=Gyl.den{1,1};
  %Y-L sin control feedforward
  Gyl_sinFF=minreal((Gl)/(1+Gp*Gv*C*Gm));
  nGyr=Gyr.num{1,1}; dGyr=Gyr.den{1,1};
  nGyr0=nGyr(length(nGyr)); dGyr0=dGyr(length(dGyr));
  Kyr=nGyr0/dGyr0;
  
  % -----------------------------
  % Respuesta al escalon en carga
  % -----------------------------
  %Chequeo compensacion perfecta
  primer_elemento_Gyl=nGyl(1);
  if (primer_elemento_Gyl==0), 
    compensacion_perfecta="yes";
   else 
    compensacion_perfecta="no";
  endif

  switch compensacion_perfecta
   case {"yes"}
    DT=Tstop/nptos;			%Intervalo de tiempo
    t=[0:DT:DT*nptos];
    % Respuesta al escalon con feedforward
    resp_escalonL=zeros(1,length(t))';
    
    % Respuesta al escalon sin feedforward
    if (TiniL <Tstop)
      tinicialL=[0:DT:TiniL]';
      resp_escalonL_inicial=zeros(1,length(tinicialL))';  % Respuesta antes del escalon en L
      [resp_escalonL_2_sinFF,t]=step(Gyl_sinFF,Tstop,DT);	% Respuesta al escalon UNITARIO
      resp_escalonL_sinFF= [resp_escalonL_inicial; AmplitudL*resp_escalonL_2_sinFF(1:length(t)-length(resp_escalonL_inicial))];
      else
      resp_escalonL_sinFF=zeros(1,length(t))';
    endif
    %Respuesta al escalon
    if (TiniR <Tstop)
      tinicialR=[0:DT:TiniR]';
      resp_escalonR_inicial=zeros(1,length(tinicialR))';  %Respuesta antes del escalon en R
	    [resp_escalonR_2,t]=step(Gyr,Tstop,DT);	%Respuesta al escalon UNITARIO
      resp_escalonR= [resp_escalonR_inicial; AmplitudR*resp_escalonR_2(1:length(t)-length(resp_escalonR_inicial))];
      yinfR=Kyr*AmplitudR;
      else
      tinicialR=[0:DT:TiniR]';
      resp_escalonR=zeros(1,length(t))';
      yinfR=0;
    endif

    % --------------------------------
    % Si una opcion no esta clickeada
    % --------------------------------
    if (haChCons==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonR=zeros(1,length(t))';
    endif
    if (haChCarga==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonL=zeros(1,length(t))';
      resp_escalonL_sinFF=zeros(1,length(t))';
    endif

    % --------------------------------------
    %Respuestas a las entradas simultaneas
    % --------------------------------------
    % Respuestas a los escalones simultaneos con control feedforward
    resp_escalon=resp_escalonL+resp_escalonR;
    % Respuestas a los escalones simultaneos sin control feedforward
    resp_escalon_sinFF=resp_escalonL_sinFF+resp_escalonR;

    % ---------------------
    % Información adicional
    % ---------------------
    sigma_domin=max(real(roots(dGyl)));
	  if abs(sigma_domin)<10^(-8), sigma_domin=0;endif
	  if (sigma_domin < 0)
		  estabilidad="Sist. Estable";
      % Valor de establecimiento
		  yinf=yinfR;
		
      cont_Test=NaN;
		  gamma_tol=0.02;	%settling time tolerance
      [resp_escalonR_unitario,t]=step(Gyr,Tstop,DT);
		  [tiempo_est,cont_Test]=settlingtime(t,resp_escalonR_unitario,sigma_domin,Kyr*AmplitudR,gamma_tol);
      cont_Test=cont_Test+length(tinicialR);
      Test=tiempo_est+TiniR;
      
      
	  	elseif (sigma_domin == 0)
		  	estabilidad="Sist. Crit. Estable";
			  yinf=NaN;
  			gamma_tol=NaN;
	  		Test=NaN;
		  	cont_Test=NaN;
		  else
			  estabilidad="Sist. Inestable";
			  yinf=Inf;
			  gamma_tol=NaN;
			  Test=NaN;
			  cont_Test=NaN;
	  endif
    
   case {"no"}
    %Respuesta al escalon
    DT=Tstop/nptos;			%Intervalo de tiempo
    t=[0:DT:DT*nptos];
    
    % Respuesta al escalon con feedforward
    if (TiniL <Tstop)
      tinicialL=[0:DT:TiniL]';
      resp_escalonL_inicial=zeros(1,length(tinicialL))';  % Respuesta antes del escalon en L
      [resp_escalonL_2_conFF,t]=step(Gyl,Tstop,DT);	      % Respuesta al escalon UNITARIO
      resp_escalonL_conFF= [resp_escalonL_inicial; AmplitudL*resp_escalonL_2_conFF(1:length(t)-length(resp_escalonL_inicial))];
    else
    resp_escalonL_conFF=zeros(1,length(t))';
    endif

    % Respuesta al escalon sin feedforward
    if (TiniL <Tstop)
      tinicialL=[0:DT:TiniL]';
      resp_escalonL_inicial=zeros(1,length(tinicialL))';  % Respuesta antes del escalon en L
      [resp_escalonL_2_sinFF,t]=step(Gyl_sinFF,Tstop,DT);	      % Respuesta al escalon UNITARIO
      resp_escalonL_sinFF= [resp_escalonL_inicial; AmplitudL*resp_escalonL_2_sinFF(1:length(t)-length(resp_escalonL_inicial))];
      else
      resp_escalonL_sinFF=zeros(1,length(t))';
    endif
    %Respuesta al escalon
    if (TiniR <Tstop)
      tinicialR=[0:DT:TiniR]';
      resp_escalonR_inicial=zeros(1,length(tinicialR))';  %Respuesta antes del escalon en R
	    [resp_escalonR_2,t]=step(Gyr,Tstop,DT);	%Respuesta al escalon UNITARIO
      resp_escalonR= [resp_escalonR_inicial; AmplitudR*resp_escalonR_2(1:length(t)-length(resp_escalonR_inicial))];
      yinfR=Kyr*AmplitudR;
      else
      tinicialR=[0:DT:TiniR]';
      resp_escalonR=zeros(1,length(t))';
      yinfR=0;
    endif

    % --------------------------------
    % Si una opcion no esta clickeada
    % --------------------------------
    if (haChCons==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonR=zeros(1,length(t))';
    endif
    if (haChCarga==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonL_conFF=zeros(1,length(t))';
      resp_escalonL_sinFF=zeros(1,length(t))';
    endif

    % --------------------------------------
    %Respuestas a las entradas simultaneas
    % --------------------------------------
    % Respuestas a los escalones simultaneos con control feedforward
    resp_escalon=resp_escalonL_conFF+resp_escalonR;
    % Respuestas a los escalones simultaneos sin control feedforward
    resp_escalon_sinFF=resp_escalonL_sinFF+resp_escalonR;
    

    % ---------------------
    % Información adicional
    % ---------------------
    %Determino polos, ceros y ganancia de lazo cerrado entre Y-R
    [ceros_lc,polos_lc,Kyr] = xzpkdata(nGyr,dGyr);
    sigma_domin=max(real(polos_lc));
	if abs(sigma_domin)<10^(-8), sigma_domin=0;endif
	  if (sigma_domin < 0)
		  estabilidad="Asympt. Stable";
                  % Valor de establecimiento
                  yinf=yinfR;
      
		  gamma_tol=0.02;	%settling time tolerance
                  [resp_escalonR_unitario,t]=step(Gyr,Tstop,DT);
		  [tiempo_est,cont_Test]=settlingtime(t,resp_escalonR_unitario,sigma_domin,Kyr*AmplitudR,gamma_tol);
                  cont_Test=cont_Test+length(tinicialR);
                  Test=tiempo_est+TiniR;
      
	  	elseif (sigma_domin == 0)
		  	estabilidad="Crit. Stable";
			  yinf=NaN;
  			gamma_tol=NaN;
	  		Test=NaN;
		  	cont_Test=NaN;
		  else
			  estabilidad="Unstable";
			  yinf=Inf;
			  gamma_tol=NaN;
			  Test=NaN;
			  cont_Test=NaN;
	  endif
  endswitch
 
endfunction

