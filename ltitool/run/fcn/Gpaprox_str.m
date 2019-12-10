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
## Convierte datos numéricos en cadena de caracteres para ser
## presentados en la ventana pidtuning.py
## 
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [numGpaprox_str, denGpaprox_str, delayGpaprox_str]=Gpaprox_str(numGpaprox, denGpaprox, delayGpaprox,opt)

 if (opt==1)
	numGpaprox_str=num2str(numGpaprox);
	denGpaprox1_str=strcat(num2str(denGpaprox(1)),'*s');
	denGpaprox_str=strcat(denGpaprox1_str,'+1');
	delayGpaprox_str=strcat(num2str(delayGpaprox),'*s');
   else
	numGpaprox_str=num2str(numGpaprox);
	denGpaprox1_str=strcat(num2str(denGpaprox(1)),'*s^2');
	denGpaprox2_str=strcat(num2str(denGpaprox(2)),'*s');
	denGpaproxaux_str=strcat(strcat(denGpaprox1_str,'+'),denGpaprox2_str);
	denGpaprox_str=strcat(denGpaproxaux_str,'+1');
	delayGpaprox_str=strcat(num2str(delayGpaprox),'*s');
 endif

endfunction




