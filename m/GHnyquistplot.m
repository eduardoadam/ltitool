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
## Plot the Nyquist diagram based on G(s)H(s)
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [Kast,Kast_ult,wultimo,GM,wcg,PM]=GHnyquistplot(nGH,dGH,delay,Kr);
	
	GH=tf(nGH,dGH);
	[realGH,imagGH,w] = nyquist(GH);

	% Necesito calcular Kasteric para poder pasarlo
	[ceros_la, polos_la,KGH]=xzpkdata(nGH,dGH);
  nGH=nGH/KGH;
	%GH_K = tf(nGH,dGH); % Queda GH adimensionalizado en KGH
  Kasteric=KGH;
	

	% Corrijo la parte real e imaginaria por delay
  if (delay ~=0)
    for contador=1:length(imagGH)
      real_vec=realGH(contador);
      imag_vec=imagGH(contador);
      frec_vec=w(contador);
      [real_GH_corregido,imag_GH_corregido]=corrijo_fase(real_vec,imag_vec,delay,frec_vec);
      real_GH(contador)=real_GH_corregido;
      imag_GH(contador)=imag_GH_corregido;
    endfor
    realGH=real_GH; imagGH=imag_GH;
  endif

	[mGH,pGH,w]=bode(GH); % necesito pasar magnitud y fase para "info_adicional_freq.m"
	[Kast,Kast_ult,wultimo,GM,wcg,PM] = xnyquistplot(GH,Kasteric,realGH,imagGH,mGH,pGH,delay,w);
	
endfunction
