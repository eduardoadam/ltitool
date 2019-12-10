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
% Plot a Bode diagram from the following data:
%      n: transfer plant numerator
%      d: transfer plant denominator
%      delay: plant delay
% Compute Gain Margin and Phase Margin
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [Kast,Kast_ult,wultimo,GM,wcg,PM] = xbodeplotMagPha(GH,Kasteric,magud,phaud,delay,w,flagMagPha);

  % define colors
  myblue=[0/255 133/255 188/255];
  myred =[216/255 82/255 24/255];
  mygreen=[64/255 128/255 32/255];
  myyelow=[236/255 176/255 31/255];
  myviolet=[125/255 46/255 141/255];
  
# fix the phase wrap arownd
phw=unwrap(phaud*pi/180);
phaud=phw*180/pi;

% delayed plant phase,
phad=phaud + ((-w.*delay)*180/pi)';


% answer,
modx=magud; phax=phad;
mag_gs_db=(20*log10(magud))';


%size(mag_gs_db)

%GH=ghs;
#Cálculo del Margen de ganancia y fase su localización con Delay
#----------------------------------------------------------------
[GM,PM,w180,wg,ix,ipmx]=xmargin(GH,delay,w); 

% calculo la posicion del vector en donde se encuentra wg por que aveces puede
% fallar el calculo,
[minw,iwg]=min(abs(w-wg));

% Bode plot,
x1=w; y1=ones(1,length(w));
x180 = w; y180=-180.*ones(1,length(w));

 %------------------------------------------------
 %Grafico los diagramas de Bode de magnitud y fase
 %------------------------------------------------
 %figure();		% COMENTAR ESTA FIGURA CUANDO SE QUIERE QUE LA MISMA SALGA DENTRO DE LA FIG. PRICIPAL
hold on;

% Busco informacion adicional
[Kast,Kast_ult,wultimo,GM,wcg,PM]=additionalinfofreq(GH,Kasteric,magud,phaud,delay,w);


% Defino ejes
ejesmag=[w(1) w(end) min(magud) max(magud)];
ejespha=[w(1) w(end) min(phad)  max(phad)];

% variable para comparar con la bandera de grafico
grafico='gragicoMag';
graficar=strcmp(grafico,flagMagPha);

if (graficar==1);
    % si la comparacion da 1 entonces grafica magnitud
    grafmag=loglog(w,magud,'Color',myblue,'linewidth',2); hold on
    loglog([w(ix) w(ix)], [min(magud) magud(ix)],'--','Color',myviolet,'linewidth',1.5, ...
            x1, y1,'--','Color',myred,'linewidth',1.5, ...
           [w(iwg) w(iwg)], [magud(iwg) min(magud)],'--','Color',mygreen,'linewidth',1.5);
    set(grafmag,'linewidth',1.2);
    tit=title('Bode Magnitude Diagram');
    set(tit,'fontsize',14);  
    set(tit,'color','k');
    xlabel('Frecuency (rad/s)'); grid
    ylabel('Magnitude (adim.)')
  else
    % si la comparacion da 0 entonces grafica fase
    grafpha=semilogx(w,phax,'Color',myblue,'linewidth',2); hold on
    semilogx([w(ix) w(ix)], [max(phad) phax(ix)],'--','Color',myviolet,'linewidth',1.5,  ...
              x180, y180,'--','Color',myred,'linewidth',1.5, ...
              [w(iwg) w(iwg)], [max(phad) -180],'--','Color',mygreen,'linewidth',1.5); grid
    set(grafpha,'linewidth',1.2);
    tit=title('Bode Phase Diagram');
    set(tit,'fontsize',14);  
    set(tit,'color','k');
    xlabel('Frecuency (rad/s)')
    ylabel('Phase (grad.)')
endif
hold off

endfunction
