
%
% Archivo auxiliar para simular ejemplos con ventana Glc
%
%

% limpio la memoria y el command window
clear all, clc

pkg load control
pkg load signal

% ------------------------------------------------------------------------
% Defino valores por defecto para las variables
% ------------------------------------------------------------------------
% Defino variable "s"
s=tf('s'); 
% planta, EM y ECF
Gp=(s+1)/(s^2+s+1); Gl=Gp; tiempo_muerto=0.0;
Gm=1/(0.1*s+1); Gt=Gm;
Gv=1/(0.2*s+1);
% controlador
Kr=2; TI=1.0; TD=0.0;
Gc=Kr*(1+1/(TI*s));
% Compensador
Gcomp=(s+1)/(0.1*s+1);
% producto G(s)H(s)
GH=Gp*Gv*Gc*Gm;
% fumncion de transferencia de lazo cerrado
Glc = minreal(GH/(1+GH));
% parametros de simulacion
amplitud_sp=1; amplitud_l=1;
T_sp=1; T_l=15; TFinal=35;

% ------------------------------------------------------------------------
% Simulacion
% ------------------------------------------------------------------------
figure(1), step_resp_CL(Gp,Gl,Gv,Gc,Gm,Gt,tiempo_muerto,amplitud_sp,amplitud_l,T_sp,T_l,TFinal,1000);

% ------------------------------------------------------------------------
% Analisis
% ------------------------------------------------------------------------
% Mapa polos y ceros GH
title_string='Mapa de Polos y Ceros G(s)H(s)';
legend_ceros_string='Ceros de G(s)H(s)';
legend_polos_string='Polos de G(s)H(s)';
figure(2), xpzmap(title_string,legend_ceros_string,legend_polos_string,GH.num{1,1},GH.den{1,1});

% Mapa polos y ceros Glc
title_string='Mapa de Polos y Ceros de Lazo Cerrado';
legend_ceros_string='Ceros de Glc(s)';
legend_polos_string='Polos de Glc(s)';
figure(3), xpzmap(title_string,legend_ceros_string,legend_polos_string,Glc.num{1,1},Glc.den{1,1});

% Grafico LR
figure(4), [Kast,Kast_ult,wultimo,GM,wcg,PM]=grafico_lr_GH(GH.num{1,1},GH.den{1,1},Kr,1000);

% Grafico Bode
delay=0;
figure(5), grafico_bode_GH(GH.num{1,1},GH.den{1,1},delay,Kr);

% Grafico Nyquist
figure(6), grafico_nyquist_GH(GH.num{1,1},GH.den{1,1},delay,Kr);

% ------------------------------------------------------------------------
% Informacion adicional para la ventana principal
% ------------------------------------------------------------------------
% Informacion adicional de la respuesta dinamica
[estabilidad,yinf,Test]=info_adicional_FB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000)

% Informacion adicional de la respuesta en frecuencia
nGH=GH.num{1,1}; dGH=GH.den{1,1};
[ceros_la, polos_la,KGH]=xzpkdata(nGH,dGH);
nGH=nGH/KGH;
GH_K = tf(nGH,dGH); % Queda GH adimensionalizado en KGH
Kasteric=KGH;
GH=tf(Kasteric*nGH,dGH);
[mGH,pGH,w]=bode(GH);
% fix the phase wrap arownd
phaud=pGH;
phw=unwrap(phaud*pi/180);
phaud=phw*180/pi;
% delayed plant phase,
%phad=phaud + ((-w.*delay)*180/pi)';
delay=0;
[Kast,Kast_ult,wultimo,GM,wcg,PM]=info_adicional_freq(GH,Kasteric,mGH,phaud,delay,w);



