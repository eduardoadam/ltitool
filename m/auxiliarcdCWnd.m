
%
% Archivo auxiliar para simular ejemplos
%
%

% package ltitool is loaded.
pkg load control
pkg load signal  
pkg load ltitool

% Clean memory and command window.
clear all, clc

% ------------------------------------------------------------------------
% Default values for the variables are defined
% ------------------------------------------------------------------------
% Complex variable "s"
s=tf('s'); 
% plant, ME and FCE
tiempo_muerto=0.0;
Gp1=(s+1)/(s^2+s+1); Gp2=(1)/(2*s+1); Gl1=Gp1; Gl2=Gp1;
Gm1=tf(1,1); Gt=Gm1; Gm2=Gm1;
Gv=1/(0.1*s+1);
% controllers
Krint=5; Krext=1;
Cint=tf(Krint,1);
Cext=Krext*(1+1/(1*s));
% G(s)H(s)
GHint=Gp2*Gv*Cint*Gm2; Gastint1=minreal(Gp2*Gv*Cint/(1+GHint));
GHext=minreal(Gp1*Gastint1*Cext*Gm1);
% Simulation parameters
amplitud_sp=1; amplitud_l1=1;  amplitud_l2=1;
T_sp=1; T_l1=10;  T_l2=20; TFinal=30;

% -----------------------------------------
% Analisys Tools
% -----------------------------------------
% Roots locus
figure(1), clf(figure(1),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=GHrlocusplot(GHint.num{1,1},GHint.den{1,1},Krint,1000);
figure(2), clf(figure(2),"reset");
[Kast,Kast_ult,wultimo,GM,wcg,PM]=GHrlocusplot(GHext.num{1,1},GHext.den{1,1},Krext,1000);

% Bode diagrams
%figure(3), clf(figure(2),"reset");
%[Kast,Kast_ult,wultimo,GM,wcg,PM]=GHbodeplot(GH.num{1,1},GH.den{1,1},delay,Kr);

% Nyquist diagram
%figure(4),  clf(figure(3),"reset");
%[Kast,Kast_ult,wultimo,GM,wcg,PM]=GHnyquistplot(GH.num{1,1},GH.den{1,1},delay,Kr);

% -----------------------------------------
% Simulation Tools
% -----------------------------------------
% Step response
%figure(5),  clf(figure(4),"reset");
%GHstepresponse(GH.num{1,1},GH.den{1,1},AmplitudSP,tFinal,1000);


% Additional information
[estabilidad,yinf,Test]=additionalinfoFB(GHext.num{1,1},GHext.den{1,1},amplitud_sp,TFinal,1000)

% --------------------------------------------------------------------------------
% LAZO INTERNO
% --------------------------------------------------------------------------------
% Additional information about frequency response
nGHint=GHint.num{1,1}; dGHint=GHint.den{1,1};
[ceros_la, polos_la,KGHint]=xzpkdata(nGHint,dGHint);
nGHint=nGHint/KGHint;
GH_Kint = tf(nGHint,dGHint); %
Kastericint=KGHint;
GHint=tf(Kastericint*nGHint,dGHint);
[mGHint,pGHint,wint]=bode(GHint);
% fix the phase wrap arownd
phaudint=pGHint;
phwint=unwrap(phaudint*pi/180);
phaudint=phwint*180/pi;
% delayed plant phase,
%phad=phaud + ((-w.*delay)*180/pi)';
delay=0;
[Kastint,Kast_ultint,wultimoint,GMint,wcgint,PMint]=additionalinfofreq(GHint,Kastericint,mGHint,phaudint,delay,wint)


% --------------------------------------------------------------------------------
% LAZO EXTERNO
% --------------------------------------------------------------------------------
% Additional information about frequency response
nGHext=GHext.num{1,1}; dGHext=GHext.den{1,1};
[ceros_la, polos_la,KGHext]=xzpkdata(nGHext,dGHext);
nGHext=nGHext/KGHext;
GH_Kext = tf(nGHext,dGHext); %
Kastericext=KGHext;
GHext=tf(Kastericext*nGHext,dGHext);
[mGHext,pGHext,wext]=bode(GHext);
% fix the phase wrap arownd
phaudext=pGHext;
phwext=unwrap(phaudext*pi/180);
phaudext=phwext*180/pi;
% delayed plant phase,
%phad=phaud + ((-w.*delay)*180/pi)';
delay=0;
[Kastext,Kast_ultext,wultimoext,GMext,wcgext,PMext]=additionalinfofreq(GHext,Kastericext,mGHext,phaudext,delay,wext)







