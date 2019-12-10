## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cdCLoadDataWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cdCLoadDataWnd()
  cdCLoadDataWnd_def;
  wnd = show_cdCLoadDataWnd();
end
