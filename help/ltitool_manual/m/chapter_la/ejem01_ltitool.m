
%
% Determinación de la respuesa al impulso de un sistema a lazo abierto.
%

pkg load control

clear all, clc

% System transfer function
s=tf('s');
Gs=(s+1)/(s^2+0.5*s+1);

% Poles and Zeros
polosGs=roots(Gs.den{1,1})



% Inpulse response
impulse(Gs)
%print -dpng impulseGs_ltitool
