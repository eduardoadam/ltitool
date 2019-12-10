## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} cdCAnalysisWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = cdCAnalysisWnd()
  cdCAnalysisWnd_def;
  wnd = show_cdCAnalysisWnd();
end
