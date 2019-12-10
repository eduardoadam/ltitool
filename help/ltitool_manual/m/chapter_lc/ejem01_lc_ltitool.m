
%
% Determinación de la respuesa al impulso de un sistema a lazo abierto.
%

pkg load control
pkg load signal

clear all, clc

% Funcion de transferencia
Kast=0.5;
s=tf('s');
GH=Kast/(s*(s^2+s+1));

% Polos y ceros de la cadena de lazo abierto G(s)H(s)
polosGH=roots(GH.den{1,1})
% Polos y ceros de la cadena de lazo cerrado
Glc=feedback(GH,1)
polosGH=roots(Glc.den{1,1})

% Respuesta al escalon
step(Glc)
%print -dsvg fig01_step_lc.psvg

