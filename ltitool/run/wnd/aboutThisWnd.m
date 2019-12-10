## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} aboutThisWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = aboutThisWnd()
  aboutThisWnd_def;
  wnd = show_aboutThisWnd();
end
