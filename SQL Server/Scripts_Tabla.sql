

SELECT *
INTO eschema.NombreTabla_Backup
FROM eschema.NombreTablaOriginal;

--Revisar peso tabla 
EXEC sp_spaceused 'SALF.factDiarioAfiliacionRecaudoPO';

--Columna	       Significado
--name	           El nombre de la tabla analizada.
--rows	           Cantidad de filas que hay actualmente en la tabla.
--reserved	       Espacio total reservado para la tabla (suma de datos, índices y espacio no usado).
--data	           Espacio ocupado por los datos de la tabla (las filas propiamente dichas).
--index_size	   Espacio ocupado por los índices definidos en la tabla.
--unused	       Espacio reservado pero que aún no ha sido utilizado.

SELECT *
INTO SALF.factDiarioAfiliacionRecaudoPO_BK_20250507
FROM eschema.NombreTablaOriginal;

+==========================================================+
|-- REVISAR A QUE LE PEGA SINONIMO LE PEGA LA VISTA        |
+==========================================================+



+=============================================+
|     --   Estimar compresión PAGE            |
+=============================================+



+=============================================+
|     --   Estimar compresión PAGE            |
+=============================================+

EXEC sp_estimate_data_compression_savings 
    @schema_name = 'dbo', 
    @object_name = 'CLIENTES_USUARIOS', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'PAGE';


+=============================================+
|  -- Estimar compresión COLUMNSTORE_ARCHIVE  |
+=============================================+

EXEC sp_estimate_data_compression_savings 
    @schema_name = 'dbo', 
    @object_name = 'PERSONAS_USUARIOS', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'COLUMNSTORE_ARCHIVE'; ---o COLUMNSTORE



-- object_name	                                            Nombre del objeto analizado. En este caso, la tabla FactIngresosAfiliados.
-- schema_name	                                            Esquema donde está el objeto. Aquí es INGR.
-- index_id	                                                ID del índice. 1 usualmente indica el índice clustered de la tabla (que es el almacenamiento físico de datos).
-- partition_number	                                        Número de partición. Si la tabla no está particionada, normalmente es 1.
-- size_with_current_compression_setting(KB)	            Tamaño actual del objeto con su configuración de compresión actual (en KB). Aquí: 28,228,368 KB (~26.9 GB).
-- size_with_requested_compression_setting(KB)	            Tamaño estimado si se aplicara COLUMNSTORE_ARCHIVE. Aquí: 22,681,304 KB (~21.6 GB).
-- sample_size_with_current_compression_setting(KB)	        Tamaño de la muestra que se usó para hacer la estimación bajo la configuración actual.
-- sample_size_with_requested_compression_setting(KB)	    Tamaño estimado para esa misma muestra si se usara COLUMNSTORE_ARCHIVE.







