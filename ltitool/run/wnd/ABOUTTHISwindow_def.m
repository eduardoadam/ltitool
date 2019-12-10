%
% Set the graphics toolkit and force read this file as script file (not a function file).
%
graphics_toolkit qt;
%


%
%
% Begin callbacks definitions 
%

function btn_closeABOUTTHIS_doIt(source, callbackdata, ABOUTTHISwindow)


  % Close window
  close(dlg.ABOUTTHISwindow);
end

 
%
% Dialog creation windows function 
%
function ret = show_ABOUTTHISwindow()
  _scrSize = get(0, "screensize");
  _xPos = (_scrSize(3) - 728)/2;
  _yPos = (_scrSize(4) - 438)/2;
   ABOUTTHISwindow = figure ( ... 
	'Color', [0.961 0.965 0.969], ...
	'Position', [_xPos _yPos 728 438], ...
	'Resize', 'on', ...
	'windowstyle', 'normal', ...
	'MenuBar', 'none');
  btn_closeABOUTTHIS = uicontrol( ...
	'parent',ABOUTTHISwindow, ... 
	'Style','pushbutton', ... 
	'Units', 'pixels', ... 
	'BackgroundColor', [0.961 0.965 0.969], ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [610 11 90 22], ... 
	'String', 'Close', ... 
	'TooltipString', '');
  aboutthis_Image = axes( ...
	'Units', 'pixels', ... 
	'parent',ABOUTTHISwindow, ... 
	'FontAngle', 'normal', ... 
	'FontName', 'Ubuntu', ... 
	'FontSize', 11, 'FontUnits', 'points', ... 
	'FontWeight', 'normal', ... 
	'Position', [57 42 550 372]);

  ABOUTTHISwindow = struct( ...
      'figure', ABOUTTHISwindow, ...
      'btn_closeABOUTTHIS', btn_closeABOUTTHIS, ...
      'aboutthis_Image', aboutthis_Image);


  set (btn_closeABOUTTHIS, 'callback', {@btn_closeABOUTTHIS_doIt, ABOUTTHISwindow});
  dlg = struct(ABOUTTHISwindow);


%
% Additional tools main window
%

% global variable
global _basePath;

% Main window image
axes(ABOUTTHISwindow.aboutthis_Image);
imshow([_basePath filesep() 'img' filesep() 'aboutthis.png']);
refresh();

% Clear el command Window
clc

%
refresh();








































  ret = ABOUTTHISwindow;
end

