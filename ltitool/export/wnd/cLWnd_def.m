## -*- texinfo -*-
## @deftypefn  {} {} dummy()
##
## This is a dummy function documentation. This file have a lot functions
## and each one have a little documentation. This text is to avoid a warning when
## install this file as part of package.
## @end deftypefn
##
## Set the graphics toolkit and force read this file as script file (not a function file).
##
graphics_toolkit qt;
##


##
##
## Begin callbacks definitions 
##

## @deftypefn  {} {} btn_simulate_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_simulate control.
##
## @end deftypefn
function btn_simulate_doIt(source, callbackdata, cLWnd)

%
% Simulate step response of the closed loop system
%

% global variable
global _ltitoolBasePath;

%  Load data
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'])
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLsim'])


% ----------------------------------
% Step response
% ----------------------------------
axes(cLWnd.simulation_image);
step_resp_CL(Gp,Gl,Gv,Gc,Gm,Gt,tiempo_muerto,amplitud_sp,amplitud_l,T_sp,T_l,TFinal,haChCons,haChCarga,1000);
hold off


% Additional information for main window
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);
set(cLWnd.label_Estabilidad, "String", num2str(estabilidad));
set(cLWnd.valor_final, "String", num2str(yinf));
set(cLWnd.tiempo_estab_GH, "String", num2str(Test));

%
refresh();

end

## @deftypefn  {} {} btn_CLhelp_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLhelp control.
##
## @end deftypefn
function btn_CLhelp_doIt(source, callbackdata, cLWnd)


%
% Run presentation to help  as html file.
%

% global variable
global _ltitoolBasePath;

% Load html file
url = ["file:" _ltitoolBasePath filesep() "ltitool_manual" filesep() "node14.html"];

  if(isunix())
    system(["xdg-open " url]);
  elseif (ispc())
    system(["start " url]);
  else
    disp(["I don't know how to open " url " in your os. Sorry!"]);
  endif;

end

## @deftypefn  {} {} btn_CLclose_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLclose control.
##
## @end deftypefn
function btn_CLclose_doIt(source, callbackdata, cLWnd)

  % Close main window
  %clc
  close(cLWnd.figure);

end

## @deftypefn  {} {} btn_stepresponse_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_stepresponse control.
##
## @end deftypefn
function btn_stepresponse_doIt(source, callbackdata, cLWnd)


%
% Plot dynamic response of the closed loop system
%

% global variable
global _ltitoolBasePath;

%  Load data
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'])
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLsim'])


% ----------------------------------
% Step response
% ----------------------------------
figure
step_resp_CL(Gp,Gl,Gv,Gc,Gm,Gt,tiempo_muerto,amplitud_sp,amplitud_l,T_sp,T_l,TFinal,haChCons,haChCarga,1000);
hold off

% Additional information for the main window
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);
set(cLWnd.label_Estabilidad, "String", num2str(estabilidad));
set(cLWnd.valor_final, "String", num2str(yinf));
set(cLWnd.tiempo_estab_GH, "String", num2str(Test));

%
refresh();

end

## @deftypefn  {} {} btn_CLanalysis_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLanalysis control.
##
## @end deftypefn
function btn_CLanalysis_doIt(source, callbackdata, cLWnd)


% Open a window to do analysis based on linear control theory
cLAnalysisWnd();

end

## @deftypefn  {} {} btn_CLloaddata_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLloaddata control.
##
## @end deftypefn
function btn_CLloaddata_doIt(source, callbackdata, cLWnd)


% Open a window to load predefined data
cLLoadDataWnd();

end

## @deftypefn  {} {} btn_CLsimparameters_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLsimparameters control.
##
## @end deftypefn
function btn_CLsimparameters_doIt(source, callbackdata, cLWnd)

cLSimParamWnd();

end

## @deftypefn  {} {} btn_CLadditionalinfo_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLadditionalinfo control.
##
## @end deftypefn
function btn_CLadditionalinfo_doIt(source, callbackdata, cLWnd)


% global variable
global _ltitoolBasePath;

%  Load data
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'])
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLsim'])


% Additional information for main window
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);

% Additional information of frequency response
nGH=GH.num{1,1}; dGH=GH.den{1,1};
[ceros_la, polos_la,KGH]=xzpkdata(nGH,dGH);
nGH=nGH/KGH;
GH_K = tf(nGH,dGH); % adimensional GH
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
[Kast,Kast_ult,wultimo,GM,wcg,PM]=additionalinfofreq(GH,Kasteric,mGH,phaud,delay,w);


% ------------------------------------------------------------------------
% Additional information for main window
% ------------------------------------------------------------------------
% Dynamic response
set(cLWnd.label_Estabilidad, "String", num2str(estabilidad));
set(cLWnd.valor_final, "String", num2str(yinf));
set(cLWnd.tiempo_estab_GH, "String", num2str(Test));
% Frecuency response
set(cLWnd.Kasterisco, "String", num2str(Kast))
set(cLWnd.Kasterisco_ultimo, "String", num2str(Kast_ult))
set(cLWnd.wu, "String", num2str(wultimo))
set(cLWnd.gain_margin, "String", num2str(GM))
set(cLWnd.w_cg, "String", num2str(wcg))
set(cLWnd.phase_margin, "String", num2str(PM))

end

## @deftypefn  {} {} btn_setdefault_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_setdefault control.
##
## @end deftypefn
function btn_setdefault_doIt(source, callbackdata, cLWnd)


%
% Reload default values for closed loop system
%
%

% global variable
global _ltitoolBasePath;

% Complex variable "s"
s=tf('s'); 
% Plant, ME and FCE
Gp=(s+1)/(s^2+s+1); Gl=Gp; tiempo_muerto=0.0;
Gm=1/(0.1*s+1); Gt=Gm;
Gv=1/(0.2*s+1);
% controller
Kr=1.0; TI=1.0; TD=0.0;
Gc=Kr*(1+1/(TI*s));
% Compensator
Gcomp=(s+1)/(0.1*s+1);
% G(s)H(s)
GH=Gp*Gv*Gc*Gm;
% Simulation paramenters
amplitud_sp=1; amplitud_l=1;
T_sp=1; T_l=10; TFinal=20;

% Simulation window flags
haChCons=1;
haChCarga=1;

% Save data
save([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'],'Gp','Gl','Gm','Gt','Gv','Gc','Gcomp','tiempo_muerto','GH','Kr','TI','TD')
save([_ltitoolBasePath filesep() 'data' filesep() 'loadCLsim'],'T_sp','T_l','TFinal','amplitud_sp','amplitud_l','haChCons','haChCarga')

end

## @deftypefn  {} {} btn_clear_CLsimulationfig_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_clear_CLsimulationfig control.
##
## @end deftypefn
function btn_clear_CLsimulationfig_doIt(source, callbackdata, cLWnd)

   %
   % Clear simulation window
   %
   cla(cLWnd.simulation_image)
   % 
   refresh();

end

## @deftypefn  {} {} btn_CLsave_doIt (@var{source}, @var{callbackdata}, @var{cLWnd})
##
## Define a callback for default action of btn_CLsave control.
##
## @end deftypefn
function btn_CLsave_doIt(source, callbackdata, cLWnd)


% Save data of:
% 	Transfer functions,
% 	Dynamic response for setpoint and load step change
% 	Set-Point step amplitud (AmplitudSP)
% 	Simulation time  (tFinal)
% 	Settling value (yinf)
% 	Settling time (Test)


% global variable
global _ltitoolBasePath;

%  Load data
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'])
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLsim'])


[fname, fpath, fltidx] = uiputfile ({'.txt','Archivos de texto';'.m', 'Scripts de octave';'.', 'Todos los archivos'}, 'Abrir archivo. Elija un nombre de archivo para abrir');
if(fname)
  % Complex variable "s"
  s = tf('s');

  % Simulations
  % --------------------
  % Dynamic response for setpoint and load step change
  [ysim,tsim]=simulstepFB(Gp,Gl,Gv,Gc,Gm,Gt,tiempo_muerto,amplitud_sp,amplitud_l,T_sp,T_l,TFinal,haChCons,haChCarga,1000);
  
  % Additional information
  % ------------------------------------------------------------------------
  % Additional information of dynamic response
  [estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);

  % Zeros-poles location
  %GH
  nGH=GH.num{1,1}; dGH=GH.den{1,1};
  [zeros_GH, polos_GH,KGH]=xzpkdata(nGH,dGH);
  % Closed loop transfer function
  Gcl = minreal(GH/(1+GH));
  [zeros_cl, polos_cl,Kcl]=xzpkdata(Gcl.num{1,1},Gcl.den{1,1});

  % Additional Information of frequency response
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
  [Kast,Kast_ult,wultimo,GM,wcg,PM]=additionalinfofreq(GH,Kasteric,mGH,phaud,delay,w);


  % Save results
  % --------------------------
  save([fpath fname], 'Gp','Gl','Gv','Gc','Gm','Gt','GH','tiempo_muerto', ...
       'zeros_GH', 'polos_GH','KGH','zeros_cl', 'polos_cl','Kcl', ...
       'estabilidad','yinf','Test', 'T_sp','T_l','TFinal','tsim','ysim', ...
       'amplitud_sp','amplitud_l','Kast','Kast_ult','wultimo','GM','wcg','PM');
else
  disp('Cancelado');
endif;

end

 
## @deftypefn  {} {@var{ret} = } show_cLWnd()
##
## Create windows controls over a figure, link controls with callbacks and return 
## a window struct representation.
##
## @end deftypefn
function ret = show_cLWnd()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 1220)/2;
  _yPos = 98;
   cLWnd = figure ( ... 
	'Color', [0.949 0.949 0.949], ...
	'Position', [_xPos _yPos 1220 640], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  Image_CL = axes( ...
	'Units', 'pixels', ... 
	'parent',cLWnd, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [19 391 528 200]);
  btn_simulate = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [15 356 110 25], ... 
	'String', 'Simulate', ... 
	'TooltipString', '');
  btn_CLhelp = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [830 13 90 22], ... 
	'String', 'Help', ... 
	'TooltipString', '');
  btn_CLclose = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [1087 13 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  Label_10 = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [309 592 615 33], ... 
	'String', 'Analysis and Simulation of Closed Loop Systems', ... 
	'TooltipString', '');
  simulation_image = axes( ...
	'Units', 'pixels', ... 
	'parent',cLWnd, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [156 67 768 314]);
  estabilidad = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 368 79 17], ... 
	'String', 'System:', ... 
	'TooltipString', '');
  Test = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 305 113 17], ... 
	'String', 'Settling Time. =  ', ... 
	'TooltipString', '');
  tiempo_estab_GH = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 303 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  y_inf = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 333 80 17], ... 
	'String', 'y(inf) =', ... 
	'TooltipString', '');
  valor_final = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 333 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_15 = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 7, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 294 75 11], ... 
	'String', '(Approximate)', ... 
	'TooltipString', '');
  btn_stepresponse = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [925 363 25 22], ... 
	'String', '+', ... 
	'TooltipString', '');
  label_Estabilidad = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1061 363 126 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_19 = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 255 61 17], ... 
	'String', '[K*] = ', ... 
	'TooltipString', '');
  Kasterisco = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1092 253 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Kastultimo = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 218 68 17], ... 
	'String', '[K*u] = ', ... 
	'TooltipString', '');
  Kasterisco_ultimo = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1095 218 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_omega_u = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Symbol', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 183 80 27], ... 
	'String', 'w       =', ... 
	'TooltipString', '');
  wu = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1095 183 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_sub_u = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 9, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [980 173 35 17], ... 
	'String', '-180', ... 
	'TooltipString', '');
  Label_GM = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 148 77 17], ... 
	'String', 'GM = ', ... 
	'TooltipString', '');
  gain_margin = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1095 148 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_omega_180 = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Symbol', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 113 72 27], ... 
	'String', 'w   = ', ... 
	'TooltipString', '');
  Label_sub_cg = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 9, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [980 106 24 14], ... 
	'String', 'gc', ... 
	'TooltipString', '');
  w_cg = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1095 113 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_PM = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 73 102 17], ... 
	'String', 'PM (grad.)  = ', ... 
	'TooltipString', '');
  phase_margin = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1095 73 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  btn_CLanalysis = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [560 470 255 50], ... 
	'String', 'Analysis Tools', ... 
	'TooltipString', '');
  btn_CLloaddata = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [560 529 254 46], ... 
	'String', 'Load Data', ... 
	'TooltipString', '');
  btn_CLsimparameters = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [560 411 253 49], ... 
	'String', 'Simulation Parameters', ... 
	'TooltipString', '');
  btn_CLadditionalinfo = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [960 408 183 22], ... 
	'String', 'Additional Information', ... 
	'TooltipString', '');
  btn_setdefault = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [825 553 218 22], ... 
	'String', 'Reload Default Values', ... 
	'TooltipString', '');
  btn_clear_CLsimulationfig = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [20 13 234 22], ... 
	'String', 'Clear SImulation Window', ... 
	'TooltipString', '');
  btn_CLsave = uicontrol( ...
	'parent',cLWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [960 13 90 22], ... 
	'String', 'Save', ... 
	'TooltipString', '');

  cLWnd = struct( ...
      'figure', cLWnd, ...
      'Image_CL', Image_CL, ...
      'btn_simulate', btn_simulate, ...
      'btn_CLhelp', btn_CLhelp, ...
      'btn_CLclose', btn_CLclose, ...
      'Label_10', Label_10, ...
      'simulation_image', simulation_image, ...
      'estabilidad', estabilidad, ...
      'Test', Test, ...
      'tiempo_estab_GH', tiempo_estab_GH, ...
      'y_inf', y_inf, ...
      'valor_final', valor_final, ...
      'Label_15', Label_15, ...
      'btn_stepresponse', btn_stepresponse, ...
      'label_Estabilidad', label_Estabilidad, ...
      'Label_19', Label_19, ...
      'Kasterisco', Kasterisco, ...
      'Kastultimo', Kastultimo, ...
      'Kasterisco_ultimo', Kasterisco_ultimo, ...
      'Label_omega_u', Label_omega_u, ...
      'wu', wu, ...
      'Label_sub_u', Label_sub_u, ...
      'Label_GM', Label_GM, ...
      'gain_margin', gain_margin, ...
      'Label_omega_180', Label_omega_180, ...
      'Label_sub_cg', Label_sub_cg, ...
      'w_cg', w_cg, ...
      'Label_PM', Label_PM, ...
      'phase_margin', phase_margin, ...
      'btn_CLanalysis', btn_CLanalysis, ...
      'btn_CLloaddata', btn_CLloaddata, ...
      'btn_CLsimparameters', btn_CLsimparameters, ...
      'btn_CLadditionalinfo', btn_CLadditionalinfo, ...
      'btn_setdefault', btn_setdefault, ...
      'btn_clear_CLsimulationfig', btn_clear_CLsimulationfig, ...
      'btn_CLsave', btn_CLsave);


  set (btn_simulate, 'callback', {@btn_simulate_doIt, cLWnd});
  set (btn_CLhelp, 'callback', {@btn_CLhelp_doIt, cLWnd});
  set (btn_CLclose, 'callback', {@btn_CLclose_doIt, cLWnd});
  set (btn_stepresponse, 'callback', {@btn_stepresponse_doIt, cLWnd});
  set (btn_CLanalysis, 'callback', {@btn_CLanalysis_doIt, cLWnd});
  set (btn_CLloaddata, 'callback', {@btn_CLloaddata_doIt, cLWnd});
  set (btn_CLsimparameters, 'callback', {@btn_CLsimparameters_doIt, cLWnd});
  set (btn_CLadditionalinfo, 'callback', {@btn_CLadditionalinfo_doIt, cLWnd});
  set (btn_setdefault, 'callback', {@btn_setdefault_doIt, cLWnd});
  set (btn_clear_CLsimulationfig, 'callback', {@btn_clear_CLsimulationfig_doIt, cLWnd});
  set (btn_CLsave, 'callback', {@btn_CLsave_doIt, cLWnd});
  dlg = struct(cLWnd);




% global variable
global _ltitoolBasePath;

%
axes(cLWnd.Image_CL);
imshow([_ltitoolBasePath filesep() 'img' filesep() 'closedloop.png']);
refresh();

%------------------------------------------------------------------------
% Load data defined as default
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'])
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLsim'])
%------------------------------------------------------------------------------------------------

% Clear el command Window
clc



































































  ret = cLWnd;
end

