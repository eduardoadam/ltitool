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

## @deftypefn  {} {} btn_closeABOUTTHIS_doIt (@var{source}, @var{callbackdata}, @var{aboutThisWnd})
##
## Define a callback for default action of btn_closeABOUTTHIS control.
##
## @end deftypefn
function btn_closeABOUTTHIS_doIt(source, callbackdata, aboutThisWnd)


  % Close window
  close(aboutThisWnd.figure);
end

 
## @deftypefn  {} {@var{ret} = } show_aboutThisWnd()
##
## Create windows controls over a figure, link controls with callbacks and return 
## a window struct representation.
##
## @end deftypefn
function ret = show_aboutThisWnd()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 803)/2;
  _yPos = (_scrSize(4) - 544)/2;
   aboutThisWnd = figure ( ... 
	'Color', [0.961 0.965 0.969], ...
	'Position', [_xPos _yPos 803 544], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  btn_closeABOUTTHIS = uicontrol( ...
	'parent',aboutThisWnd, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'ForegroundColor', [0.000 0.000 0.000], ... 
	'Position', [650 17 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  aboutthis_Image = axes( ...
	'Units', 'pixels', ... 
	'parent',aboutThisWnd, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [57 44 686 474]);

  aboutThisWnd = struct( ...
      'figure', aboutThisWnd, ...
      'btn_closeABOUTTHIS', btn_closeABOUTTHIS, ...
      'aboutthis_Image', aboutthis_Image);


  set (btn_closeABOUTTHIS, 'callback', {@btn_closeABOUTTHIS_doIt, aboutThisWnd});
  dlg = struct(aboutThisWnd);


%
% Additional tools main window
%

% global variable
global _ltitoolBasePath;

% Main window image
axes(aboutThisWnd.aboutthis_Image);
imshow([_ltitoolBasePath filesep() 'img' filesep() 'aboutthis.png']);
refresh();

% Clear el command Window
clc

%
refresh();











































  ret = aboutThisWnd;
end

