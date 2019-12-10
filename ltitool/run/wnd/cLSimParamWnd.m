## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cLSimParamWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cLSimParamWnd()
  cLSimParamWnd_def;
  wnd = show_cLSimParamWnd();
end
