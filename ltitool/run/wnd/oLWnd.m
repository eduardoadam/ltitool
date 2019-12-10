## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} oLWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = oLWnd()
  oLWnd_def;
  wnd = show_oLWnd();
end
