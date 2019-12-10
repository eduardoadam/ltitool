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


%function  xstepGol(t,resp_escalon,Tstop);
%
% Plot a step response diagram from the following data:
%      t: time vector
%      resp_escalon: step response vector
%      Tstop: stop time
%      yinf: final value of step response
%      delay: delay
%      sigma_domin: domain pole
%      Test: settling time
%       
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function  xstepGOL(t,resp_escalon,step_amplitud,Tstop,yinf,gamma_tol,delay,sigma_domin,Test,cont_Test,string_title);

% limpio la figura antes de graficar
%axis([]);

%Escalon de entrada
entrada=step_amplitud*ones(1,length(t))';

cla reset

%figure
hold on
graf=plot(t,resp_escalon,'b');
set(graf,'linewidth',1.5);
tit=title(string_title);
set(tit,'fontsize',14);  
grid; 
axis([0 Tstop min(resp_escalon) 1.1*max(resp_escalon)]);
axis([0 Tstop])
limits=axis;
xmax_axis=limits(2); ymin_axis=limits(3); ymax_axis=limits(4);

% ----------------------------------------------------------
% Preparo grafico solo para sistema asintoticamente estable
% ----------------------------------------------------------
if yinf~=Inf & yinf~=NaN
	yinf_vec=yinf*ones(1,length(t))';
	yinf_vec_sup=(1+gamma_tol)*yinf_vec;
	yinf_vec_inf=(1-gamma_tol)*yinf_vec;

  % Grafico limites para el caso estable
   p1=plot(t,entrada,'--','linewidth',1.1, 'color', [255/255 0 0], ...
                t,yinf_vec_sup,'--','linewidth',1.0,'color', [0.5 0.5 0.5], ...
                t,yinf_vec_inf,'--','linewidth',1.0,'color', [0.5 0.5 0.5]);

  set(p1,'linewidth',1.5);
  h=legend('Output','Input');
endif
% ----------------------------------------------------------

% Grafico Respuesta dinamica
if (cont_Test<length(t))
	t_Test=t(cont_Test);
	y_Test=resp_escalon(cont_Test);
	linea_vertical=[0:y_Test/10:y_Test];
	vector_t_Test=t_Test*ones(1,length(linea_vertical));
	p5=plot(vector_t_Test,linea_vertical,'-.','color', [0.5 0.5 0.5], ...
                 	                  t_Test,y_Test,'o','color', [0 128/255 0]);
	set(p5,'markersize',6);
	set(p5,'MarkerFaceColor',[0,128/255,0]);
endif




hold off

endfunction

