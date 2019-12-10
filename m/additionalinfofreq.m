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


%function  [Kast,Kast_ult,wultimo,GM,wPM,PM]=additionalinfofreq(GH,Kasteric,magud,phaud,delay,w);
%
% Calculate aditional information related to:
%      estability condition
%      Kast_ult: K* ultimo
%      GM and PM:  gain margin and phase margin
%      wultimo: w at -180°
%      wcg: w at gain crossing

## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##



function  [Kast,Kast_ult,wultimo,GM,wcg,PM]=additionalinfofreq(GH,Kasteric,magud,phaud,delay,w);

# fix the phase wrap arownd
phw=unwrap(phaud*pi/180);
phaud=phw*180/pi;

% delayed plant phase,
phad=phaud + ((-w.*delay)*180/pi)';


% answer,
modx=magud; phax=phad;
mag_gs_db=(20*log10(magud))';

if delay ==0,

	% Solo para este caso el comando margin va a trabajar con GH/K* !!!!!!!!!!! REVISAR
	[GM, PM, w180, wcg] = margin(GH); 
	Kultimo=GM;

	#Informo Resultados
	if (Kultimo==Inf)
		wultimo=NaN;
		else
		wultimo=w180;
	endif
	else,

	#Cálculo del Margen de ganancia y fase su localización con Delay
	#----------------------------------------------------------------
	[GM,PM,w180,wcg,ix,ipmx]=xmargin(GH,delay,w);
	Kultimo=GM;
	wultimo=w180;
endif


% Resultados
Kast=Kasteric;
Kast_ult=Kultimo*Kasteric;
GM=Kultimo;


end
