## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} aCSWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = aCSWnd()
  aCSWnd_def;
  wnd = show_aCSWnd();
end
