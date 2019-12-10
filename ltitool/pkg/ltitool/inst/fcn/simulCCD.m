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
## Calculate the step response based on closed loop transfer function
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##

% [t,resp_escalon]=simulCCD(Gp1,Gp2,Gv,Cint,Cext,Gm1,Gm2,GHint,Gt,delay,Gl1,Gl2, ...
%                      AmplitudR,AmplitudL1,AmplitudL2,TiniR,TiniL1,TiniL2,Tstop, ...
%                      haChCons,haChCarga1,haChCarga2,nptos)
%

function [t,resp_escalon,yinf,gamma_tol,delay,sigma_domin,Test,cont_Test]=simulCCD(Gp1,Gp2,Gv,Cint,Cext,Gm1,Gm2,GHint,Gt,delay,Gl1,Gl2, ...
                              AmplitudR,AmplitudL1,AmplitudL2,TiniR,TiniL1,TiniL2,Tstop, ...
                              haChCons,haChCarga1,haChCarga2,nptos);
  
  %---------------------------
  % Transfer functions
  %---------------------------
  % Y_R
  Gastint1=Cint*Gv*Gp2/(1+GHint);
  Gyr=minreal(Cext*Gastint1*Gp1*Gt/(1+Gm1*Cext*Gastint1*Gp1));
  nGyr=Gyr.num{1,1}; dGyr=Gyr.den{1,1};
  nGyr0=nGyr(length(nGyr)); dGyr0=dGyr(length(dGyr));
  Kyr=nGyr0/dGyr0;
  % Y-L1
  Gyl1=minreal(Gl1/(1+Gm1*Cext*Gastint1*Gp1));
  nGyl=Gyl1.num{1,1}; dGyl=Gyl1.den{1,1};
  % Y-L2
  Gastint2=Gl2/(1+Gm2*Cint*Gv*Gp2);
  Gyl2=minreal(Gastint2*Gp1/(1+Gm1*Cext*Gastint1*Gp1));
  nGyl2=Gyl2.num{1,1}; dGyl2=Gyl2.den{1,1};

  % Inicia simulacion
  DT=Tstop/nptos;	%Intervalo de tiempo
  t=[0:DT:DT*nptos];

    % --------------------------------
    % Step response for L1
    % --------------------------------
    if (TiniL1 <Tstop)
      tinicialL1=[0:DT:TiniL1]';
      resp_escalonL1_inicial=zeros(1,length(tinicialL1))';  % Respuesta antes del escalon en L
      [resp_escalonL1_2,t]=step(Gyl1,Tstop,DT);	          % Respuesta al escalon UNITARIO
      resp_escalonL1= [resp_escalonL1_inicial; AmplitudL1*resp_escalonL1_2(1:length(t)-length(resp_escalonL1_inicial))];
      else
      resp_escalonL1=zeros(1,length(t))';
    endif
    % --------------------------------
    % Step response for  L2
    % --------------------------------
    if (TiniL2 <Tstop)
      tinicialL2=[0:DT:TiniL2]';
      resp_escalonL2_inicial=zeros(1,length(tinicialL2))';  % Respuesta antes del escalon en L
      [resp_escalonL2_2,t]=step(Gyl2,Tstop,DT);	          % Respuesta al escalon UNITARIO
      resp_escalonL2= [resp_escalonL2_inicial; AmplitudL2*resp_escalonL2_2(1:length(t)-length(resp_escalonL2_inicial))];
      else
      resp_escalonL2=zeros(1,length(t))';
    endif
    % -----------------------------
    % Set-point step response
    % -----------------------------
    if (TiniR <Tstop)
      tinicialR=[0:DT:TiniR]';
      resp_escalonR_inicial=zeros(1,length(tinicialR))';  %Respuesta antes del escalon en R
	    [resp_escalonR_2,t]=step(Gyr,Tstop,DT);	  %Respuesta al escalon UNITARIO
      resp_escalonR= [resp_escalonR_inicial; AmplitudR*resp_escalonR_2(1:length(t)-length(resp_escalonR_inicial))];
      yinfR=Kyr*AmplitudR;
      else
      tinicialR=[0:DT:TiniR]';
      resp_escalonR=zeros(1,length(t))';
      yinfR=0;
    endif

    % --------------------------------
    % If an options is not clicked
    % --------------------------------
    if (haChCons==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonR=zeros(1,length(t))';
    endif
    if (haChCarga1==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonL1=zeros(1,length(t))';
    endif
    if (haChCarga2==0)
      tinicialR=[0:DT:TiniR]';
      resp_escalonL2=zeros(1,length(t))';
    endif

    % --------------------------------------
    % Simultaneous step response
    % --------------------------------------
    resp_escalon=resp_escalonL1+resp_escalonL2+resp_escalonR;   % Respuestas a los escalones simultaneos
    % --------------------------------------

    % ---------------------
    % Aditional Information
    % ---------------------
    sigma_domin=max(real(roots(dGyl)));
	  if abs(sigma_domin)<10^(-8), sigma_domin=0;endif
	  if (sigma_domin < 0)
		  estabilidad="Asympt. Stable";
      		  % Settling value
		  yinf=yinfR;
		
      		  cont_Test=NaN;
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
endfunction
