
%
% Archivo auxiliar para simular ejemplos
%
%

graphics_toolkit("fltk");
pkg load control
pkg load linear-algebra
pkg load odepkg
pkg load optim
pkg load signal
pkg load struct
pkg load symbolic

clear all

s=tf('s');


%Planta:
Gp=(s+1)/(s^2+s+1);
Gl=(s+1)/(s^2+s+1);
Gv=1/(s+1);
Kr=0.1; TI=1; C=Kr*(1+1/(TI*s));
Gm=1/(0.1*s+1);
Gt=1/(0.1*s+1);
Gtl=1/(0.1*s+1);
Cff=1/(0.1*s+1);
tiempo_muerto=0.2*s;
AmplitudR_FF=1;
AmplitudL_FF=1;
TiempoEntradaR_FF=1;
TiempoEntradaL_FF=50;
TiempoFinal_FF=100;
%option=1;
%Tstop=25;

%[resp]=
step_resp_FF(Gp,Gl,Gv,C,Gm,Gt,Gtl,Cff,tiempo_muerto,AmplitudR_FF, ...
             AmplitudL_FF,TiempoEntradaR_FF,TiempoEntradaL_FF, ...
             TiempoFinal_FF,1000);

