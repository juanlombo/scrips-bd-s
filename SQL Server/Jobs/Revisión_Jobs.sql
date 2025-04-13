-- REVISIÓN QUE JOB LLAMA A OTRO JOB 


--Se ejecuta primero esto
use msdb
go
--Luego colocamos el nombre del Job que necesitamos saber quien lo llama
select * from sysjobsteps where command like '%Carga BI - Modelo Trazabilidad%'
--El select anterior nos muestra el nombre del job que es llamado y un job_id con un codigo que pertenece 
-- al job que lo invoca. 
--Con el siguiente select podemos saber el nombre del job modificando el job_id por el que necesitamos
select name from sysjobs where job_id = '2D65859C-E98B-4FBF-8C8E-92DE2CB4F4D1'
Carga BI - Afiliación Digital



-----****Revisar que hace la sigueinte consulta
select size/128 Tamaño,fileproperty(name,'spaceused')/128 Ocupado,name Nombre, type_desc Tipo, physical_name Ruta_Fisica, state_desc Estado 
from sys.database_files
 
 
+===========================================================+
|--          Identificar el Job y los Pasos                 |
+===========================================================+
SELECT j.job_id, j.name AS JobName, s.step_id, s.step_name, s.command, s.database_name
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobsteps s ON j.job_id = s.job_id
WHERE j.name = 'Carga BI - Modelo Aportes Afiliados';

+===========================================================+
|     -- Capturar el script de ejecución en el Paso 7       |
+===========================================================+
SELECT step_id, command, database_name
FROM msdb.dbo.sysjobsteps
WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = 'Carga BI - Modelo Aportes Afiliados')
AND step_id = 7;


-- Capturar el comando del paso 7
SELECT step_id, command
FROM msdb.dbo.sysjobsteps
WHERE job_id = (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = 'Carga BI - Modelo Aportes Afiliados')
AND step_id =7;

-- Consulta directa de detalles del JOB
SELECT 
    j.job_id,
    j.name AS job_name,
    js.step_id,
    js.step_name,
    js.subsystem,
    js.command
FROM msdb.dbo.sysjobs j
JOIN msdb.dbo.sysjobsteps js ON j.job_id = js.job_id
WHERE j.job_id = 0x93B9836ED668314CB84AADD91B734EAE



