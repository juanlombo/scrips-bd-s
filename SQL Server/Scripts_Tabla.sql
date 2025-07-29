

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






+===============================================================+
|   --Analiza una tabla y sugiere el tipo de compresión válido  |
+===============================================================+

DECLARE @schema_name SYSNAME = 'DW';
DECLARE @table_name SYSNAME = 'SaldoAfiliadosModeloProductos'; -- cambia el nombre aquí

-- Verifica si tiene índices columnstore
IF EXISTS (
    SELECT 1
    FROM sys.indexes i
    INNER JOIN sys.objects o ON i.object_id = o.object_id
    WHERE o.name = @table_name
      AND SCHEMA_NAME(o.schema_id) = @schema_name
      AND i.type_desc LIKE '%COLUMNSTORE%'
)
BEGIN
    PRINT '✅ La tabla tiene índice COLUMNSTORE. Puedes usar: COLUMNSTORE o COLUMNSTORE_ARCHIVE';
END
ELSE
BEGIN
    -- Verifica si tiene columnas sparse o tipos no compatibles con compresión
    IF EXISTS (
        SELECT 1
        FROM sys.columns c
        INNER JOIN sys.objects o ON c.object_id = o.object_id
        WHERE o.name = @table_name
          AND SCHEMA_NAME(o.schema_id) = @schema_name
          AND (
              c.is_sparse = 1
              OR c.system_type_id IN (
                  34, 35, 99, 241, -- image, text, ntext, xml
                  165,             -- timestamp
                  98               -- sql_variant
              )
          )
    )
    BEGIN
        PRINT '⚠️ La tabla tiene columnas sparse o tipos no compatibles. No se recomienda aplicar ROW ni PAGE compression.';
    END
    ELSE
    BEGIN
        PRINT '✅ La tabla puede usar: ROW o PAGE compression (almacenamiento por filas)';
    END
END



=============================
/*PARA VARIAS TABLAS*/
============================

DECLARE @Tables TABLE (
    SchemaName SYSNAME,
    TableName SYSNAME
);

-- Inserta las tablas a evaluar
INSERT INTO @Tables (SchemaName, TableName)
VALUES
('DW',   'SaldoAfiliadosModeloProductos'),
('ASE',  'AuxAsesoriaAfiliadosProducto_Historico'),
('ICON', 'FactDetalleDeudasMeta'),
('PLA',  'FactEncabezadoPlantillas'),
('ICON', 'FactDetalleDeudas'),
('DW',   'FactValorFondoPO'),
('COB',  'FactEstrategiaCobro_tmp'),
('DW',   'DimExtensionAfiliados'),
('AUX',  'AuxHitoricosAsignacionAfiliados');

DECLARE @schema_name SYSNAME, @table_name SYSNAME;

DECLARE table_cursor CURSOR FOR
SELECT SchemaName, TableName FROM @Tables;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '--------------------------------------------------';
    PRINT '🔍 Tabla: ' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@table_name);

    -- Verifica si tiene índices columnstore
    IF EXISTS (
        SELECT 1
        FROM sys.indexes i
        INNER JOIN sys.objects o ON i.object_id = o.object_id
        WHERE o.name = @table_name
          AND SCHEMA_NAME(o.schema_id) = @schema_name
          AND i.type_desc LIKE '%COLUMNSTORE%'
    )
    BEGIN
        PRINT '✅ Tiene índice COLUMNSTORE → Puedes usar: COLUMNSTORE o COLUMNSTORE_ARCHIVE';
    END
    ELSE
    BEGIN
        -- Verifica columnas no compatibles con ROW/PAGE compression
        IF EXISTS (
            SELECT 1
            FROM sys.columns c
            INNER JOIN sys.objects o ON c.object_id = o.object_id
            WHERE o.name = @table_name
              AND SCHEMA_NAME(o.schema_id) = @schema_name
              AND (
                  c.is_sparse = 1
                  OR c.system_type_id IN (
                      34, 35, 99, 241, -- image, text, ntext, xml
                      165,             -- timestamp
                      98               -- sql_variant
                  )
              )
        )
        BEGIN
            PRINT '⚠️ Tiene columnas SPARSE o tipos no compatibles → No se recomienda ROW/PAGE';
        END
        ELSE
        BEGIN
            PRINT '✅ Puedes usar: ROW o PAGE compression';
        END
    END

    FETCH NEXT FROM table_cursor INTO @schema_name, @table_name;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;
