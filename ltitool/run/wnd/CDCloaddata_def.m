%
% Set the graphics toolkit and force read this file as script file (not a function file).
%
graphics_toolkit qt;
%


%
%
% Begin callbacks definitions 
%

function btn_closeloaddataCDC_doIt(source, callbackdata, CDCloaddata)


% global variable
global _basePath;

% Determino las funciones de transferencias
s=tf('s'); % Defino la variable compleja "s"
% Funciones de transferencia de la planta
% Gp1 y Gp2
numGp1 = get(dlg.numGp1, 'string');
denGp1 = get(dlg.denGp1, 'string');
sysStrGp1 = strcat('(',numGp1,')', '/','(', denGp1,')');
Gp1 = tf(eval(sysStrGp1));
numGp2 = get(dlg.numGp2, 'string');
denGp2 = get(dlg.denGp2, 'string');
sysStrGp2 = strcat('(',numGp2,')', '/','(', denGp2,')');
Gp2 = tf(eval(sysStrGp2));
% Gl1 y Gl2
numGl1 = get(dlg.numGl1, 'string');
denGl1 = get(dlg.denGl1, 'string');
sysStrGl1 = strcat('(',numGl1,')', '/','(', denGl1,')');
Gl1 = tf(eval(sysStrGl1));
numGl2 = get(dlg.numGl2, 'string');
denGl2 = get(dlg.denGl2, 'string');
sysStrGl2 = strcat('(',numGl2,')', '/','(', denGl2,')');
Gl2 = tf(eval(sysStrGl2));
% Funciones de transferencia de los elmentos de medicion
numGm1 = get(dlg.numGm1, 'string');
denGm1 = get(dlg.denGm1, 'string');
sysStrGm1 = strcat('(',numGm1,')', '/','(', denGm1,')');
Gm1 = tf(eval(sysStrGm1));
numGm2 = get(dlg.numGm2, 'string');
denGm2 = get(dlg.denGm2, 'string');
sysStrGm2 = strcat('(',numGm2,')', '/','(', denGm2,')');
Gm2 = tf(eval(sysStrGm2));
% Funcion de transferencia del conversor de entrada
numGt = get(dlg.numGt, 'string');
denGt = get(dlg.denGt, 'string');
sysStrGt = strcat('(',numGt,')', '/','(', denGt,')');
Gt = tf(eval(sysStrGt));
% Funcion de transferencia del elemento de control final
numGv = get(dlg.numGv, 'string');
denGv = get(dlg.denGv, 'string');
sysStrGv = strcat('(',numGv,')', '/','(', denGv,')');
Gv = tf(eval(sysStrGv));
% Funcion de transferencia de los controladores
numCint = get(dlg.numCint, 'string');
denCint = get(dlg.denCint, 'string');
sysStrCint = strcat('(',numCint,')', '/','(', denCint,')');
Cint = tf(eval(sysStrCint));
numCext = get(dlg.numCext, 'string');
denCext = get(dlg.denCext, 'string');
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
save([_basePath filesep() 'data' filesep() 'loadCDCdata'],'Gp1','Gp2','Gl1','Gl2','Gm1','Gm2','Gt','Gv', ...
                          'Cint','Cext','tiempo_muerto','Krint','Krext','GHint','GHext');

% Close window
close(dlg.CDCloaddata);

end

 
%
% Dialog creation windows function 
%
function ret = show_CDCloaddata()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 737)/2;
  _yPos = (_scrSize(4) - 639)/2;
   CDCloaddata = figure ( ... 
	'Color', [0.961 0.965 0.969], ...
	'Position', [_xPos _yPos 737 639], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  numGp = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [210 539 183 17], ... 
	'String', '(bm*s^m+......+b1*s^1+b0) ', ... 
	'TooltipString', '');
  numGp1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 537 120 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gp1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 512 194 17], ... 
	'String', 'Gp1(s) = ------------------------------', ... 
	'TooltipString', '');
  denGp1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 482 120 22], ... 
	'String', '', ... 
	'TooltipString', '');
  demGp = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [210 484 164 17], ... 
	'String', '(an*s^n+.....+a1*s^1+a0)', ... 
	'TooltipString', '');
  Label_31 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 13, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [140 609 502 20], ... 
	'String', 'Funciones de Transferencia del Sistema de Control en Cascada', ... 
	'TooltipString', '');
  btn_closeloaddataCDC = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [630 7 90 22], ... 
	'String', 'OK', ... 
	'TooltipString', '');
  Gl1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 417 192 17], ... 
	'String', 'Gl1(s) = ------------------------------ ', ... 
	'TooltipString', '');
  numGl1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 442 127 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGl1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 387 127 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_21 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [285 572 46 17], ... 
	'String', 'Planta', ... 
	'TooltipString', '');
  Label_22 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 332 166 17], ... 
	'String', 'Elementos de Medición', ... 
	'TooltipString', '');
  Gm1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 277 184 17], ... 
	'String', 'Gm1(s) = ---------------------------', ... 
	'TooltipString', '');
  numGm1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 302 121 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGm1 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 247 123 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gt = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [220 277 164 17], ... 
	'String', 'Gt(s) = --------------------------', ... 
	'TooltipString', '');
  Label_25 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [220 332 154 17], ... 
	'String', 'Conversor de Entrada', ... 
	'TooltipString', '');
  Label_26 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [435 332 186 17], ... 
	'String', 'Elemento de Control Final', ... 
	'TooltipString', '');
  numGt = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [265 302 115 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGt = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [265 247 113 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gv = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [435 277 179 17], ... 
	'String', 'Gv(s) = -----------------------------', ... 
	'TooltipString', '');
  numGv = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [490 302 116 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGv = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [490 247 111 22], ... 
	'String', '', ... 
	'TooltipString', '');
  controladores = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [255 122 103 17], ... 
	'String', 'Controladores', ... 
	'TooltipString', '');
  Label_32 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 127 243 17], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Cint = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 52 198 17], ... 
	'String', 'Cint(s) = -------------------------------', ... 
	'TooltipString', '');
  numCint = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [85 72 123 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denCint = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [85 27 124 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_37 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [365 127 243 17], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Label_39 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 7 612 17], ... 
	'String', '___________________________________________________________________________________', ... 
	'TooltipString', '');
  Gm2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 187 184 17], ... 
	'String', 'Gm2(s) = ---------------------------', ... 
	'TooltipString', '');
  numGm2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 207 119 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGm2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 157 117 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Contr_Interno = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [15 97 144 17], ... 
	'String', 'Controlador Interno', ... 
	'TooltipString', '');
  Contr_Externo = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 97 148 17], ... 
	'String', 'Controlador Externo', ... 
	'TooltipString', '');
  Cext = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 57 202 17], ... 
	'String', 'Cext(s) = -------------------------------', ... 
	'TooltipString', '');
  numCext = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [440 72 128 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denCext = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [440 27 127 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_24 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 577 243 17], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Label_25 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 577 243 17], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Gp2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [415 512 190 17], ... 
	'String', 'Gp2(s)= ------------------------------', ... 
	'TooltipString', '');
  numGp2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [470 537 124 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGp2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [470 484 124 20], ... 
	'String', '', ... 
	'TooltipString', '');
  Gl2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [416 417 190 17], ... 
	'String', 'Gl2(s)= -------------------------------', ... 
	'TooltipString', '');
  numGl2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [469 442 126 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGl2 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [470 387 124 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_28 = uicontrol( ...
	'parent',CDCloaddata, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 362 612 17], ... 
	'String', '___________________________________________________________________________________', ... 
	'TooltipString', '');

  CDCloaddata = struct( ...
      'figure', CDCloaddata, ...
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


  set (btn_closeloaddataCDC, 'callback', {@btn_closeloaddataCDC_doIt, CDCloaddata});
  dlg = struct(CDCloaddata);


% global variable
global _basePath;

%
% Load predefined data
% --------------------------------
load([_basePath filesep() 'data' filesep() 'loadCDCdata'])

dlg=CDCloaddata;

% Show transfer function on window
% Plant:
set(dlg.numGp1,'string',polyout(Gp1.num{1,1})); 
set(dlg.denGp1,'string',polyout(Gp1.den{1,1}));
set(dlg.numGp2,'string',polyout(Gp2.num{1,1})); 
set(dlg.denGp2,'string',polyout(Gp2.den{1,1}));
set(dlg.numGl1,'string',polyout(Gl1.num{1,1}));
set(dlg.denGl1,'string',polyout(Gl1.den{1,1}));
set(dlg.numGl2,'string',polyout(Gl2.num{1,1}));
set(dlg.denGl2,'string',polyout(Gl2.den{1,1}));
% Measurin elements
set(dlg.numGm1,'string',polyout(Gm1.num{1,1}));
set(dlg.denGm1,'string',polyout(Gm1.den{1,1}));
set(dlg.numGm2,'string',polyout(Gm2.num{1,1}));
set(dlg.denGm2,'string',polyout(Gm2.den{1,1}));
% Input converter
set(dlg.numGt,'string',polyout(Gt.num{1,1}));
set(dlg.denGt,'string',polyout(Gt.den{1,1}));
% Final control element
set(dlg.numGv,'string',polyout(Gv.num{1,1}));
set(dlg.denGv,'string',polyout(Gv.den{1,1}));
% Controllers
set(dlg.numCint,'string',polyout(Cint.num{1,1}));
set(dlg.denCint,'string',polyout(Cint.den{1,1}));
set(dlg.numCext,'string',polyout(Cext.num{1,1}));
set(dlg.denCext,'string',polyout(Cext.den{1,1}));




















  ret = CDCloaddata;
end

