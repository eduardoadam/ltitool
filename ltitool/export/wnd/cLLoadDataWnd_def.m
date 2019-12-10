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

## @deftypefn  {} {} btn_closeGCLloaddata_doIt (@var{source}, @var{callbackdata}, @var{cLLoadDataWnd})
##
## Define a callback for default action of btn_closeGCLloaddata control.
##
## @end deftypefn
function btn_closeGCLloaddata_doIt(source, callbackdata, cLLoadDataWnd)


% global variable
global _ltitoolBasePath;

% Complex variable "s"
s=tf('s');
% Define transfer functions
% ----------------------------------------------------------------
% Gp(s)
numGp = get(cLLoadDataWnd.numGp, 'string');
denGp = get(cLLoadDataWnd.denGp, 'string');
sysStrGp = strcat('(',numGp,')', '/','(', denGp,')');
Gp = tf(eval(sysStrGp));
% Gl(s)
numGl = get(cLLoadDataWnd.numGl, 'string');
denGl = get(cLLoadDataWnd.denGl, 'string');
sysStrGl = strcat('(',numGl,')', '/','(', denGl,')');
Gl = tf(eval(sysStrGl));
% Gm(s)
numGm = get(cLLoadDataWnd.numGm, 'string');
denGm = get(cLLoadDataWnd.denGm, 'string');
sysStrGm = strcat('(',numGm,')', '/','(', denGm,')');
Gm = tf(eval(sysStrGm));
% Gt(s)
numGt = get(cLLoadDataWnd.numGt, 'string');
denGt = get(cLLoadDataWnd.denGt, 'string');
sysStrGt = strcat('(',numGt,')', '/','(', denGt,')');
Gt = tf(eval(sysStrGt));
% Gv(s)
numGv = get(cLLoadDataWnd.numGv, 'string');
denGv = get(cLLoadDataWnd.denGv, 'string');
sysStrGv = strcat('(',numGv,')', '/','(', denGv,')');
Gv = tf(eval(sysStrGv));
% Gc(s)
numGcomp = get(cLLoadDataWnd.numGcomp, 'string');
denGcomp = get(cLLoadDataWnd.denGcomp, 'string');
sysStrGcomp = strcat('(',numGcomp,')', '/','(', denGcomp,')');
Gcomp = tf(eval(sysStrGcomp));

% Opcions of radio button: PID controller
% -----------------------------------------------------------------
op1 = get(cLLoadDataWnd.PID_rb, 'Value');			% PID
op2 = get(cLLoadDataWnd.Compensador_rb, 'Value');		% Compensator


if ((op1 == 1) && (op2 == 1))
  disp('You can not take two options');
elseif (op1 == 1)
  %Option 1: PID controller
  if(get(cLLoadDataWnd.Mode_P,'value') == 1) 
     % if the options is P mode
     Kr=str2num(get(cLLoadDataWnd.Kr,'string'));
   else
     Kr=0;
   endif
  if(get(cLLoadDataWnd.Mode_D,'value') == 1) 
     % if the options is D mode 
     TD=str2num(get(cLLoadDataWnd.TD,'string'));;
   else
     TD=0;
  endif
  if(get(cLLoadDataWnd.Mode_I,'value') == 1) 
     % if the options is I mode
     TI=str2num(get(cLLoadDataWnd.TI,'string'));;
     Gc=Kr+Kr/(TI*s)+Kr*TD*s;
   else
     TI=0;
     Gc=Kr+Kr*TD*s;
  endif
 elseif (op2 == 1)
     %Opction 2:  Compensator
     Gc = Gcomp;
     % set Kr=1, to avoid error
     Kr=1; TI=1; TD=0;
else
  disp('You must take an option');
endif

% G(s)H(s)
GH=Gp*Gv*Gc*Gm;

% Save data
tiempo_muerto=0.0;
save([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'],'Gp','Gl','Gm','Gt','Gv','Gc','Gcomp','tiempo_muerto','GH','Kr','TI','TD')

% Close window
close(cLLoadDataWnd.figure);

end

 
## @deftypefn  {} {@var{ret} = } show_cLLoadDataWnd()
##
## Create windows controls over a figure, link controls with callbacks and return 
## a window struct representation.
##
## @end deftypefn
function ret = show_cLLoadDataWnd()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 737)/2;
  _yPos = (_scrSize(4) - 578)/2;
   cLLoadDataWnd = figure ( ... 
	'Color', [0.961 0.965 0.969], ...
	'Position', [_xPos _yPos 737 578], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  numGp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [245 485 200 15], ... 
	'String', 'bm*s^m+......+b1*s^1+b0 ', ... 
	'TooltipString', '');
  numGp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [70 481 147 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 453 199 15], ... 
	'String', 'Gp(s) = -----------------------------------', ... 
	'TooltipString', '');
  denGp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [70 421 145 22], ... 
	'String', '', ... 
	'TooltipString', '');
  demGp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [245 425 202 15], ... 
	'String', 'an*s^n+.....+a1*s^1+a0', ... 
	'TooltipString', '');
  Label_31 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 13, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [158 550 462 18], ... 
	'String', 'Transfer Functions of the Closed Loop System', ... 
	'TooltipString', '');
  btn_closeGCLloaddata = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [635 16 90 22], ... 
	'String', 'OK', ... 
	'TooltipString', '');
  Gl = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [440 453 198 15], ... 
	'String', 'Gl(s) = ----------------------------------- ', ... 
	'TooltipString', '');
  numGl = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [485 481 152 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGl = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [485 421 147 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_21 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 513 68 15], ... 
	'String', 'Plant', ... 
	'TooltipString', '');
  Label_22 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 383 163 15], ... 
	'String', 'Measuring Element', ... 
	'TooltipString', '');
  Gm = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 326 176 17], ... 
	'String', 'Gm(s) = ---------------------------', ... 
	'TooltipString', '');
  numGm = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [85 351 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGm = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [85 296 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gt = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [220 328 156 15], ... 
	'String', 'Gt(s) = --------------------------', ... 
	'TooltipString', '');
  Label_25 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [220 383 141 15], ... 
	'String', 'Input Converter', ... 
	'TooltipString', '');
  Label_26 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [435 383 171 15], ... 
	'String', 'Final Control Element', ... 
	'TooltipString', '');
  numGt = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [275 351 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGt = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [275 296 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Gv = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [435 328 172 15], ... 
	'String', 'Gv(s) = -----------------------------', ... 
	'TooltipString', '');
  numGv = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [490 351 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGv = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [490 296 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  controlador = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [295 253 79 15], ... 
	'String', 'Controller', ... 
	'TooltipString', '');
  Kr = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [120 184 90 22], ... 
	'String', '1.0', ... 
	'TooltipString', '');
  TI = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [320 184 90 22], ... 
	'String', '1.0', ... 
	'TooltipString', '');
  TD = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [525 184 90 22], ... 
	'String', '0.0', ... 
	'TooltipString', '');
  Label_32 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [10 255 275 18], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Gc = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [25 98 181 15], ... 
	'String', 'Gc(s) = -------------------------------', ... 
	'TooltipString', '');
  numGcomp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 111 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  denGcomp = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','edit', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [1.000 1.000 1.000], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [80 66 90 22], ... 
	'String', '', ... 
	'TooltipString', '');
  Label_37 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [375 255 275 18], ... 
	'String', '_________________________________', ... 
	'TooltipString', '');
  Label_39 = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [20 40 691 18], ... 
	'String', '___________________________________________________________________________________', ... 
	'TooltipString', '');
  Mode_P = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','checkbox', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [20 186 86 17], ... 
	'String', 'P Mode', ... 
	'TooltipString', '', ... 
	'Min', 0, 'Max', 1, 'Value', 1);
  Mode_I = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','checkbox', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [235 186 74 17], ... 
	'String', 'I Mode', ... 
	'TooltipString', '', ... 
	'Min', 0, 'Max', 1, 'Value', 1);
  Mode_D = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','checkbox', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [430 186 79 17], ... 
	'String', 'D Mode', ... 
	'TooltipString', '', ... 
	'Min', 0, 'Max', 1, 'Value', 0);
  PID_rb = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','radiobutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [20 226 82 17], ... 
	'String', 'PID', ... 
	'TooltipString', '', ... 
	'Min', 0, 'Max', 1, 'Value', 1);
  Compensador_rb = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','radiobutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [20 141 140 17], ... 
	'String', 'Compensator', ... 
	'TooltipString', '', ... 
	'Min', 0, 'Max', 1, 'Value', 0);
  Label_PID = uicontrol( ...
	'parent',cLLoadDataWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [130 228 190 15], ... 
	'String', 'C(s)=Kr(1+1/TIs+TDs)', ... 
	'TooltipString', '');

  cLLoadDataWnd = struct( ...
      'figure', cLLoadDataWnd, ...
      'numGp', numGp, ...
      'numGp', numGp, ...
      'Gp', Gp, ...
      'denGp', denGp, ...
      'demGp', demGp, ...
      'Label_31', Label_31, ...
      'btn_closeGCLloaddata', btn_closeGCLloaddata, ...
      'Gl', Gl, ...
      'numGl', numGl, ...
      'denGl', denGl, ...
      'Label_21', Label_21, ...
      'Label_22', Label_22, ...
      'Gm', Gm, ...
      'numGm', numGm, ...
      'denGm', denGm, ...
      'Gt', Gt, ...
      'Label_25', Label_25, ...
      'Label_26', Label_26, ...
      'numGt', numGt, ...
      'denGt', denGt, ...
      'Gv', Gv, ...
      'numGv', numGv, ...
      'denGv', denGv, ...
      'controlador', controlador, ...
      'Kr', Kr, ...
      'TI', TI, ...
      'TD', TD, ...
      'Label_32', Label_32, ...
      'Gc', Gc, ...
      'numGcomp', numGcomp, ...
      'denGcomp', denGcomp, ...
      'Label_37', Label_37, ...
      'Label_39', Label_39, ...
      'Mode_P', Mode_P, ...
      'Mode_I', Mode_I, ...
      'Mode_D', Mode_D, ...
      'PID_rb', PID_rb, ...
      'Compensador_rb', Compensador_rb, ...
      'Label_PID', Label_PID);


  set (btn_closeGCLloaddata, 'callback', {@btn_closeGCLloaddata_doIt, cLLoadDataWnd});
  dlg = struct(cLLoadDataWnd);


% global variable
global _ltitoolBasePath;

%
% Load predefined data
% --------------------------------
load([_ltitoolBasePath filesep() 'data' filesep() 'loadCLdata'])


% Show data loaded in the window to be able to change them
set(cLLoadDataWnd.numGp,'string',polyout(Gp.num{1,1})); 
set(cLLoadDataWnd.denGp,'string',polyout(Gp.den{1,1}));
set(cLLoadDataWnd.numGl,'string',polyout(Gl.num{1,1}));
set(cLLoadDataWnd.denGl,'string',polyout(Gl.den{1,1}));
set(cLLoadDataWnd.numGm,'string',polyout(Gm.num{1,1}));
set(cLLoadDataWnd.denGm,'string',polyout(Gm.den{1,1}));
set(cLLoadDataWnd.numGt,'string',polyout(Gt.num{1,1}));
set(cLLoadDataWnd.denGt,'string',polyout(Gt.den{1,1}));
set(cLLoadDataWnd.numGv,'string',polyout(Gv.num{1,1}));
set(cLLoadDataWnd.denGv,'string',polyout(Gv.den{1,1}));
set(cLLoadDataWnd.numGcomp,'string',polyout(Gcomp.num{1,1}));
set(cLLoadDataWnd.denGcomp,'string',polyout(Gcomp.den{1,1}));

% Controller opcions
if(Kr==0)
	set(cLLoadDataWnd.Mode_P,'value',0);
	% If the option is not P  mode
	set(cLLoadDataWnd.Kr,'string','0');
else
	set(cLLoadDataWnd.Mode_P,'value',1);
	% If the option is P  mode
	set(cLLoadDataWnd.Kr,'string',num2str(Kr));
endif
if(TD==0)
	set(cLLoadDataWnd.Mode_D,'value',0);
	% If the option is not D mode
	set(cLLoadDataWnd.TD,'string','0');
else
	set(cLLoadDataWnd.Mode_D,'value',1);
	% If the option is D mode  
	set(cLLoadDataWnd.TD,'string',num2str(TD));
endif
if (TI==0)
	set(cLLoadDataWnd.Mode_I,'value',0);
	% If the option is not I mode 
	set(cLLoadDataWnd.TI,'string','0');
else
	set(cLLoadDataWnd.Mode_I,'value',1);
	% If the option is I mode 
	set(cLLoadDataWnd.TI,'string',num2str(TI));
endif


  ret = cLLoadDataWnd;
end

