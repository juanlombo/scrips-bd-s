+==============================================================+
-- |   EJECUCIÓN MANTENIMEINTO DE LISTA DE PRECIOS             |
+==============================================================+
-- INGRESAMOS AL NODO 3 DE BCT A LA SIGUIENTE RUTA
cd home/oracle/seti/mantenimiento
cd seti/mantenimiento

-- Y EJECUTAMOS LA SH DE LA SIGUEINTE MANERA 
nohup sh Estadistica_TBL_Lista_Precio.sh & 

-- Monitoreamos e informamos por whatsap cuando inicia y cuando finaliza 
tail -20f Lista_Precio_bct3.txt