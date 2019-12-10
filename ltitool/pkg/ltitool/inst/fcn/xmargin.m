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
% Compute gain and phase margin from the following data:
%     transfer function: GH
%      magnitud of GH: magud
%      phase of GH        : phaud
%     plant delay            : delay
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function [GM,PM, w180,wg,ix,ipmx] = xmargin(GH,delay,w);

[magud,phaud,w] = bode(GH);

# fix the phase wrap arownd
phw=unwrap(phaud*pi/180);
phaud=phw'.*180/pi;


% delayed plant phase,
phad = phaud + (-w.*delay).*180/pi;

% answer,
modx=magud;
phax=phad;



# find the Gain Margin  and its location
[x,ix]=min(abs(phax+180));
if (x>1)
  GMd="INF dB";
  w_180d="NaN rad/s";
  ix=length(phax);
else
  GMd=(1/magud(ix));
  w_180d=w(ix);		%Frecuencia de cruce de face (distancia a 1)
endif

# find the Phase Margin and its location
[pmx,ipmx]=min(abs(magud-1));
PMd=180+phax(ipmx);
w_gd=w(ipmx);		%Frecuencia de cruce de ganancia (distancia a -180°)



#Cálculo del Margen de ganancia y fase su localización sin Delay
#------------------------------------------------------------------------------------------------
% Si la planta no tiene delay uso el comando margin, ya que puede dar un resultado más exacto
% Notar que el cálculo anterior también funciona si la planta no tiene Delay
% computes Zeros, polos and gain of G(s)H(s)
[GMud, PMud, w_GMud, w_PMud] = margin(GH);
if (delay==0)
	GM=(GMud); wg=w_PMud;
	PM=PMud; w180=w_GMud;
	else
	GM=GMd; wg=w_gd;
	PM=PMd; w180=w_180d;
endif


endfunction

