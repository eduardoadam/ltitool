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

## @deftypefn  {} {} btnAboutthis_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btnAboutthis control.
##
## @end deftypefn
function btnAboutthis_doIt(source, callbackdata, mainWnd)

% This code will be executed when user click the button control.
% As default, all events are deactivated, to activate must set the
% propertie 'have callback' from the properties editor

%
% Run main window of additional tools
%

aboutThisWnd();


end

## @deftypefn  {} {} btnHelp_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btnHelp control.
##
## @end deftypefn
function btnHelp_doIt(source, callbackdata, mainWnd)


%
% Run presentation to help  as html file.
%

% global variable
global _ltitoolBasePath;

% Load html file
url = ["file:" _ltitoolBasePath filesep() "ltitool_manual" filesep() "ltitool_manual.html"];

  if(isunix())
    system(["xdg-open " url]);
  elseif (ispc())
    system(["start " url]);
  else
    disp(["I don't know how to open " url " in your os. Sorry!"]);
  endif;

end

## @deftypefn  {} {} btnClose_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btnClose control.
##
## @end deftypefn
function btnClose_doIt(source, callbackdata, mainWnd)


% Close ltitool windown
close(mainWnd.figure);

end

## @deftypefn  {} {} btn_runOLwindow_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btn_runOLwindow control.
##
## @end deftypefn
function btn_runOLwindow_doIt(source, callbackdata, mainWnd)

% This code will be executed when user click the button control.
% As default, all events are deactivated, to activate must set the
% propertie 'have callback' from the properties editor

%
% Run Open Loop window
%

oLWnd();

end

## @deftypefn  {} {} btn_runGHwindow_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btn_runGHwindow control.
##
## @end deftypefn
function btn_runGHwindow_doIt(source, callbackdata, mainWnd)

% This code will be executed when user click the button control.
% As default, all events are deactivated, to activate must set the
% propertie 'have callback' from the properties editor

%
% Run GH analysis window
%

ghWnd();

end

## @deftypefn  {} {} btn_runCLwindow_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btn_runCLwindow control.
##
## @end deftypefn
function btn_runCLwindow_doIt(source, callbackdata, mainWnd)

% This code will be executed when user click the button control.
% As default, all events are deactivated, to activate must set the
% propertie 'have callback' from the properties editor

%
% Run Close Loop window
%

cLWnd();
end

## @deftypefn  {} {} btn_runACSwindow_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btn_runACSwindow control.
##
## @end deftypefn
function btn_runACSwindow_doIt(source, callbackdata, mainWnd)

% This code will be executed when user click the button control.
% As default, all events are deactivated, to activate must set the
% propertie 'have callback' from the properties editor

%
% Run main window of traditional advanced control strategies
%

aCSWnd();

end

## @deftypefn  {} {} btn_runADDITOOLwindow_doIt (@var{source}, @var{callbackdata}, @var{mainWnd})
##
## Define a callback for default action of btn_runADDITOOLwindow control.
##
## @end deftypefn
function btn_runADDITOOLwindow_doIt(source, callbackdata, mainWnd)

% This code will be executed when user click the button control.
% As default, all events are deactivated, to activate must set the
% propertie 'have callback' from the properties editor

%
% Run main window of additional tools
%

addiToolWnd();

end

 
## @deftypefn  {} {@var{ret} = } show_mainWnd()
##
## Create windows controls over a figure, link controls with callbacks and return 
## a window struct representation.
##
## @end deftypefn
function ret = show_mainWnd()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 934)/2;
  _yPos = (_scrSize(4) - 645)/2;
   mainWnd = figure ( ... 
	'Color', [0.937 0.922 0.906], ...
	'Position', [_xPos _yPos 934 645], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  Image_ppl = axes( ...
	'Units', 'pixels', ... 
	'parent',mainWnd, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [242 84 673 499]);
  btnAboutthis = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [13 18 90 22], ... 
	'String', 'About This', ... 
	'TooltipString', '');
  btnHelp = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [300 18 90 22], ... 
	'String', 'Help', ... 
	'TooltipString', '');
  btnClose = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [528 18 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  btn_runOLwindow = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [10 522 221 38], ... 
	'String', 'Open Loop System Analysis', ... 
	'TooltipString', '');
  btn_runGHwindow = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [10 434 221 39], ... 
	'String', 'Analysis Based On G(s)H(s)', ... 
	'TooltipString', '');
  btn_runCLwindow = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [9 331 222 35], ... 
	'String', 'Close Loop System Analysis', ... 
	'TooltipString', '');
  btn_runACSwindow = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [9 218 222 34], ... 
	'String', 'Advanced Control Strategies', ... 
	'TooltipString', '');
  Label_188 = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 16, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [155 605 390 25], ... 
	'String', 'LTI System Control Toolbox', ... 
	'TooltipString', '');
  btn_runADDITOOLwindow = uicontrol( ...
	'parent',mainWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.937 0.922 0.906], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Arial', ... 
	'FontSize', 10, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [9 73 222 35], ... 
	'String', 'Additional Control Tools', ... 
	'TooltipString', '');

  mainWnd = struct( ...
      'figure', mainWnd, ...
      'Image_ppl', Image_ppl, ...
      'btnAboutthis', btnAboutthis, ...
      'btnHelp', btnHelp, ...
      'btnClose', btnClose, ...
      'btn_runOLwindow', btn_runOLwindow, ...
      'btn_runGHwindow', btn_runGHwindow, ...
      'btn_runCLwindow', btn_runCLwindow, ...
      'btn_runACSwindow', btn_runACSwindow, ...
      'Label_188', Label_188, ...
      'btn_runADDITOOLwindow', btn_runADDITOOLwindow);


  set (btnAboutthis, 'callback', {@btnAboutthis_doIt, mainWnd});
  set (btnHelp, 'callback', {@btnHelp_doIt, mainWnd});
  set (btnClose, 'callback', {@btnClose_doIt, mainWnd});
  set (btn_runOLwindow, 'callback', {@btn_runOLwindow_doIt, mainWnd});
  set (btn_runGHwindow, 'callback', {@btn_runGHwindow_doIt, mainWnd});
  set (btn_runCLwindow, 'callback', {@btn_runCLwindow_doIt, mainWnd});
  set (btn_runACSwindow, 'callback', {@btn_runACSwindow_doIt, mainWnd});
  set (btn_runADDITOOLwindow, 'callback', {@btn_runADDITOOLwindow_doIt, mainWnd});
  dlg = struct(mainWnd);


%
% LTITOOL main window
%

% Load packages
pkg load control;
pkg load linear-algebra;
pkg load odepkg;
pkg load optim;
pkg load signal;
pkg load struct;

% Clear command window
clc

% global variable
global _ltitoolBasePath; global _ltitoolImgPath;

% Main window image
axes(mainWnd.Image_ppl);
imshow([_ltitoolImgPath filesep() 'image_ppl.png']);
refresh();

  ret = mainWnd;
end

