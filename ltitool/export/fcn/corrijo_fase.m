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
% Permite cambiar la fase de un vector complejo
%
%

## Created:  2008
## updated for new system data structure format:  febrary 2012

## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [real_vec_new,imag_vec_new]=corrijo_fase(real_vec,imag_vec,delay,frec_vec)

%modulo
R = sqrt(real_vec^2+imag_vec^2);

% cambia la fase
fase=atan2(imag_vec,real_vec)-delay*frec_vec;
real_vec_new=R*cos(fase);
imag_vec_new=R*sin(fase);

% Grafico
%tita = (0:0.01:2.01*pi);
%x = R*cos(tita);
%y = R*sin(tita);
%plot(real_vec,imag_vec,'xr',real_vec_new,imag_vec_new,'xk',x,y,'-b')



endfunction