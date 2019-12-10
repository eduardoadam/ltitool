## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cLLoadDataWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cLLoadDataWnd()
  cLLoadDataWnd_def;
  wnd = show_cLLoadDataWnd();
end
