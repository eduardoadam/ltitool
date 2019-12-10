%
% Set the graphics toolkit and force read this file as script file (not a function file).
%
graphics_toolkit qt;
%


%
%
% Begin callbacks definitions 
%

function btn_closeACS_doIt(source, callbackdata, ACSwindow)


  % Close window
  close(dlg.ACSwindow);

end

function btn_runFFwindow_doIt(source, callbackdata, ACSwindow)


%
% Run ventan feedforward-feedback window
%

FFwindow();

end

function btn_runCDC_doIt(source, callbackdata, ACSwindow)


%
% Run Cascade Control
%

CDCwindow();

end

 
%
% Dialog creation windows function 
%
function ret = show_ACSwindow()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 686)/2;
  _yPos = (_scrSize(4) - 530)/2;
   ACSwindow = figure ( ... 
	'Color', [0.961 0.965 0.969], ...
	'Position', [_xPos _yPos 686 530], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  Label_titulo = uicontrol( ...
	'parent',ACSwindow, ... 
	'Style','text', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 16, 'FontUnits', 'points', ... 
	'FontWeight', 'bold', ... 
	'HorizontalAlignment', 'left', ... 
	'Position', [140 496 388 24], ... 
	'String', 'Traditional Avanced Control Strategies', ... 
	'TooltipString', '');
  btn_closeACS = uicontrol( ...
	'parent',ACSwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [567 13 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  btn_Help = uicontrol( ...
	'parent',ACSwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [26 13 90 22], ... 
	'String', 'Ayuda', ... 
	'TooltipString', '');
  Image_ACS = axes( ...
	'Units', 'pixels', ... 
	'parent',ACSwindow, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [106 52 551 416]);
  btn_runFFwindow = uicontrol( ...
	'parent',ACSwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [26 413 224 22], ... 
	'String', 'Feedforward-Feedback Control', ... 
	'TooltipString', '');
  btn_runCDC = uicontrol( ...
	'parent',ACSwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [26 233 166 22], ... 
	'String', 'Cascade Control', ... 
	'TooltipString', '');

  ACSwindow = struct( ...
      'figure', ACSwindow, ...
      'Label_titulo', Label_titulo, ...
      'btn_closeACS', btn_closeACS, ...
      'btn_Help', btn_Help, ...
      'Image_ACS', Image_ACS, ...
      'btn_runFFwindow', btn_runFFwindow, ...
      'btn_runCDC', btn_runCDC);


  set (btn_closeACS, 'callback', {@btn_closeACS_doIt, ACSwindow});
  set (btn_runFFwindow, 'callback', {@btn_runFFwindow_doIt, ACSwindow});
  set (btn_runCDC, 'callback', {@btn_runCDC_doIt, ACSwindow});
  dlg = struct(ACSwindow);


%
% Main window of traditional advanced control strategies 
%

% global variable
global _basePath;

% Main window image
axes(ACSwindow.Image_ACS);
imshow([_basePath filesep() 'img' filesep() 'acs.png']);
refresh();

% Clear el command Window
clc

%
refresh();








































  ret = ACSwindow;
end

