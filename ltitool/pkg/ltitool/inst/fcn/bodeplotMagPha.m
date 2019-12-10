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
%
% Plot a Bode diagram from the following data:
%      nGH: transfer plant numerator
%      dGH: transfer plant denominator
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function [Kast,Kast_ult,wultimo,GM,wcg,PM]=bodeplotMagPha(nGH,dGH,delay,Kr,flagMagPha);
 	[ceros_la, polos_la,KGH]=xzpkdata(nGH,dGH);
  nGH=nGH/KGH;
  GH_K = tf(nGH,dGH); % Queda GH adimensionalizado en KGH
  Kasteric=KGH;

	GH=tf(Kasteric*nGH,dGH);
	%gs=tf(nGH,dGH);
	[mGH,pGH,w]=bode(GH); 
	winf=length(w); 
	wsup=length(w);
	[Kast,Kast_ult,wultimo,GM,wcg,PM]=xbodeplotMagPha(GH,Kasteric,mGH,pGH,delay,w,flagMagPha);
endfunction
