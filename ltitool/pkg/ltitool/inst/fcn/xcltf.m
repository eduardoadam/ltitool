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


## Calculate closed loop transfer function to siso system
##
## Created:  2012
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [gcl]=xcltf(ngt,dgt,ngc,dgc,ngv,dgv,ngp,dgp,ngm,dgm)
	
	%Cadena Directa
	%numerador de  la cadena directa
	nsys1=conv(conv(ngp,ngv),ngc);
	%denominador de la cadena directa
	dsys1=conv(conv(dgp,dgv),dgc);
	sys1=tf(nsys1,dsys1);
		
	%Cadena de Realimentaci'on
	sys2=tf(ngm,dgm);
		
	%Sistema Realimentado
	gcl1=feedback(sys1,sys2);
	
	% Numerator and denominator of feedback system
	%[ngcl1,dgcl1]=sys2tf(gcl1);         %%%ACA CHEQUEAR
	[ngcl1,dgcl1]=tfdata(gcl1,"vector");

	% Final closed loop transfer function
	ngcl=conv(ngcl1,ngt);
	dgcl=conv(dgcl1,dgt);
	gcl=tf(ngcl,dgcl);
endfunction	
	
	
	
