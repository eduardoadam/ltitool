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
% Calculate aditional information about transfer function
%
## Created:  2008
## updated for new system data structure format:  febrary 2012


## Author: Eduardo J. Adam <eadam@fiq.unl.edu.ar>, 
## FIQ-UNL, Santiago del Estero 2654, S3000AOM, Santa Fe, Argentina
## web-page: www.fiq.unl.edu.ar/control
##


function [tOver, vOver, vUnder, tUnder, tSOver, vSOver, vSeuPer, endVal]=adidata2(nGol, dGol, Tini, Tstop, Nptos)
     Gol=tf(nGol,dGol);
     if (Tini==0) 
       Tini=1; 
     endif
     [stepresp, t] = step(Gol, Tstop);     
     [vOver, ios] = max(stepresp);
     tOver = t(ios);
    
     stepresp2 = stepresp(ios:length(stepresp));
     [vUnder, ius] = min (stepresp2);
     tUnder = t(ios+ius-1);
     
     stepresp3 = stepresp(ios+ius-1:length(stepresp));
     [vSOver, ios2]=max(stepresp3);
     tSOver = t(ios+ius+ios2-2);
     vSeuPer= tSOver-tOver;
     
     [z, p, endVal]=zpkdata(tf(nGol,dGol));
endfunction

