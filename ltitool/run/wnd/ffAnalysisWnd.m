## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} ffAnalysisWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = ffAnalysisWnd()
  ffAnalysisWnd_def;
  wnd = show_ffAnalysisWnd();
end
