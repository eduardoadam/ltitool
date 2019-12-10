
%
% Archivo auxiliar para simular ejemplos
%
%

% cargo paquete control
pkg load control
pkg load signal

% limpio la memoria y el command window
clear all, clc

% -----------------------------------------
% Cargo Datos Necesarios
% -----------------------------------------
% G(s)H(s):
s=tf('s');
Gs=2.0/((5*s+1)*(1*s^2+1*s+1)); delay=0;
Hs=(5*s+1)/(5*s);
Kr=1.25;
GH=minreal(Kr*Gs*Hs);

% Datos para simulacion
AmplitudSP=1;
tFinal=30;

% -----------------------------------------
% Herramientas de Analisis
% -----------------------------------------
% Lugar de Raíces
figure(1), clf(figure(1),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=grafico_lr_GH(GH.num{1,1},GH.den{1,1},Kr,1000);

% Diagramas de Bode
figure(2), clf(figure(2),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=grafico_bode_GH(GH.num{1,1},GH.den{1,1},delay,Kr);

% Diagrama de Nyquist
figure(3),  clf(figure(3),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=grafico_nyquist_GH(GH.num{1,1},GH.den{1,1},delay,Kr);

% -----------------------------------------
% Herramientas de Simulacion
% -----------------------------------------
% Respuesta al escalon
figure(4),  clf(figure(4),"reset");
step_resp_GH(GH.num{1,1},GH.den{1,1},AmplitudSP,tFinal,1000);

% Respuesta al impulso
figure(5), clf(figure(5),"reset");
impulse_resp_GH(GH.num{1,1},GH.den{1,1},tFinal,1000);

% Informacion adicional para la ventana principal
[estabilidad,yinf,Test]=info_adicional_FB(GH.num{1,1},GH.den{1,1},AmplitudSP,tFinal,1000);
