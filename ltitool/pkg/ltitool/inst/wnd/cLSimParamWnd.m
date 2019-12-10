## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cLSimParamWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cLSimParamWnd()
[_dir, _name, _ext] = fileparts( mfilename('fullpathext') );
global _ltitoolBasePath = strtrunc(_dir, length(_dir) - 4);
global _ltitoolImgPath = [ strtrunc(_dir, length(_dir) - 4) filesep() 'img'];
  cLSimParamWnd_def;
  wnd = show_cLSimParamWnd();
end
