## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} newVersionWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = newVersionWnd()
  newVersionWnd_def;
  wnd = show_newVersionWnd();
end
