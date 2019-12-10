## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cdCSimParamWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cdCSimParamWnd()
  cdCSimParamWnd_def;
  wnd = show_cdCSimParamWnd();
end
