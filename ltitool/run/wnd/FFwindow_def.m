%
% Set the graphics toolkit and force read this file as script file (not a function file).
%
graphics_toolkit qt;
%


%
%
% Begin callbacks definitions 
%

function btn_simulFF_doIt(source, callbackdata, FFwindow)

%
% Step response of FF control system
%

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadFFdata'])
load([_basePath filesep() 'data' filesep() 'loadFFsim'])

% ----------------------------------
% Step response
% ----------------------------------
axes(dlg.image_FFsimulation);
FFstepresponse(Gp,Gl,Gv,Gc,Gm,Gt,Gtl,Cff,tiempo_muerto,amplitud_sp,amplitud_l,T_sp,T_l,TFinal,haChCons,haChCarga,1000);
hold off

% Additional informacion
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);
set(dlg.label_Estabilidad, "String", num2str(estabilidad));
set(dlg.valor_final, "String", num2str(yinf));
set(dlg.tiempo_estab_GH, "String", num2str(Test));

%
refresh();

end

function btn_closeFF_doIt(source, callbackdata, FFwindow)


 % Close window
  close(dlg.FFwindow);

end

function btn_FFFBstepresponse_doIt(source, callbackdata, FFwindow)


%
% Plot step response of FFFB system
%

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadFFdata'])
load([_basePath filesep() 'data' filesep() 'loadFFsim'])

% ----------------------------------
% Step response
% ----------------------------------
figure
FFstepresponse(Gp,Gl,Gv,Gc,Gm,Gt,Gtl,Cff,tiempo_muerto,amplitud_sp,amplitud_l,T_sp,T_l,TFinal,haChCons,haChCarga,1000);
hold off

% Additional Information for main window
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);
set(dlg.label_Estabilidad, "String", num2str(estabilidad));
set(dlg.valor_final, "String", num2str(yinf));
set(dlg.tiempo_estab_GH, "String", num2str(Test));

%
refresh();

end

function btn_FFanalysis_doIt(source, callbackdata, FFwindow)

FFanalysis();

end

function btn_loadFFdata_doIt(source, callbackdata, FFwindow)

FFloaddata();

end

function btn_FFsimparameters_doIt(source, callbackdata, FFwindow)

FFsimparameters();

end

function btn_FFaditionalinfo_doIt(source, callbackdata, FFwindow)


%
% Additional information for FFFB main window
% 

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadFFdata'])
load([_basePath filesep() 'data' filesep() 'loadFFsim'])

% Additional information for FFFB main window
% ------------------------------------------------------------------------
% Additional information about dynamic response
[estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);

% Additional information about frequency response
nGH=GH.num{1,1}; dGH=GH.den{1,1};
[ceros_la, polos_la,KGH]=xzpkdata(nGH,dGH);
nGH=nGH/KGH;
GH_K = tf(nGH,dGH); % 
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
% Put the additional information on FFFB main window
% ------------------------------------------------------------------------
%  Dynamic response
set(dlg.label_Estabilidad, "String", num2str(estabilidad));
set(dlg.valor_final, "String", num2str(yinf));
set(dlg.tiempo_estab_GH, "String", num2str(Test));
% Frequency response
set(dlg.Kasterisco, "String", num2str(Kast))
set(dlg.Kasterisco_ultimo, "String", num2str(Kast_ult))
set(dlg.wu, "String", num2str(wultimo))
set(dlg.gain_margin, "String", num2str(GM))
set(dlg.w_cg, "String", num2str(wcg))
set(dlg.phase_margin, "String", num2str(PM))

end

function btn_setdefaultFF_doIt(source, callbackdata, FFwindow)


%
% Rewrite 2 files with predefined default data 
%
%

% global variable
global _basePath;

% Default data 
% ---------------------------------------------------------------------------------
% Complex variable "s"
s=tf('s'); 
% plant, ME y FCE
Gp=(s+1)/(s^2+s+1); Gl=Gp; tiempo_muerto=0.0;
Gm=1/(0.1*s+1); Gtl=Gm; Gt=Gm;
Gv=1/(0.1*s+1);
% controller
Kr=1.0; TI=1.0; TD=0.0;
Gc=Kr*(1+1/(TI*s));
% feedforward controller
Cff=1/(0.1*s+1);
% Compensator
Gcomp=(s+1)/(0.1*s+1);
% G(s)H(s)
GH=Gp*Gv*Gc*Gm;
% simulation parameters
amplitud_sp=1; amplitud_l=1;
T_sp=1; T_l=10; TFinal=20;

% simulation flags
haChCons=1;
haChCarga=1;

% Save data
save([_basePath filesep() 'data' filesep() 'loadFFdata'],'Gp','Gl','Gv','Gc','Gm','Gt', 'Gtl', 'GH', 'tiempo_muerto', ...
                                                         'Cff', 'Gcomp', 'Kr', 'TI', 'TD')
save([_basePath filesep() 'data' filesep() 'loadFFsim'],'T_sp','T_l','TFinal','amplitud_sp','amplitud_l','haChCons', 'haChCarga')      

end

function btn_clear_FFsimfigure_doIt(source, callbackdata, FFwindow)

   %
   % Clear simulation window
   %


   % limpio la ventana con las simulaciones
   cla(dlg.image_FFsimulation)
   % 
   refresh();

end

function btn_saveFF_doIt(source, callbackdata, FFwindow)


%
% Save variables, transfer function, and so on
%

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadFFdata'])
load([_basePath filesep() 'data' filesep() 'loadFFsim'])


[fname, fpath, fltidx] = uiputfile ({'.txt','Archivos de texto';'.m', 'Scripts de octave';'.', 'Todos los archivos'}, 'Abrir archivo. Elija un nombre de archivo para abrir');
if(fname)
  % Additional information of  dynamic response
  nptos=1000;
  [tsim,ysim,ysim_sinFF]=simulstepFFFB(Gp,Gl,Gv,Gc,Gm,Gt,Gtl,Cff,tiempo_muerto, ...
                                       amplitud_sp,amplitud_l,T_sp,T_l,TFinal,haChCons,haChCarga,nptos);

  % Additional information of frequency response
  nGH=GH.num{1,1}; dGH=GH.den{1,1};
  [zeros_GH, poles_GH,KGH]=xzpkdata(nGH,dGH);
  Kasteric=KGH;
  %GH=tf(nGH,dGH);
  Gcl=GH/(1+GH);
  [zeros_cl, poles_cl,Kcl]=xzpkdata(Gcl.num{1,1},Gcl.den{1,1});

  [mGH,pGH,w]=bode(GH);
  % fix the phase wrap arownd
  phaud=pGH;
  phw=unwrap(phaud*pi/180);
  phaud=phw*180/pi;
  % delayed plant phase,
  %phad=phaud + ((-w.*delay)*180/pi)';
  delay=0;
 [Kast,Kast_ult,wult,GM,wcg,PM]=additionalinfofreq(GH,Kasteric,mGH,phaud,delay,w);


  % Additional information of stability
  % ------------------------------------------------------------------------
  [estabilidad,yinf,Test]=additionalinfoFB(GH.num{1,1},GH.den{1,1},amplitud_sp,TFinal,1000);

  % Save results
  % --------------------------
  save([fpath fname], 'Gp','Gl','Gv','Gc','Gm','Gt', 'Gtl', 'GH', 'tiempo_muerto', ...
       'Kr', 'TI', 'TD', 'Cff', 'Gcomp',
       'Kast','Kast_ult','wult','GM','wcg','PM', ...
       'zeros_GH', 'poles_GH','KGH','zeros_cl', 'poles_cl', ...
       'estabilidad','yinf','Test', 'T_sp','T_l','TFinal','tsim','ysim', 'ysim_sinFF', ...
       'amplitud_sp','amplitud_l');


else
  disp('Cancelado');
endif;

end

 
%
% Dialog creation windows function 
%
function ret = show_FFwindow()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 1220)/2;
  _yPos = 73;
   FFwindow = figure ( ... 
	'Color', [0.949 0.949 0.949], ...
	'Position', [_xPos _yPos 1220 665], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  Image_FFFB = axes( ...
	'Units', 'pixels', ... 
	'parent',FFwindow, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [12 358 576 299]);
  btn_simulFF = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [10 326 110 25], ... 
	'String', 'Simulate', ... 
	'TooltipString', '');
  btn_helpFF = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [835 8 90 22], ... 
	'String', 'Help', ... 
	'TooltipString', '');
  btn_closeFF = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [1092 8 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  Label_10 = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [620 622 252 23], ... 
	'String', 'Analysis and Simulation of', ... 
	'TooltipString', '');
  image_FFsimulation = axes( ...
	'Units', 'pixels', ... 
	'parent',FFwindow, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [156 48 768 298]);
  estabilidad = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 348 49 17], ... 
	'String', 'Sistem:', ... 
	'TooltipString', '');
  Test = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 285 113 17], ... 
	'String', 'Settling Time. =  ', ... 
	'TooltipString', '');
  tiempo_estab_GH = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 283 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  y_inf = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 313 48 17], ... 
	'String', 'y(inf) =', ... 
	'TooltipString', '');
  valor_final = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 313 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_15 = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 8, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 266 72 14], ... 
	'String', '(Approximate)', ... 
	'TooltipString', '');
  btn_FFFBstepresponse = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [925 328 25 22], ... 
	'String', '+', ... 
	'TooltipString', '');
  label_Estabilidad = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1061 343 126 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_19 = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 235 41 17], ... 
	'String', '[K*] = ', ... 
	'TooltipString', '');
  Kasterisco = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 233 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Kastultimo = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 198 50 17], ... 
	'String', '[K*u] = ', ... 
	'TooltipString', '');
  Kasterisco_ultimo = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 198 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_omega_u = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Standard Symbols L', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 163 60 27], ... 
	'String', 'w       =', ... 
	'TooltipString', '');
  wu = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 163 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_sub_u = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [980 163 30 17], ... 
	'String', '-180', ... 
	'TooltipString', '');
  Label_GM = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 128 39 17], ... 
	'String', 'GM = ', ... 
	'TooltipString', '');
  gain_margin = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 128 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_omega_180 = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Standard Symbols L', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 93 45 27], ... 
	'String', 'w   = ', ... 
	'TooltipString', '');
  Label_sub_cg = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [980 83 16 17], ... 
	'String', 'gc', ... 
	'TooltipString', '');
  w_cg = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 93 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_PM = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 53 41 17], ... 
	'String', 'PM  = ', ... 
	'TooltipString', '');
  phase_margin = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1097 53 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  btn_FFanalysis = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [615 435 255 50], ... 
	'String', 'Analysis Tools', ... 
	'TooltipString', '');
  btn_loadFFdata = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [615 492 254 46], ... 
	'String', 'Load Data', ... 
	'TooltipString', '');
  btn_FFsimparameters = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [615 376 253 49], ... 
	'String', 'Simulation Parameters', ... 
	'TooltipString', '');
  btn_FFaditionalinfo = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [960 383 183 22], ... 
	'String', 'Additional Information ', ... 
	'TooltipString', '');
  btn_setdefaultFF = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [920 516 215 22], ... 
	'String', 'Reload Default Values', ... 
	'TooltipString', '');
  btn_clear_FFsimfigure = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [10 8 219 22], ... 
	'String', 'Clear Simulation Window', ... 
	'TooltipString', '');
  Label_14 = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [620 587 382 23], ... 
	'String', 'Feedforward-Feedback Control Systems', ... 
	'TooltipString', '');
  btn_saveFF = uicontrol( ...
	'parent',FFwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [960 8 90 22], ... 
	'String', 'Save', ... 
	'TooltipString', '');

  FFwindow = struct( ...
      'figure', FFwindow, ...
      'Image_FFFB', Image_FFFB, ...
      'btn_simulFF', btn_simulFF, ...
      'btn_helpFF', btn_helpFF, ...
      'btn_closeFF', btn_closeFF, ...
      'Label_10', Label_10, ...
      'image_FFsimulation', image_FFsimulation, ...
      'estabilidad', estabilidad, ...
      'Test', Test, ...
      'tiempo_estab_GH', tiempo_estab_GH, ...
      'y_inf', y_inf, ...
      'valor_final', valor_final, ...
      'Label_15', Label_15, ...
      'btn_FFFBstepresponse', btn_FFFBstepresponse, ...
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
      'btn_FFanalysis', btn_FFanalysis, ...
      'btn_loadFFdata', btn_loadFFdata, ...
      'btn_FFsimparameters', btn_FFsimparameters, ...
      'btn_FFaditionalinfo', btn_FFaditionalinfo, ...
      'btn_setdefaultFF', btn_setdefaultFF, ...
      'btn_clear_FFsimfigure', btn_clear_FFsimfigure, ...
      'Label_14', Label_14, ...
      'btn_saveFF', btn_saveFF);


  set (btn_simulFF, 'callback', {@btn_simulFF_doIt, FFwindow});
  set (btn_closeFF, 'callback', {@btn_closeFF_doIt, FFwindow});
  set (btn_FFFBstepresponse, 'callback', {@btn_FFFBstepresponse_doIt, FFwindow});
  set (btn_FFanalysis, 'callback', {@btn_FFanalysis_doIt, FFwindow});
  set (btn_loadFFdata, 'callback', {@btn_loadFFdata_doIt, FFwindow});
  set (btn_FFsimparameters, 'callback', {@btn_FFsimparameters_doIt, FFwindow});
  set (btn_FFaditionalinfo, 'callback', {@btn_FFaditionalinfo_doIt, FFwindow});
  set (btn_setdefaultFF, 'callback', {@btn_setdefaultFF_doIt, FFwindow});
  set (btn_clear_FFsimfigure, 'callback', {@btn_clear_FFsimfigure_doIt, FFwindow});
  set (btn_saveFF, 'callback', {@btn_saveFF_doIt, FFwindow});
  dlg = struct(FFwindow);


%
% Feedforward window
%

% Load packages
%pkg load control;
%pkg load linear-algebra;
%pkg load odepkg;
%pkg load optim;
%pkg load signal;
%pkg load struct;

% global variable
global _basePath;

% Presentation image
axes(FFwindow.Image_FFFB);
imshow([_basePath filesep() 'img' filesep() 'FFFBcontrol.png']);
refresh();

%------------------------------------------------------------------------
% Load data
load([_basePath filesep() 'data' filesep() 'loadFFdata'])
load([_basePath filesep() 'data' filesep() 'loadFFsim'])
%------------------------------------------------------------------------

% Clear the command window
clc

%refresh();



















































  ret = FFwindow;
end

