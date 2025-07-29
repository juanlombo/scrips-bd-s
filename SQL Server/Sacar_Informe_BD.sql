
+================================================================================+
--valdiar INSTANCIA, PUERTO DE ESCUCHA, NOMBRE BD, PESO TOTAL, UbicacionArchivo  | 
+================================================================================+


-- Obtener nombre de instancia y puerto de escucha
DECLARE @Instancia SYSNAME = @@SERVERNAME;
DECLARE @Puerto NVARCHAR(10);

SELECT TOP 1 @Puerto = local_tcp_port
FROM sys.dm_exec_connections 
WHERE session_id = @@SPID;

-- Consulta del inventario de bases de datos
SELECT 
    @Instancia AS Instancia,
    @Puerto AS Puerto,
    db.name AS NombreBD,
    CAST(SUM(mf.size * 8.0 / 1024) AS DECIMAL(10,2)) AS TamañoMB,
    mf.physical_name AS UbicacionArchivo
FROM 
    sys.databases db
JOIN 
    sys.master_files mf ON db.database_id = mf.database_id
GROUP BY 
    db.name, mf.physical_name
ORDER BY 
    db.name;


-- SCRIPT 2 Una columna TipoBD que te muestra si es "System" o "User". Se asegura que database_id esté en el GROUP BY, ya que ahora se usa en el CASE.

-- Obtener nombre de instancia y puerto de escucha
DECLARE @Instancia SYSNAME = @@SERVERNAME;
DECLARE @Puerto NVARCHAR(10);

SELECT TOP 1 @Puerto = local_tcp_port
FROM sys.dm_exec_connections 
WHERE session_id = @@SPID;

-- Consulta del inventario de bases de datos (incluye system databases)
SELECT 
    @Instancia AS Instancia,
    @Puerto AS Puerto,
    db.name AS NombreBD,
    CASE 
        WHEN db.database_id <= 4 THEN 'System'
        ELSE 'User'
    END AS TipoBD,
    CAST(SUM(mf.size * 8.0 / 1024) AS DECIMAL(10,2)) AS TamañoMB,
    mf.physical_name AS UbicacionArchivo
FROM 
    sys.databases db
JOIN 
    sys.master_files mf ON db.database_id = mf.database_id
GROUP BY 
    db.name, db.database_id, mf.physical_name
ORDER BY 
    db.name;




+================================================================================+
|   ----         validar puerto de escucha manualmente                           |
+================================================================================+
1. --Abre SQL Server Configuration Manager.

2. --Ve a:
    --SQL Server Network Configuration → Protocols for <NombreInstancia>

3. --Haz clic derecho en TCP/IP → Properties.

4. --Ve a la pestaña IP Addresses.

5. --Busca IPAll (al final de la lista).

6. --En el campo TCP Port, verás el puerto de escucha.   



	SELECT 
    SERVERPROPERTY('IsClustered') AS EsCluster,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS NodoActivo,
    SERVERPROPERTY('MachineName') AS NombreMaquina,
    SERVERPROPERTY('InstanceName') AS Instancia,
    SERVERPROPERTY('ServerName') AS NombreServidorCompleto;



SELECT  
    qs.execution_count,
    qs.total_elapsed_time / 1000 AS total_elapsed_ms,
    qs.total_elapsed_time / qs.execution_count / 1000 AS avg_elapsed_ms,
    qs.last_execution_time,
    st.text AS query_text
FROM 
    sys.dm_exec_query_stats qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.sql_handle) st
WHERE 
    st.text LIKE '%%' 
    AND qs.last_execution_time >= DATEADD(DAY, -10, GETDATE())
ORDER BY 
    qs.last_execution_time DESC;
