## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cLWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cLWnd()
  cLWnd_def;
  wnd = show_cLWnd();
end
