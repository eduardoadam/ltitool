## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} mainWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = mainWnd()
  mainWnd_def;
  wnd = show_mainWnd();
end
