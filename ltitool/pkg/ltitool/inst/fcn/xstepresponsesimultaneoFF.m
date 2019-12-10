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
% Plot a simultaneous step response diagram for a feedforward-feedback 
% control system from the following data:
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


function  xstepresponsesimultaneoFF(t,resp_escalon,resp_escalon_sinFF,AmplitudSP,Tstop,yinf,gamma_tol,delay,sigma_domin,Test,cont_Test);



%Set-point
ysp=ones(1,length(t))'*AmplitudSP;


%figure;
hold on
graf=plot(t,ysp,'r',t,resp_escalon,'b',t,resp_escalon_sinFF,'g');
set(graf,'linewidth',1.8);
tit=title('Dynamic Response of the Control System');
set(tit,'fontsize',14);  
grid;
legend(graf,'Setpoint','Resp. with FF','Resp. without FF');
%legend location northeastoutside
axis([0 Tstop])

if yinf~=Inf & yinf~=NaN
	yinf_vec=yinf*ones(1,length(t))';
	%gamma_st=0.02;
	yinf_vec_sup=(1+gamma_tol)*yinf_vec;
	yinf_vec_inf=(1-gamma_tol)*yinf_vec;
endif



%limits=axis;
%xmax_axis=limits(2); ymin_axis=limits(3); ymax_axis=limits(4);

%xtext=1.02*xmax_axis;
%if abs(ymin_axis)>=abs(ymax_axis)
%	ymedio=(ymin_axis+ymax_axis)/2;
%	if (ymedio~=0)
		if (sigma_domin < 0)
			p2=plot(t,yinf_vec,'linewidth',1.1, 'color', [0 128/255 0], ...
                 		                 	t,yinf_vec_sup,'--','linewidth',1.0,'color', [0.5 0.5 0.5], ...
                  		                 	t,yinf_vec_inf,'--','linewidth',1.0,'color', [0.5 0.5 0.5]);

			%text(xtext,1.20*ymedio,"Sist. Asint. Estable")
			%text(xtext,1.40*ymedio,sprintf ("y_{\\infty}=%f",yinf))
      %text(xtext,1.60*ymedio,"Tiempo Est. en Consigna:")
			%text(xtext,1.80*ymedio,sprintf ("T_{est}=%f (aprox.)",Test))
			%legend(p2,'Valor Estac.')
		elseif (sigma_domin == 0)
			%text(xtext,1.20*ymedio,"Sist. Crit. Estable")
		else
			%text(xtext,1.20*ymedio,"Sist. Inestable")
		endif
%	else
%		text(xtext,0,"Inform. adicional:")
%		if (sigma_domin < 0)
%			p2=plot(t,yinf_vec,'linewidth',1.1, 'color', [0 128/255 0],\
 %                		                 	                 t,yinf_vec_sup,'linewidth',1.0,'color', [0.5 0.5 0.5],\ 
  %                		                 	                 t,yinf_vec_inf,'linewidth',1.0,'color', [0.5 0.5 0.5]);

			%text(xtext,0.2*ymin_axis,"Sist. Asint. Estable")
			%text(xtext,0.4*ymin_axis,sprintf ("y_{\\infty}=%f",yinf))
      %text(xtext,0.6*ymedio,"Tiempo Est. en Consigna:")
			%text(xtext,0.8*ymin_axis,sprintf ("T_{est}=%f (aprox.)",Test))
			%legend(p2,'Valor Estac.')
%		elseif (sigma_domin == 0)
			%text(xtext,0.2*ymin_axis,"Sist. Crit. Estable")
%		else
			%text(xtext,0.2*ymin_axis,"Sist. Inestable")
%		endif
%	endif
%else
	%ymedio=(ymax_axis-ymin_axis)/2;
	%text(xtext,ymedio,"Inform. adicional:")
%	if (sigma_domin < 0)
%		p2=plot(t,yinf_vec,'linewidth',1.1, 'color', [0 128/255 0],\
 %                		                 t,yinf_vec_sup,'linewidth',1.0,'color', [0.5 0.5 0.5],\ 
  %                		                 t,yinf_vec_inf,'linewidth',1.0,'color', [0.5 0.5 0.5]);

		%text(xtext,0.8*ymedio,"Sist. Asint. Estable")
		%text(xtext,0.6*ymedio,sprintf ("y_{\\infty}=%f",yinf))
    %text(xtext,0.4*ymedio,"Para Consigna:")
		%text(xtext,0.2*ymedio,sprintf ("T_{est}=%f (aprox.)",Test))
		%legend(p2,'Valor Estac.')
%	elseif (sigma_domin == 0)
		%text(xtext,0.8*ymedio,"Sist. Crit. Estable")
%	else
		%text(xtext,0.8*ymedio,"Sist. Inestable")
%	endif
		
%endif


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
