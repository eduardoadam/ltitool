## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} ffSimParamWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = ffSimParamWnd()
  ffSimParamWnd_def;
  wnd = show_ffSimParamWnd();
end
