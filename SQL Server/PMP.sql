+===============================================================+
|                     REVISIÓN BACKUPS BD                       |
+===============================================================+
SELECT GETDATE() AS CurrentDateTime;
SELECT DATABASE_NAME as "Base de Datos", CONVERT( VARCHAR(20) ,
MAX(BACKUP_FINISH_DATE)) AS "Último Backup",
DATEDIFF(D, MAX(BACKUP_FINISH_DATE), GETDATE()) AS "Dias sin backup"
FROM MSDB.DBO.BACKUPSET
WHERE TYPE = 'D'
-- and database_name in ('master'
-- ,'tempdb'
-- ,'model'
-- ,'msdb'
-- ,'Sociedad'
-- ,'Fideicomisos'
-- ,'ACFGestionFiduciaria'
-- ,'VarOnline'
-- ,'ACFRepositorioInterfaz'
-- ,'recaudos'
-- ,'FacturAccion'
-- ,'PwpRei')
GROUP BY DATABASE_NAME
ORDER BY 3 DESC
------------------------------------------------------------------------
------------------------------------------------------------------------
SELECT GETDATE() AS HoraActual;
SELECT DATABASE_NAME as "Base de Datos", CONVERT( VARCHAR(20) ,
MAX(BACKUP_FINISH_DATE)) AS "Último Backup",
DATEDIFF(D, MAX(BACKUP_FINISH_DATE), GETDATE()) AS "Dias sin backup"
FROM MSDB.DBO.BACKUPSET
WHERE TYPE = 'D'
GROUP BY DATABASE_NAME
ORDER BY 3 DESC

+===============================================================+
|                     ESTADO DE LAS BD                          |
+===============================================================+
SELECT GETDATE() AS CurrentDateTime;
SELECT name, state_desc, recovery_model FROM sys.databases order by state_desc desc 
-----------------------------------------------------------------------------------
SELECT GETDATE() AS HoraActual;
select name, state_desc, case is_read_only 
when '1' then 'READ_ONLY' 
when '0' then 'READ_WRITE'
end mode from sys.databases

+===============================================================+
|  Script para validar el estado del SQL Server Agent           |
+===============================================================+
DECLARE @service_status INT;

EXEC master.dbo.xp_servicecontrol 'QUERYSTATE', 'SQLServerAgent', @service_status OUTPUT;

IF @service_status = 4
    PRINT '✅ SQL Server Agent está iniciado.';
ELSE
    PRINT '❌ SQL Server Agent NO está iniciado.';

-- xp_servicecontrol es un procedimiento extendido que permite consultar o controlar el estado de los servicios de Windows desde SQL Server.
-- QUERYSTATE devuelve el estado del servicio (ejecutándose, detenido, etc.).
-- El valor 4 representa que el servicio está en estado "Running".

+===============================================================+
|                     reinicio de la instancia                  |
+===============================================================+
SELECT create_date FROM sys.databases WHERE name =  'tempdb';
Select sqlserver_start_time from sys.dm_os_sys_info;

+===============================================================+
|              Revisar peso de BD                               |
+===============================================================+
USE dwdata;
EXEC sp_spaceused;

/u01/app/oracle/product/19.0.0.0/dbhome_1/rdbms/audit


+===============================================================+
|           REVISIÓN EJECUCIÓN DE BACKUP Y DESTINO              |
+===============================================================+
SELECT 
    CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server,
    bs.database_name,
    bs.backup_start_date,
    bs.backup_finish_date,
    bs.expiration_date,
    CASE bs.type 
        WHEN 'D' THEN 'Database' 
        WHEN 'L' THEN 'Log' 
    END AS backup_type,
    bs.backup_size,
    bmf.logical_device_name,
    bmf.physical_device_name,
    bs.name AS backupset_name,
    bs.description
FROM 
    msdb.dbo.backupmediafamily AS bmf
INNER JOIN 
    msdb.dbo.backupset AS bs 
    ON bmf.media_set_id = bs.media_set_id
WHERE 
    CONVERT(DATETIME, bs.backup_start_date, 102) >= GETDATE() - 10 
    -- AND bs.database_name = ''  -- Descomentar y establecer un valor específico si se quiere filtrar por base de datos
ORDER BY  
    bs.database_name, 
    bs.backup_finish_date;


-----SABER EL ORGIEN 


	SELECT TOP 20
    bs.database_name,
    bs.backup_start_date,
    bs.backup_finish_date,
    bs.user_name
FROM msdb.dbo.backupset bs
ORDER BY bs.backup_finish_date DESC;


+===============================================================+
|           modelo de recuperación de la BD                     |
+===============================================================+
SELECT name, recovery_model_desc 
FROM sys.databases;

-- FULL: Soporta backups de transacciones. (Ideal para entornos críticos)
-- SIMPLE: No almacena logs de transacciones (Solo Full y Diferenciales)
-- BULK_LOGGED: Permite backups de transacciones pero con algunas restricciones.

+===============================================================+
|                  configuración de backups                     |
+===============================================================+

SELECT 
    database_name, 
    type, 
    name, 
    recovery_model,
    backup_finish_date, 
    backup_size, 
    backup_start_date, 
    backup_finish_date 
FROM msdb.dbo.backupset 
WHERE database_name = ''
ORDER BY backup_start_date DESC;

-- D → Backup Completo
-- I → Backup Diferencial
-- L → Backup de Transacciones
-- F: Backup de archivos
-- G: Backup diferencial de archivos

SELECT *
  FROM [master].[dbo].[SETI_DBA_CURRENTLYEXEC]

+===============================================================+
|    Validar que no este ningun procesos en ejecucicón          |
+===============================================================+

declare @cmd varchar(500)   
set @cmd='USE ? dbcc opentran()'   
EXECUTE sp_msforeachdb @cmd



select size/128 Tamaño,fileproperty(name,'spaceused')/128 Ocupado,name Nombre, type_desc Tipo, physical_name Ruta_Fisica, state_desc Estado 
from sys.database_files

SELECT 
    size / 128 AS Tamaño,
    FILEPROPERTY(name, 'SpaceUsed') / 128 AS Ocupado,
    name AS Nombre,
    type_desc AS Tipo,
    physical_name AS Ruta_Fisica,
    state_desc AS Estado
FROM 
    sys.database_files
WHERE 
    name = 'FactExcesosGestion_FG202506';


BIProteccionDW BIProteccionDW_V1_logPrimario 83.37%


DBCC SQLPERF(LOGSPACE);

SELECT 
    name AS FileName,
    size * 8 / 1024 AS SizeMB,
    growth,
    is_percent_growth,
    max_size
FROM sys.master_files
WHERE database_id = DB_ID('TuBaseDeDatos');


########################################
#              ELIMNAR BD              #
########################################

USE master;
GO

ALTER DATABASE ExtensaCardio_20250708 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE ExtensaCardio_20250708;
GO
