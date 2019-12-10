%
% Programa auxiliar para pasarle datos de Kr, Ti,Td a xoptiPID
%
%

clear all, clf

% Global Variables
global Gp t dt mu_1 mu_2 mu_3


%Planta
s=tf('s');
Gp=(10)/(s^3 + 6*s^2 + 11*s + 6)
%Gp=(10)/(s^3 + 6*s^2  + 6)

%Valores Iniciales:
Kr=1; Ti=1; Td=0.1;  %Parametros iniciales para el calculo
t_sim=10;         %Tiempo de simulacion
dt=0.1;           %Periodo de muestreo
% Relative Weighting Factors: PLAY AROUND WITH THESE!
mu_1 = 1;               % Minimize ITAE Criterion
mu_2 = 10;              % Minimize Max Overshoot
mu_3 = 20;              % Minimize Sensitivity Ms

%Llama a xoptiPID para calcular el controlador optimo
[Kr_opt,Ti_opt, Td_opt]=xoptiPID(Kr,Ti,Td,Gp,t_sim,dt,mu_1,mu_2,mu_3)


