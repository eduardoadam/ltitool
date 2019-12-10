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
% This function makes Roots locus Plot
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [Kast,Kast_ult,wultimo,GM,w180,PM]=GHrlocusplot(nGH,dGH,Kr,nptos);
  
  % GH transfer function
  GHcompleto = tf(nGH,dGH);
 
 % Computes Zeros, polos and gain of G(s)H(s)
 [ceros_la, polos_la,KGH]=xzpkdata(nGH,dGH);
  nGH1=nGH/(KGH);
  GH = tf(nGH1,dGH); % GH/K transfer function
  Kasteric=KGH*sign(nGH(length(nGH)));

  % tThe characteristic equation to calculate the closed loop roots
  dcl = complete_vec(nGH,dGH);
	ro = roots(dcl);	% closed loop roots
	polos_lc_real = real(ro);
	polos_lc_imag = imag(ro);

	% Data to plot of root locus
	[rldata, k_break, rlpol, gvec, real_ax_pts] = rlocus(GHcompleto);
	Krlocus=gvec(length(gvec));
	if (Krlocus<Kasteric)
		inc_rlocus=Kasteric/nptos;
		[rldata, k_break, rlpol, gvec, real_ax_pts] = rlocus(GHcompleto,inc_rlocus, 0, Kasteric*1.2);
	endif

	[Kast,Kast_ult,wultimo,GM,w180,PM]=xrlocusplot(GH,rldata, k_break, rlpol,  gvec, real_ax_pts, polos_la, ceros_la, polos_lc_real, polos_lc_imag, nGH, dGH, abs(Kasteric));
endfunction
