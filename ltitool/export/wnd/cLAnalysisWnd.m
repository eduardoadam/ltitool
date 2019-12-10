## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cLAnalysisWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cLAnalysisWnd()
  cLAnalysisWnd_def;
  wnd = show_cLAnalysisWnd();
end
