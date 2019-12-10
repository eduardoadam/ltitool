## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} optimalPIDWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = optimalPIDWnd()
  optimalPIDWnd_def;
  wnd = show_optimalPIDWnd();
end
