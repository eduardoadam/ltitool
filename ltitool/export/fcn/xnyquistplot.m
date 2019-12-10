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


% [Kast,Kast_ult,wultimo,GM,wcg,PM] = xnyquistplot(GH,Kasteric,realGH,imagGH,magud,phaud,delay,w);
%
% Plot a Nyquits diagram from the following data:
%      realGH   : transfer plant numerator
%      imagGH : transfer plant denominator
%      delay       : plant delay
%      w                : frequency interval
%

## Created:  2008
## updated for new system data structure format:  febrary 2012

## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [Kast,Kast_ult,wultimo,GM,wcg,PM] = xnyquistplot(GH,Kasteric,realGH,imagGH,magud,phaud,delay,w);


# fix the phase wrap arownd
%phw=unwrap(phaud*pi/180);
%phaud=phw*180/pi;

#Cálculo del Margen de ganancia y fase su localización con Delay
#----------------------------------------------------------------
%[GM,PM,w180,wg,ix,ipmx]=xmargin(GH,delay,w);

[Kast,Kast_ult,wultimo,GM,wcg,PM]=additionalinfofreq(GH,Kasteric,magud,phaud,delay,w);


% Plot
%figure; 
hold on;

graf=plot(realGH,imagGH,'b',realGH,-imagGH,'r');
%set(graf,'fontsize',20);  
%set(graf,'color','b');
set(graf,'linewidth',1.2);
tit=title('Nyquist Diagram');
set (tit, 'fontsize',14) ;
xlab=xlabel('Real part of G(s)H(s)');
%set (xlab, 'fontsize',18) ;
ylab=ylabel('Imaginary part of G(s)H(s)');
%set ( ylab, 'fontsize',18) ;
grid;

limits=axis;
xmax=limits(2); ymin=limits(3); ymax=limits(4);

h=legend('0<\omega<\infty','-\infty<\omega<0');

hold off


endfunction
