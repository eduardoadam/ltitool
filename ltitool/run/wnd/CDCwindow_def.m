%
% Set the graphics toolkit and force read this file as script file (not a function file).
%
graphics_toolkit qt;
%


%
%
% Begin callbacks definitions 
%

function btn_simulCDC_doIt(source, callbackdata, CDCwindow)

%
% Plot step response of cascade control system
%

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadCDCdata'])
load([_basePath filesep() 'data' filesep() 'loadCDCsim'])

% ----------------------------------
% Step Response
% ----------------------------------
axes(dlg.simulationCCD_image);
delay=0;
step_resp_CCD(Gp1,Gp2,Gv,Cint,Cext,Gm1,Gm2,GHint,Gt,delay,Gl1,Gl2, ...
              amplitud_sp,amplitud_l1,amplitud_l2,T_sp,T_l1,T_l2,TFinal, ...
              haChCons,haChCarga1,haChCarga2,1000);
grid on;
hold off

% Informacion adicional para la ventana principal
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GHext.num{1,1},GHext.den{1,1},amplitud_sp,TFinal,1000);
set(dlg.label_Estabilidad, "String", num2str(estabilidad));
set(dlg.valor_final, "String", num2str(yinf));
set(dlg.tiempo_estab_GH, "String", num2str(Test));

% 
refresh();

end

function btn_closeCCD_doIt(source, callbackdata, CDCwindow)


% cierro ventana principal
close(dlg.CDCwindow);

end

function tiempo_estab_GH_doIt(source, callbackdata, CDCwindow)

end

function btn_CDCstepresponse_doIt(source, callbackdata, CDCwindow)


%
% Llama a graficar la respuesta al escalón del sistema realimentado
%


% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadCDCdata'])
load([_basePath filesep() 'data' filesep() 'loadCDCsim'])

% ----------------------------------
% Step Response
% ----------------------------------
figure
delay=0;
step_resp_CCD(Gp1,Gp2,Gv,Cint,Cext,Gm1,Gm2,GHint,Gt,delay,Gl1,Gl2, ...
              amplitud_sp,amplitud_l1,amplitud_l2,T_sp,T_l1,T_l2,TFinal, ...
              haChCons,haChCarga1,haChCarga2,1000);
hold off


% Informacion adicional para la ventana principal
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GHext.num{1,1},GHext.den{1,1},amplitud_sp,TFinal,1000);
set(dlg.label_Estabilidad, "String", num2str(estabilidad));
set(dlg.valor_final, "String", num2str(yinf));
set(dlg.tiempo_estab_GH, "String", num2str(Test));

% 
refresh();

end

function btn_CDCanalysis_doIt(source, callbackdata, CDCwindow)


% Open cascade control system analysis window
CDCanalysis();

end

function btn_runloadCDCdatawindow_doIt(source, callbackdata, CDCwindow)


% Open window to load data
CDCloaddata();

end

function btn_CDCsimparameters_doIt(source, callbackdata, CDCwindow)


% Open window to load simaltion parameters
CDCsimparameters();

end

function btn_CDCadditionalinfo_doIt(source, callbackdata, CDCwindow)


%
% Additional information for CDC main window
% 

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadCDCdata'])
load([_basePath filesep() 'data' filesep() 'loadCDCsim'])


% Additional information for the main window
% ------------------------------------------------------------------------
% Additional information of stability
[estabilidad,yinf,Test]=additionalinfoFB(GHext.num{1,1},GHext.den{1,1},amplitud_sp,TFinal,1000);

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
[Kastint,Kast_ultint,wultimoint,GMint,wcgint,PMint]=additionalinfofreq(GHint,Kastericint,mGHint,phaudint,delay,wint);


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
[Kastext,Kast_ultext,wultimoext,GMext,wcgext,PMext]=additionalinfofreq(GHext,Kastericext,mGHext,phaudext,delay,wext);



% ------------------------------------------------------------------------
% % Additional information for the main window
% ------------------------------------------------------------------------
% Dynamic response of cascade control system
set(dlg.label_Estabilidad, "String", num2str(estabilidad));
set(dlg.valor_final, "String", num2str(yinf));
set(dlg.tiempo_estab_GH, "String", num2str(Test));
% Frequency response LAZO INTERNO
set(dlg.Kasterisco_int, "String", num2str(Kastint))
set(dlg.Kasterisco_ultimo_int, "String", num2str(Kast_ultint))
set(dlg.wu_int, "String", num2str(wultimoint))
set(dlg.gain_margin_int, "String", num2str(GMint))
set(dlg.w_cg_int, "String", num2str(wcgint))
set(dlg.phase_margin_int, "String", num2str(PMint))
% Frequency response LAZO EXTERNO
set(dlg.Kasterisco_ext, "String", num2str(Kastext))
set(dlg.Kasterisco_ultimo_ext, "String", num2str(Kast_ultext))
set(dlg.wu_ext, "String", num2str(wultimoext))
set(dlg.gain_margin_ext, "String", num2str(GMext))
set(dlg.w_cg_ext, "String", num2str(wcgext))
set(dlg.phase_margin_ext, "String", num2str(PMext))

end

function btn_setdefaultCDC_doIt(source, callbackdata, CDCwindow)


%
% Rewrite 2 files with predefined default data 
%
%

% global variable
global _basePath;

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

% Simulation window parameters
haChCons=1;
haChCarga1=1;
haChCarga2=1;

% Save data
save([_basePath filesep() 'data' filesep() 'loadCDCdata'],'Gp1','Gp2','Gl1','Gl2','Gm1','Gm2','Gt','Gv', ...
                          'Cint','Cext','tiempo_muerto','Krint','Krext','GHint','GHext');

save([_basePath filesep() 'data' filesep() 'loadCDCsim'],'T_sp','T_l1','T_l2','TFinal', ...
                          'amplitud_sp','amplitud_l1','amplitud_l2', ...
                          'haChCons','haChCarga1','haChCarga2');        

end

function btn_clear_CDCsimfigure_doIt(source, callbackdata, CDCwindow)

%
% Clear simulation window
%

% limpio la ventana con las simulaciones
cla(dlg.simulationCCD_image)
% 
refresh();

end

function btn_saveCDC_doIt(source, callbackdata, CDCwindow)


%
% Save variables, transfer function, and so on
%

% global variable
global _basePath;

%  Load data
load([_basePath filesep() 'data' filesep() 'loadCDCdata'])
load([_basePath filesep() 'data' filesep() 'loadCDCsim'])


[fname, fpath, fltidx] = uiputfile ({'.txt','Archivos de texto';'.m', 'Scripts de octave';'.', 'Todos los archivos'}, 'Abrir archivo. Elija un nombre de archivo para abrir');
if(fname)


[tsim,ysim]=simulCCD(Gp1,Gp2,Gv,Cint,Cext,Gm1,Gm2,GHint,Gt,tiempo_muerto,Gl1,Gl2, ...
              amplitud_sp,amplitud_l1,amplitud_l2,T_sp,T_l1,T_l2,TFinal, ...
              haChCons,haChCarga1,haChCarga2,1000);

% ------------------------------------------------------------------------
% Informacion adicional
% ------------------------------------------------------------------------
[estabilidad,yinf,Test]=additionalinfoFB(GHext.num{1,1},GHext.den{1,1},amplitud_sp,TFinal,1000);

% --------------------------------------------------------------------------------
% LAZO INTERNO
% --------------------------------------------------------------------------------
% Additional information about frequency response
nGHint=GHint.num{1,1}; dGHint=GHint.den{1,1};
[zeros_GHint, poles_GHint,KGHint]=xzpkdata(nGHint,dGHint);
Kastericint=KGHint;
[mGHint,pGHint,wint]=bode(GHint);
% fix the phase wrap arownd
phaudint=pGHint;
phwint=unwrap(phaudint*pi/180);
phaudint=phwint*180/pi;
% delayed plant phase,
%phad=phaud + ((-w.*delay)*180/pi)';
%delay=0;
[Kastint,Kast_ultint,wultint,GMint,wcgint,PMint]=additionalinfofreq(GHint,Kastericint,mGHint,phaudint,tiempo_muerto,wint);


% --------------------------------------------------------------------------------
% LAZO EXTERNO
% --------------------------------------------------------------------------------
% Additional information about frequency response
nGHext=GHext.num{1,1}; dGHext=GHext.den{1,1};
[zeros_GHext, poles_GHext,KGHext]=xzpkdata(nGHext,dGHext);
Kastericext=KGHext;
[mGHext,pGHext,wext]=bode(GHext);
% fix the phase wrap arownd
phaudext=pGHext;
phwext=unwrap(phaudext*pi/180);
phaudext=phwext*180/pi;
% delayed plant phase,
%phad=phaud + ((-w.*delay)*180/pi)';
%delay=0;
[Kastext,Kast_ultext,wultext,GMext,wcgext,PMext]=additionalinfofreq(GHext,Kastericext,mGHext,phaudext,tiempo_muerto,wext);


% Zeros and poles of closed loop
Gcl=GHext/(1+GHext);
[zeros_cl, poles_cl,Kcl]=xzpkdata(Gcl.num{1,1},Gcl.den{1,1});


  % --------------------------
  % Save Results
  % --------------------------
  save([fpath fname], 'Gp1','Gp2','Gl1','Gl2','Gv','Gm1','Gm2','Gt','tiempo_muerto', ...
       'Krint', 'Krext','Cint', 'Cext', 'GHint', 'GHext', ...
       'Kastint','Kast_ultint','wultint','GMint','wcgint','PMint', ...
       'Kastext','Kast_ultext','wultext','GMext','wcgext','PMext', ...
       'zeros_GHint', 'poles_GHint','zeros_GHext', 'poles_GHext','zeros_cl', 'poles_cl', ...
       'estabilidad','yinf','Test', 'T_sp','T_l1','T_l2','TFinal','tsim','ysim', ...
       'amplitud_sp','amplitud_l1','amplitud_l2');
else
  disp('Cancelado');
endif;

end

 
%
% Dialog creation windows function 
%
function ret = show_CDCwindow()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 1218)/2;
  _yPos = 63;
   CDCwindow = figure ( ... 
	'Color', [0.949 0.949 0.949], ...
	'Position', [_xPos _yPos 1218 675], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  CDC_Image = axes( ...
	'Units', 'pixels', ... 
	'parent',CDCwindow, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [2 368 742 315]);
  btn_simulCDC = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [10 336 69 25], ... 
	'String', 'Simulate', ... 
	'TooltipString', '');
  btn_helpCDC = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [782 8 90 22], ... 
	'String', 'Help', ... 
	'TooltipString', '');
  btn_closeCCD = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [1109 8 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  Label_10 = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [845 647 257 23], ... 
	'String', 'Analysis and Simulation of ', ... 
	'TooltipString', '');
  simulationCCD_image = axes( ...
	'Units', 'pixels', ... 
	'parent',CDCwindow, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [106 58 768 298]);
  estabilidad = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 378 49 17], ... 
	'String', 'Sistem:', ... 
	'TooltipString', '');
  Test = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 315 113 17], ... 
	'String', 'Settling Time. =  ', ... 
	'TooltipString', '');
  tiempo_estab_GH = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 313 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  y_inf = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 343 48 17], ... 
	'String', 'y(inf) =', ... 
	'TooltipString', '');
  valor_final = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 343 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_15 = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 8, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [965 296 72 14], ... 
	'String', '(Approximate)', ... 
	'TooltipString', '');
  btn_CDCstepresponse = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [875 334 25 22], ... 
	'String', '+', ... 
	'TooltipString', '');
  label_Estabilidad = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1073 373 126 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_19 = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [895 245 41 17], ... 
	'String', '[K*] = ', ... 
	'TooltipString', '');
  Kasterisco_int = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 243 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Kastultimo = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [895 208 50 17], ... 
	'String', '[K*u] = ', ... 
	'TooltipString', '');
  Kasterisco_ultimo_int = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 208 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_omega_u = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Standard Symbols L', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [895 173 60 27], ... 
	'String', 'w       =', ... 
	'TooltipString', '');
  wu_int = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 173 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_sub_u = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [910 173 30 17], ... 
	'String', '-180', ... 
	'TooltipString', '');
  Label_GM = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [895 138 39 17], ... 
	'String', 'GM = ', ... 
	'TooltipString', '');
  gain_margin_int = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 138 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_omega_180 = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Standard Symbols L', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [895 103 45 27], ... 
	'String', 'w   = ', ... 
	'TooltipString', '');
  Label_sub_cg = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [905 93 30 17], ... 
	'String', '-180', ... 
	'TooltipString', '');
  w_cg_int = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 103 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_PM = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [895 63 41 17], ... 
	'String', 'PM  = ', ... 
	'TooltipString', '');
  phase_margin_int = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 63 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  btn_CDCanalysis = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [763 480 186 50], ... 
	'String', 'Analysis Tools', ... 
	'TooltipString', '');
  btn_runloadCDCdatawindow = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [763 537 186 46], ... 
	'String', 'Load Data', ... 
	'TooltipString', '');
  btn_CDCsimparameters = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [763 421 187 49], ... 
	'String', 'Simulation Parameters', ... 
	'TooltipString', '');
  btn_CDCadditionalinfo = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [990 403 183 22], ... 
	'String', 'Additional Information', ... 
	'TooltipString', '');
  btn_setdefaultCDC = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [985 561 215 22], ... 
	'String', 'Reload Default Values', ... 
	'TooltipString', '');
  btn_clear_CDCsimfigure = uicontrol( ...
	'parent',CDCwindow, ... 
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
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 15, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [855 612 229 23], ... 
	'String', 'Cascade Control System', ... 
	'TooltipString', '');
  Label_15 = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [962 268 90 17], ... 
	'String', 'Lazo Interno', ... 
	'TooltipString', '');
  Label_16 = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.949 0.949 0.949], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1105 268 94 17], ... 
	'String', 'Lazo Externo', ... 
	'TooltipString', '');
  Kasterisco_ext = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 243 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Kasterisco_ultimo_ext = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 208 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  wu_ext = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 173 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  gain_margin_ext = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 138 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  w_cg_ext = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 103 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  phase_margin_ext = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [1109 63 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  btn_saveCDC = uicontrol( ...
	'parent',CDCwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [965 8 90 22], ... 
	'String', 'Save', ... 
	'TooltipString', '');

  CDCwindow = struct( ...
      'figure', CDCwindow, ...
      'CDC_Image', CDC_Image, ...
      'btn_simulCDC', btn_simulCDC, ...
      'btn_helpCDC', btn_helpCDC, ...
      'btn_closeCCD', btn_closeCCD, ...
      'Label_10', Label_10, ...
      'simulationCCD_image', simulationCCD_image, ...
      'estabilidad', estabilidad, ...
      'Test', Test, ...
      'tiempo_estab_GH', tiempo_estab_GH, ...
      'y_inf', y_inf, ...
      'valor_final', valor_final, ...
      'Label_15', Label_15, ...
      'btn_CDCstepresponse', btn_CDCstepresponse, ...
      'label_Estabilidad', label_Estabilidad, ...
      'Label_19', Label_19, ...
      'Kasterisco_int', Kasterisco_int, ...
      'Kastultimo', Kastultimo, ...
      'Kasterisco_ultimo_int', Kasterisco_ultimo_int, ...
      'Label_omega_u', Label_omega_u, ...
      'wu_int', wu_int, ...
      'Label_sub_u', Label_sub_u, ...
      'Label_GM', Label_GM, ...
      'gain_margin_int', gain_margin_int, ...
      'Label_omega_180', Label_omega_180, ...
      'Label_sub_cg', Label_sub_cg, ...
      'w_cg_int', w_cg_int, ...
      'Label_PM', Label_PM, ...
      'phase_margin_int', phase_margin_int, ...
      'btn_CDCanalysis', btn_CDCanalysis, ...
      'btn_runloadCDCdatawindow', btn_runloadCDCdatawindow, ...
      'btn_CDCsimparameters', btn_CDCsimparameters, ...
      'btn_CDCadditionalinfo', btn_CDCadditionalinfo, ...
      'btn_setdefaultCDC', btn_setdefaultCDC, ...
      'btn_clear_CDCsimfigure', btn_clear_CDCsimfigure, ...
      'Label_14', Label_14, ...
      'Label_15', Label_15, ...
      'Label_16', Label_16, ...
      'Kasterisco_ext', Kasterisco_ext, ...
      'Kasterisco_ultimo_ext', Kasterisco_ultimo_ext, ...
      'wu_ext', wu_ext, ...
      'gain_margin_ext', gain_margin_ext, ...
      'w_cg_ext', w_cg_ext, ...
      'phase_margin_ext', phase_margin_ext, ...
      'btn_saveCDC', btn_saveCDC);


  set (btn_simulCDC, 'callback', {@btn_simulCDC_doIt, CDCwindow});
  set (btn_closeCCD, 'callback', {@btn_closeCCD_doIt, CDCwindow});
  set (tiempo_estab_GH, 'callback', {@tiempo_estab_GH_doIt, CDCwindow});
  set (btn_CDCstepresponse, 'callback', {@btn_CDCstepresponse_doIt, CDCwindow});
  set (btn_CDCanalysis, 'callback', {@btn_CDCanalysis_doIt, CDCwindow});
  set (btn_runloadCDCdatawindow, 'callback', {@btn_runloadCDCdatawindow_doIt, CDCwindow});
  set (btn_CDCsimparameters, 'callback', {@btn_CDCsimparameters_doIt, CDCwindow});
  set (btn_CDCadditionalinfo, 'callback', {@btn_CDCadditionalinfo_doIt, CDCwindow});
  set (btn_setdefaultCDC, 'callback', {@btn_setdefaultCDC_doIt, CDCwindow});
  set (btn_clear_CDCsimfigure, 'callback', {@btn_clear_CDCsimfigure_doIt, CDCwindow});
  set (btn_saveCDC, 'callback', {@btn_saveCDC_doIt, CDCwindow});
  dlg = struct(CDCwindow);


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
axes(CDCwindow.CDC_Image);
imshow([_basePath filesep() 'img' filesep() 'CDControl.png']);
refresh();


%------------------------------------------------------------------------
% Load data
load([_basePath filesep() 'data' filesep() 'loadCDCdata'])
load([_basePath filesep() 'data' filesep() 'loadCDCsim'])
%------------------------------------------------------------------------

% Limpio el command Window de Octave
clc

%refresh();





















  ret = CDCwindow;
end

