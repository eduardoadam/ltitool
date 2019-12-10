
%
% Archivo auxiliar para simular ejemplos
%
%


pkg load control
pkg load linear-algebra
pkg load odepkg
pkg load optim
pkg load signal
pkg load symbolic


clear all, clc

s=tf('s');


%Planta:
Gp=1/(1*s^2+5*s+1);
%Gp=(s+2)/(1*s^2+5*s+1);
%Gp=1.4/((s^2+2.5*s+1)*(2*s+1))
delayGp=0.2*s;
option=1;
Tstop=25;

%[resp]=
step_resp_Gol(Gp.num{1,1},Gp.den{1,1},0.0,Tstop,1000);

[numGpaprox,denGpaprox,delayGpaprox]=aproximaGs(Gp,delayGp,1);
[numGpaprox_str, denGpaprox_str, delayGpaprox_str]=Gpaprox_str(numGpaprox, denGpaprox, delayGpaprox,1)
[plantdelay,tsal,ysal,Ts,Tstop]=preparatuning(Gp,delayGp);
[Kr TI TD]=pidtuning(Gp,plantdelay,tsal,ysal,Tstop,Ts,1);



