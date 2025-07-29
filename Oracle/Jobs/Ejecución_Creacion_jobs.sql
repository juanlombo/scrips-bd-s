+============================================================================+
|    ---                           CREAR UN JOB                              |
+============================================================================+
BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'MI_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN mi_procedimiento(); END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => NULL,  -- Si es un job único, deja este parámetro como NULL
    enabled         => TRUE
  );
END;
/

+============================================================================+
|    ---               Ejecutar el Job Manualmente                           |
+============================================================================+
BEGIN
  DBMS_SCHEDULER.RUN_JOB(job_name => 'JOB_PROCEDURE_MANT_BCT');
END;
/

+============================================================================+
|    ---               Ejecutar el Job Manualmente en backgroud              |
+============================================================================+
-- Evita que la sesión se bloquee esperando la ejecución del job.
BEGIN
  DBMS_SCHEDULER.RUN_JOB(job_name => 'BCT_KOBA.JOB_PROCEDURE_MANT_BCT', use_current_session => FALSE);
END;
/

BEGIN
  DBMS_SCHEDULER.RUN_JOB(job_name => 'BCT_NATIVA.P_ARCHIVAR_TRANSACTIONXML', use_current_session => FALSE);
END;
/


+============================================================================+
|    ---               CAMBIAR DE ESQUEMA                                    |
+============================================================================+
ALTER SESSION SET CURRENT_SCHEMA = BCT_KOBA;


+============================================================================+
|    ---                 HABILITAR UN JOB                                    |
+============================================================================+
BEGIN
 DBMS_SCHEDULER.enable(name=>'"BCT_NATIVA"."P_VAL_ENCOLA"');
 END;
 /

+============================================================================+
|    ---       DESACTIVAR LA EJECUCIÓN DEL JOB                               |
+============================================================================+
 begin
 DBMS_SCHEDULER.disable(name=>'"BCT_NATIVA"."P_VAL_ENCOLA"', force => TRUE);
 end;
 /

+============================================================================+
|    ---       Verificar la Ejecución y Monitorear el Job                    |
+============================================================================+

col OWNER for a20
col JOB_NAME for a40
col LOG_DATE for a30
set line 300

SELECT job_name, status, actual_start_date, run_duration
FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE job_name IN ('JOB_PROCEDURE_MANT_BCT','P_ARCHIVAR_TRANSACTIONXML');
ORDER BY actual_start_date DESC;

SELECT job_name, status, actual_start_date, run_duration
FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE job_name = 'JOB_PROCEDURE_MANT_BCT'
ORDER BY actual_start_date DESC;

select owner, job_name,job_type,next_run_date,STATE from dba_scheduler_jobs 
where owner in ('BCT_NATIVA','BCT_KOBA') and job_name in ('P_ARCHIVAR_TRANSACTIONXML','JOB_PROCEDURE_MANT_BCT') 
order by next_run_date desc

-- DBA_SCHEDULER_JOB_RUN_DETAILS: Para ver el historial de ejecución.
-- DBA_SCHEDULER_JOBS: Para verificar la configuración y el estado actual de los jobs.
 
 SELECT ENABLED
 from dba_scheduler_jobs
 where JOB_NAME='JOB_PROCEDURE_MANT_BCT';

-- Jobs en ejecución 
 select * from user_scheduler_jobs where state = 'RUNNING';


+=========================================================+
-- |  ************CONSULTAR ESTADO DEL JOB si estan en running
+=========================================================+

SELECT job_name, state, enabled
FROM dba_scheduler_jobs
WHERE job_name IN ('clearing');


+============================================================================+
|    ---             REVISAR QUE JOBS FALLARON                               |
+============================================================================+
 col OWNER for a20
col JOB_NAME for a40
col LOG_DATE for a30
set line 300
SELECT job_name, status, error#, log_id, errors, TO_CHAR(log_date, 'DD-MON-YYYY HH24:MI:SS') AS log_date
FROM dba_scheduler_job_run_details
WHERE status = 'FAILED'
ORDER BY log_date DESC;

-- ========================================================
--                REVISAR ERROR DEL JOB 
-- ========================================================
SET LONG 10000;
SET LONGCHUNKSIZE 10000;
SET LINESIZE 300;
COLUMN ADDITIONAL_INFO FORMAT A200;
COLUMN ERROR# FORMAT 999999;
COLUMN ERRORS FORMAT A200;

SELECT LOG_ID, LOG_DATE, STATUS, ERROR#, ERRORS
FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE JOB_NAME = 'JOB_FE_CONCILIA'
AND STATUS = 'FAILED'
ORDER BY LOG_DATE DESC;

-- ========================================================
--                CODIGO ESPECIFICO DEL JOB (Puede que ejecute algun procedimeinto de almacenado)
-- ========================================================
SELECT JOB_ACTION 
FROM DBA_SCHEDULER_JOBS 
WHERE JOB_NAME = 'JOB_FE_CONCILIA';



+============================================================================+
|    ---        Programar Ejecuciones Recurrentes:                           |
+============================================================================+
BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'MI_JOB_DIARIO',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN mi_procedimiento(); END;',
    start_date      => TO_TIMESTAMP('2025-04-03 07:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    repeat_interval => 'FREQ=DAILY; BYHOUR=7; BYMINUTE=0; BYSECOND=0',
    enabled         => TRUE
  );
END;
/

