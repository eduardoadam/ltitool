
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

clear all

s=tf('s');

% Definiciones
Tstop=50;
Ts=Tstop/500;


%Planta:
%-------
Gpud=2.0/(10*s+1);
plantdelay=0.5;
%Controlador
%-----------
Kr=1; TI=1; TD=0.1;


%Calcula Cs
Cs=calculaCs(Kr,TI,TD);

%Calcula Cz
z=tf('z',Ts);
Cz=calculaCz(Cs,Kr,TI,TD,Ts);
%Calcula Cz por el metodo zoh
%kp=Kr;
%kp=Kr*(1-Ts/(2*TI));  %Para el metodo tustin
%ki=Kr*Ts/TI;
%kd=Kr*TD/Ts;
%Cz=minreal(kp+ki*(1/(1-z^(-1)))+kd*(1-z^(-1))) 

%Simulaciones:
%-------------
[tu,u,ty,y]=simula_con_delay(Gpud,plantdelay,Cs,Cz,Ts,Tstop);
[tusp,usp,tysp,ysp]=simulaSP(Gpud,plantdelay,Cz,Ts,Tstop);

%Graficos
%--------
%figure(1), plot(ty,y,'b'), title('Respuesta Dinamica Variable Controlada')
%figure(2), plot(tu,u,'b'), title('Respuesta Dinamica Variable Manipulada')
figure(1), plot(ty,y,'b',tysp,ysp,'r'), title('Respuesta Dinamica Variable Controlada')
figure(2), plot(tu,u,'b',tusp,usp,'r'), title('Respuesta Dinamica Variable Manipulada')

