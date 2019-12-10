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

## @deftypefn  {} {} btn_closeloaddataCDC_doIt (@var{source}, @var{callbackdata}, @var{cdCLoadDataWnd})
##
## Define a callback for default action of btn_closeloaddataCDC control.
##
## @end deftypefn
function btn_closeloaddataCDC_doIt(source, callbackdata, cdCLoadDataWnd)


% global variable
global _ltitoolBasePath;

% Determino las funciones de transferencias
s=tf('s'); % Defino la variable compleja "s"
% Funciones de transferencia de la planta
% Gp1 y Gp2
numGp1 = get(cdCLoadDataWnd.numGp1, 'string');
denGp1 = get(cdCLoadDataWnd.denGp1, 'string');
sysStrGp1 = strcat('(',numGp1,')', '/','(', denGp1,')');
Gp1 = tf(eval(sysStrGp1));
numGp2 = get(cdCLoadDataWnd.numGp2, 'string');
denGp2 = get(cdCLoadDataWnd.denGp2, 'string');
sysStrGp2 = strcat('(',numGp2,')', '/','(', denGp2,')');
Gp2 = tf(eval(sysStrGp2));
% Gl1 y Gl2
numGl1 = get(cdCLoadDataWnd.numGl1, 'string');
denGl1 = get(cdCLoadDataWnd.denGl1, 'string');
sysStrGl1 = strcat('(',numGl1,')', '/','(', denGl1,')');
Gl1 = tf(eval(sysStrGl1));
numGl2 = get(cdCLoadDataWnd.numGl2, 'string');
denGl2 = get(cdCLoadDataWnd.denGl2, 'string');
sysStrGl2 = strcat('(',numGl2,')', '/','(', denGl2,')');
Gl2 = tf(eval(sysStrGl2));
% Funciones de transferencia de los elmentos de medicion
numGm1 = get(cdCLoadDataWnd.numGm1, 'string');
denGm1 = get(cdCLoadDataWnd.denGm1, 'string');
sysStrGm1 = strcat('(',numGm1,')', '/','(', denGm1,')');
Gm1 = tf(eval(sysStrGm1));
numGm2 = get(cdCLoadDataWnd.numGm2, 'string');
denGm2 = get(cdCLoadDataWnd.denGm2, 'string');
sysStrGm2 = strcat('(',numGm2,')', '/','(', denGm2,')');
Gm2 = tf(eval(sysStrGm2));
% Funcion de transferencia del conversor de entrada
numGt = get(cdCLoadDataWnd.numGt, 'string');
denGt = get(cdCLoadDataWnd.denGt, 'string');
sysStrGt = strcat('(',numGt,')', '/','(', denGt,')');
Gt = tf(eval(sysStrGt));
% Funcion de transferencia del elemento de control final
numGv = get(cdCLoadDataWnd.numGv, 'string');
denGv = get(cdCLoadDataWnd.denGv, 'string');
sysStrGv = strcat('(',numGv,')', '/','(', denGv,')');
Gv = tf(eval(sysStrGv));
% Funcion de transferencia de los controladores
numCint = get(cdCLoadDataWnd.numCint, 'string');
denCint = get(cdCLoadDataWnd.denCint, 'string');
sysStrCint = strcat('(',numCint,')', '/','(', denCint,')');
Cint = tf(eval(sysStrCint));
numCext = get(cdCLoadDataWnd.numCext, 'string');
denCext = get(cdCLoadDataWnd.denCext, 'string');
sysStrCext = strcat('(',numCext,')', '/','(', denCext,')');
Cext = tf(eval(sysStrCext));

% G(s)H(s)
GHint=minreal(Gp2*Gv*Cint*Gm2); Gastint1=minreal(Gp2*Gv*Cint/(1+GHint));
GHext=minreal(Gp1*Gastint1*Cext*Gm1);

% Calculate  both GHint and GHext gains
[ceros_la, polos_la,Krint]=xzpkdata(Cint.num,Cint.den);
[ceros_la, polos_la,Krext]=xzpkdata(Cext.num,Cext.den);

% Save data
tiempo_muerto=0.0;
save([_ltitoolBasePath filesep() 'data' filesep() 'loadCDCdata'],'Gp1','Gp2','Gl1','Gl2','Gm1','Gm2','Gt','Gv', ...
                          'Cint','Cext','tiempo_muerto','Krint','Krext','GHint','GHext');

% Close window
close(cdCLoadDataWnd.figure);

end

 
## @deftypefn  {} {@var{ret} = } show_cdCLoadDataWnd()
##
## Create windows controls over a figure, link controls with callbacks and return 
## a window struct representation.
##
## @end deftypefn
function ret = show_cdCLoadDataWnd()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 737)/2;
  _yPos = (_scrSize(4) - 670)/2;
   cdCLoadDataWnd = figure ( ... 
	'Color', [0.961 0.965 0.969], ...
	'Position', [_xPos _yPos 737 670], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  numGp = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [210 570 183 17], ... 
	'String', 'bm*s^m+......+b1*s^1+b0 ', ... 
	'TooltipString', '');
  numGp1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 568 120 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gp1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 543 194 17], ... 
	'String', 'Gp1(s) = ------------------------------', ... 
	'TooltipString', '');
  denGp1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 513 120 22], ... 
	'String', '', ... 
	'TooltipString', '');
  demGp = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [210 517 134 15], ... 
	'String', 'an*s^n+.....+a1*s^1+a0', ... 
	'TooltipString', '');
  Label_31 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 13, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [140 640 495 20], ... 
	'String', 'Transfer Functions of Cascade Control System', ... 
	'TooltipString', '');
  btn_closeloaddataCDC = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [630 18 90 22], ... 
	'String', 'OK', ... 
	'TooltipString', '');
  Gl1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 448 192 17], ... 
	'String', 'Gl1(s) = ------------------------------ ', ... 
	'TooltipString', '');
  numGl1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 473 127 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGl1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 418 127 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_21 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [290 603 63 17], ... 
	'String', 'Plant', ... 
	'TooltipString', '');
  Label_22 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 363 177 17], ... 
	'String', 'Measuring Elements', ... 
	'TooltipString', '');
  Gm1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 308 184 17], ... 
	'String', 'Gm1(s) = ---------------------------', ... 
	'TooltipString', '');
  numGm1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 333 121 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGm1 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 278 123 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gt = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [220 308 164 17], ... 
	'String', 'Gt(s) = --------------------------', ... 
	'TooltipString', '');
  Label_25 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [220 363 160 17], ... 
	'String', 'Input Converter', ... 
	'TooltipString', '');
  Label_26 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [435 363 185 17], ... 
	'String', 'Final Control Element', ... 
	'TooltipString', '');
  numGt = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [265 333 115 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGt = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [265 278 113 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gv = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [435 308 179 17], ... 
	'String', 'Gv(s) = -----------------------------', ... 
	'TooltipString', '');
  numGv = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [490 333 116 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGv = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [490 278 111 22], ... 
	'String', '', ... 
	'TooltipString', '');
  controladores = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [270 153 102 17], ... 
	'String', 'Controllers', ... 
	'TooltipString', '');
  Label_32 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 158 243 17], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Cint = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 73 198 17], ... 
	'String', 'Cint(s) = -------------------------------', ... 
	'TooltipString', '');
  numCint = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [85 93 123 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denCint = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [85 48 124 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_37 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [385 160 238 15], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Label_39 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 20 599 15], ... 
	'String', '___________________________________________________________________________________', ... 
	'TooltipString', '');
  Gm2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 220 175 15], ... 
	'String', 'Gm2(s) = ---------------------------', ... 
	'TooltipString', '');
  numGm2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 238 119 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGm2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 188 117 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Contr_Interno = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [15 128 181 17], ... 
	'String', 'Internal Controller', ... 
	'TooltipString', '');
  Contr_Externo = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 128 183 17], ... 
	'String', 'External Controller', ... 
	'TooltipString', '');
  Cext = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 78 202 17], ... 
	'String', 'Cext(s) = -------------------------------', ... 
	'TooltipString', '');
  numCext = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [440 93 128 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denCext = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [440 48 127 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_24 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 607 275 18], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Label_25 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 607 275 18], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Gp2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [415 543 190 17], ... 
	'String', 'Gp2(s)= ------------------------------', ... 
	'TooltipString', '');
  numGp2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [470 568 124 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGp2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [470 515 124 20], ... 
	'String', '', ... 
	'TooltipString', '');
  Gl2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [416 448 190 17], ... 
	'String', 'Gl2(s)= -------------------------------', ... 
	'TooltipString', '');
  numGl2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [469 473 126 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGl2 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [470 418 124 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_28 = uicontrol( ...
	'parent',cdCLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 392 691 18], ... 
	'String', '___________________________________________________________________________________', ... 
	'TooltipString', '');

  cdCLoadDataWnd = struct( ...
      'figure', cdCLoadDataWnd, ...
      'numGp', numGp, ...
      'numGp1', numGp1, ...
      'Gp1', Gp1, ...
      'denGp1', denGp1, ...
      'demGp', demGp, ...
      'Label_31', Label_31, ...
      'btn_closeloaddataCDC', btn_closeloaddataCDC, ...
      'Gl1', Gl1, ...
      'numGl1', numGl1, ...
      'denGl1', denGl1, ...
      'Label_21', Label_21, ...
      'Label_22', Label_22, ...
      'Gm1', Gm1, ...
      'numGm1', numGm1, ...
      'denGm1', denGm1, ...
      'Gt', Gt, ...
      'Label_25', Label_25, ...
      'Label_26', Label_26, ...
      'numGt', numGt, ...
      'denGt', denGt, ...
      'Gv', Gv, ...
      'numGv', numGv, ...
      'denGv', denGv, ...
      'controladores', controladores, ...
      'Label_32', Label_32, ...
      'Cint', Cint, ...
      'numCint', numCint, ...
      'denCint', denCint, ...
      'Label_37', Label_37, ...
      'Label_39', Label_39, ...
      'Gm2', Gm2, ...
      'numGm2', numGm2, ...
      'denGm2', denGm2, ...
      'Contr_Interno', Contr_Interno, ...
      'Contr_Externo', Contr_Externo, ...
      'Cext', Cext, ...
      'numCext', numCext, ...
      'denCext', denCext, ...
      'Label_24', Label_24, ...
      'Label_25', Label_25, ...
      'Gp2', Gp2, ...
      'numGp2', numGp2, ...
      'denGp2', denGp2, ...
      'Gl2', Gl2, ...
      'numGl2', numGl2, ...
      'denGl2', denGl2, ...
      'Label_28', Label_28);


  set (btn_closeloaddataCDC, 'callback', {@btn_closeloaddataCDC_doIt, cdCLoadDataWnd});
  dlg = struct(cdCLoadDataWnd);


% global variable
global _ltitoolBasePath;

%
% Load predefined data
% --------------------------------
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCDCdata'])

% Show transfer function on window
% Plant:
set(cdCLoadDataWnd.numGp1,'string',polyout(Gp1.num{1,1})); 
set(cdCLoadDataWnd.denGp1,'string',polyout(Gp1.den{1,1}));
set(cdCLoadDataWnd.numGp2,'string',polyout(Gp2.num{1,1})); 
set(cdCLoadDataWnd.denGp2,'string',polyout(Gp2.den{1,1}));
set(cdCLoadDataWnd.numGl1,'string',polyout(Gl1.num{1,1}));
set(cdCLoadDataWnd.denGl1,'string',polyout(Gl1.den{1,1}));
set(cdCLoadDataWnd.numGl2,'string',polyout(Gl2.num{1,1}));
set(cdCLoadDataWnd.denGl2,'string',polyout(Gl2.den{1,1}));
% Measurin elements
set(cdCLoadDataWnd.numGm1,'string',polyout(Gm1.num{1,1}));
set(cdCLoadDataWnd.denGm1,'string',polyout(Gm1.den{1,1}));
set(cdCLoadDataWnd.numGm2,'string',polyout(Gm2.num{1,1}));
set(cdCLoadDataWnd.denGm2,'string',polyout(Gm2.den{1,1}));
% Input converter
set(cdCLoadDataWnd.numGt,'string',polyout(Gt.num{1,1}));
set(cdCLoadDataWnd.denGt,'string',polyout(Gt.den{1,1}));
% Final control element
set(cdCLoadDataWnd.numGv,'string',polyout(Gv.num{1,1}));
set(cdCLoadDataWnd.denGv,'string',polyout(Gv.den{1,1}));
% Controllers
set(cdCLoadDataWnd.numCint,'string',polyout(Cint.num{1,1}));
set(cdCLoadDataWnd.denCint,'string',polyout(Cint.den{1,1}));
set(cdCLoadDataWnd.numCext,'string',polyout(Cext.num{1,1}));
set(cdCLoadDataWnd.denCext,'string',polyout(Cext.den{1,1}));




















  ret = cdCLoadDataWnd;
end

