#  function [vNum desc] = checkVersion(url)
#  
#  Comprueba la versión actual de una aplicación a través de verificar la dirección
#  indicada a través del parámetro url. Este parámetro debe ser una ruta válida, por
#  ejemplo "http://localhost/octave/index.php".
#  La página web indicada deberá retornar (separado por  |:|) el número 
#  de versión de la aplicación y una descripción de la misma.
#  A modo de ejemplo, se indica la estructura de una página web con la estructura requerida
# <?php
# header('Content-Type:text/plain');
# #Indique la descripción de la versión
# $desc = "En esta versión se corrigen varios problemas, entre ellos: \n";
# $desc = $desc . "- Utiliza dólares en vez de pesos para referirse a la moneda \n";
# $desc = $desc . "- Utiliza nafta común en vez de premium";
# # Número de versión
# $ver = "1.0.1";
# echo $ver . "|:|" .  $desc;
# ?>
#
function [vNum desc] = checkVersion(url)
  vNum = 0;
  desc = '';  
  [s ok] = urlread(url);
  if(ok)
    r = strsplit(s, '|:|');
    if(length(r) == 2)
      vNum = r{1,1};
      desc = r{1,2};
    endif
  endif
endfunction