## -*- texinfo -*-
## @deftypefn  {} {@var{wnd} =} ffWnd ()
##
## Create and show the dialog, return a struct as representation of dialog.
##
## @end deftypefn
function wnd = ffWnd()
  ffWnd_def;
  wnd = show_ffWnd();
end
