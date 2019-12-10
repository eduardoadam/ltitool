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
%  Re-plot a rlocus diagram from the following data:
%    rldata,k_break, rlpol, gvec, GH real_ax_pts,polos_la,ceros_la,polos_lc_real,polos_lc_imag,nGH,dGH,z_la,p_la,k_la
%
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function [Kast,Kast_ult,wultimo,GM,w180,PM]=xrlocusplot(GH,rldata,k_break, rlpol, gvec, real_ax_pts,polos_la,ceros_la,polos_lc_real,polos_lc_imag, nGH,dGH,k_la);

ro_real=real(rldata);
ro_imag=imag(rldata);
polos_la_real=real(polos_la);
polos_la_imag=imag(polos_la);
ceros_la_real=real(ceros_la);
ceros_la_imag=imag(ceros_la);
rldata_real=real(rldata); 
rldata_imag=imag(rldata);
 
 % Intersect of the Asymptotes (Centroid),
 npolos = rows(polos_la_real); 
 mzeros = rows(ceros_la_real);
 
 if max(ceros_la_real) <= 0 & npolos-mzeros >=1,
	%if npolos-mzeros >=1,
		sigma0=(sum(polos_la_real)-sum(ceros_la_real))/(npolos-mzeros);
		for kk=0:npolos-mzeros-1,
			gamak=(2*kk+1)*180/(npolos-mzeros);
		endfor
	%endif
	elseif   max(ceros_la_real) > 0 & npolos-mzeros >=1,
		%disp('pase por aca')
		sigma0=(sum(polos_la_real)-sum(ceros_la_real))/(npolos-mzeros);
		for kk=0:npolos-mzeros-1,
			gamak=(2*kk)*180/(npolos-mzeros);
		endfor
endif

 % Calculate axes extrem
 for cont_i=1:rows(rldata),
 	 xmax(cont_i)=max((rldata_real(cont_i,:)));
 	 xmin(cont_i)=min((rldata_real(cont_i,:)));
 	 ymax(cont_i)=max(abs(rldata_imag(cont_i,:)));
 endfor
 omegap_max=max(ymax);
 sigma_max=max(xmax);
 sigma_min=min(xmin);
 
 
 % Constant zeta lines (0.23 and 0.45)
  theta023=acos(0.23);
 x_zeta023=-[0:abs(sigma_min)/20:abs(sigma_min)];
 y_zeta023=x_zeta023.*tan(theta023);
 
  theta045=acos(0.45);
 x_zeta045=-[0:abs(sigma_min)/20:abs(sigma_min)];
 y_zeta045=x_zeta045.*tan(theta045);
 
% ---------------
% Plot
% ---------------
hold on;

% Constant zeta lines are plotted
p0=plot(x_zeta023,y_zeta023,'--m', ...
                 x_zeta023,-y_zeta023,'--m', ...
                 x_zeta045,y_zeta045,'--','color', [0.5 0.5 0.5], ...
                 x_zeta045,-y_zeta045,'--','color', [0.5 0.5 0.5], ...
                 polos_lc_real,polos_lc_imag,'+r');
set(p0,'linewidth',1.2);
set(p0,'markersize',12);
legend('\zeta=0.23',' ','\zeta=0.45',' ','Closed loop root');
%legend location northeastoutside


% Branches are plotted
for cont=1:rows(rldata)
	p1=plot( rldata_real(cont,:),rldata_imag(cont,:)); 
	set(p1,'linewidth',1.2);
endfor

xlabel (sprintf ("gain=[%f,%f]: Real axis",gvec(1), gvec(length(gvec))));
ylabel ("Imag. axis");
p1=title('Root Locus');
set(p1,'fontsize',14); 

% Plot open loop poles
p2=plot(polos_la_real,polos_la_imag,'xr');
set(p2,'linewidth',1.2)
set(p2,'markersize',12)


 % Plot open loop zeros
if length(nGH) > 1,
	p4=plot(ceros_la_real,ceros_la_imag,'or');
	set(p4,'linewidth',1.2)
	set(p4,'markersize',12)
endif


% Calculate axes for the graphic
limits_axis=axis;
if (omegap_max==0)
	xmin_axis=limits_axis(1);  xmax_axis=limits_axis(2);
	ymin_axis=limits_axis(3);  ymax_axis=limits_axis(4);
else
	xmin_axis=-ceil(abs(sigma_min));  xmax_axis=ceil(sigma_max);
	ymin_axis=-ceil(omegap_max);  ymax_axis=ceil(omegap_max);
endif
if xmax_axis < 0, 
	xmax_axis=1;
endif
axis([xmin_axis xmax_axis  ymin_axis ymax_axis])
grid


% Only for this case the margin command works with (GH/K*)*(K*)
% Remember that the function recibes GH/K* and K*
[GM, PM, wGM, wPM] = margin(k_la*GH);  
Kultimo=k_la*GM; w180=wPM;

% Presents results
if (Kultimo==Inf)
	wultimo=NaN;
	else
	wultimo=wGM;
endif
%if xmax_axis==0,
%		xtext=0.05;
%	else
		xtext=1.1*xmax_axis;
%endif

% Results
Kast=k_la;
Kast_ult=Kultimo;
GM=Kultimo/k_la;

hold off

endfunction
