## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} ffLoadDataWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = ffLoadDataWnd()
  ffLoadDataWnd_def;
  wnd = show_ffLoadDataWnd();
end
