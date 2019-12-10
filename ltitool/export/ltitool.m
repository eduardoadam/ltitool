## -*- texinfo -*-
## @deftypefn  {} {@var{ret} =} ltitool ()
##
## Create and show the main dialog, return a struct as representation of dialog.
##
## @end deftypefn
function ret = ltitool()
  [dir, name, ext] = fileparts( mfilename('fullpathext') );
  global _ltitoolBasePath = dir;
  global _ltitoolImgPath = [dir filesep() 'img'];
  addpath( [dir filesep() "img" ]);
  addpath( [dir filesep() "fcn" ]);
  addpath( [dir filesep() "libs" ]);
  addpath( [dir filesep() "wnd" ]);
  mainWnd();
end
