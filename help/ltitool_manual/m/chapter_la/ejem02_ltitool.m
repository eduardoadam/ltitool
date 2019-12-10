
%
% Determinación de la respuesa al impulso de un sistema a lazo abierto.
%

pkg load control

clear all, clc

% Funcion de transferencia
s=tf('s');
Gs=(s+1)/(s^2+0.5*s+1);

% Respuesta al impulso
step(Gs)
%print -dpng stepGs_ltitool
