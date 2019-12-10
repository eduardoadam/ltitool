## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} addiToolWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = addiToolWnd()
  addiToolWnd_def;
  wnd = show_addiToolWnd();
end
