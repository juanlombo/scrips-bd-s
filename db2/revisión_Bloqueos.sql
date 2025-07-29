+===============================================================================================+
|                                 REVISIÓNDE BLOQUEOS EN BD2                                    |
+===============================================================================================+

/*    AMBIENTES   */
db2inst2 = Replica 
db2inst1 = productiva

+=======================================+
|           ver bloqueos                |
+=======================================+

db2top  ---tecla U para ingresar a la lista de bloqueo
Si hay bloqueo --L  mirar la cabecera del bloqueo
a--- para mirar el SID boqueante 
+=======================================+
|tomamos el id de la cabeza del bloqueo |
+=======================================+
db2top--a
/* pegamos el id*/
/* vemos la sentencia que ejecuta la sesión */
/* y si tenemos autorización finalizamos la sesión */
db2 "force application (56915)" 


+=======================================+
|            conectarse a la BD         |
+=======================================+
db2 connect to SCOPRD

Coge esa la verde copia el número
 
Te sales de ahí le das db2top de nuevo y luego a