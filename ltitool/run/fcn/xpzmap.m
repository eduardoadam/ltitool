## Copyright (C) 2015
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
## Traza el mapa de polos y ceros de un sistema
## 
## Created:  2008
## updated for new system data structure format:  febrary 2015

## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [resp]=xpzmap(title_string,legend_ceros_string,legend_polos_string,nGs,dGs) %Mapa de polos y ceros
					
	gs=tf(nGs,dGs);
	[P,Z]=pzmap(gs);
	graf_mapa=plot(real(Z),imag(Z),'ob',real(P),imag(P),'xb');
	set(graf_mapa,'markersize',10');
  	tit=title(title_string); set(tit,'fontsize',14);
	xl=xlabel('Real Part'); set(xl,'fontsize',12);
	yl=ylabel('Poles y Zeros Imaginary Part'); set(yl,'fontsize',12);
	legend(legend_ceros_string,legend_polos_string);
	%legend location northeastoutside
	grid;
	hold off

endfunction

