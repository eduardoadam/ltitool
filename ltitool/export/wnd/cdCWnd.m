## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cdCWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cdCWnd()
  cdCWnd_def;
  wnd = show_cdCWnd();
end
