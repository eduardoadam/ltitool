function ret = runApp()
  [dir, name, ext] = fileparts( mfilename('fullpathext') );
  global _ltitoolBasePath = dir;
  global _ltitoolImgPath = [dir filesep() 'img'];
  addpath([dir filesep() "libs" ]);
  addpath([dir filesep() "fcn" ]);
  addpath([dir filesep() "wnd" ]);
  waitfor(mainWnd().figure);
end
