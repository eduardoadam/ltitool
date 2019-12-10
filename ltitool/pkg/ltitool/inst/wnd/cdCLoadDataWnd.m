## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cdCLoadDataWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cdCLoadDataWnd()
[_dir, _name, _ext] = fileparts( mfilename('fullpathext') );
global _ltitoolBasePath = strtrunc(_dir, length(_dir) - 4);
global _ltitoolImgPath = [ strtrunc(_dir, length(_dir) - 4) filesep() 'img'];
  cdCLoadDataWnd_def;
  wnd = show_cdCLoadDataWnd();
end
