## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} ghWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = ghWnd()
  ghWnd_def;
  wnd = show_ghWnd();
end
