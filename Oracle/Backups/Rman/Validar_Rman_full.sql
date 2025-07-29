+======================================+
|   --VALIDAR ejecución Backup--Rman   |       
+======================================+
set timing off
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';
set timing off
SET LINESIZE 80 HEADING OFF FEEDBACK OFF
select
RPAD('   FECHA CONSULTA       : ' || (select sysdate from dual)  , 80 ) ||
RPAD('   BASE DE DATOS        : ' || (select db_unique_name from v$database)  , 80 )
from dual;
set head on
set feed on
set timing on
COLUMN fecha_inicio                    FORMAT a12           HEADING 'Fecha|Inicio'               ENTMAP off
COLUMN hora_inicio                     FORMAT a10           HEADING 'Hora|Inicio'                ENTMAP off
COLUMN tiempo_tomado                   FORMAT a10           HEADING 'Tiempo|Tomado'              ENTMAP off
COLUMN Estado                          FORMAT a12           HEADING 'Estado'                     ENTMAP off
COLUMN Tipo                            FORMAT a12           HEADING 'Tipo'                       ENTMAP off
COLUMN dispositivo                     FORMAT a12           HEADING 'Dispositivo'                ENTMAP off
COLUMN Tam_Entrada                     FORMAT a12           HEADING 'Tamano|Entrada'             ENTMAP off
COLUMN Tam_Salida                      FORMAT a12           HEADING 'Tamano|Salida'              ENTMAP off

set lines 200
set pages 300
break on Fecha_Inicio
SELECT
   TO_CHAR(r.start_time, 'YYYY-MM-DD')       fecha_inicio
  ,TO_CHAR(r.start_time, 'HH24:MI:SS')       hora_inicio
  , r.time_taken_display                     tiempo_tomado
  , substr(r.status,1,25)                    estado
  , r.input_type                             tipo
  , rpad(r.output_device_type,11,chr(126))   dispositivo
  , lpad(r.input_bytes_display,11,chr(126))  tam_entrada
  , lpad(r.output_bytes_display,11,chr(126)) tam_salida
FROM
    (select command_id, start_time, time_taken_display, status, input_type, output_device_type, input_bytes_display, output_bytes_display, output_bytes_per_sec_display
     from v$rman_backup_job_details
     order by start_time DESC
    ) r
WHERE r.start_time > sysdate - 8
/


+======================================+
|            Ver Errro                 |       
+======================================+
select
output
from
v$rman_output;

+======================================+
|  Validar procesos de BK sqlplus      |       
+======================================+
SELECT SID, SERIAL#, STATUS, PROGRAM FROM V$SESSION WHERE PROGRAM LIKE '%rman%';

+======================================+
|  CONSULTAR BK RMAN Y ARCHIVE         |       
+======================================+
SELECT start_time, status, input_type
FROM v$rman_backup_job_details
ORDER BY start_time DESC;

+====================================================================+
|  ejecutar el siguiente query para obtener el session_recid         |       
+====================================================================+
SET LINES 300
col fecha_inicio format a12
col hora_inicio format  a12
col tiempo_tomado for a20
col Estado for a25
col Tipo for a15
col dispositivo for a11
col Tam_Entrada for a11
col Tam_Salida  for a11
SELECT SESSION_RECID, to_char(r.start_time, 'YYYY-MM-DD')fecha_inicio,to_char(r.start_time, 'HH24:MI:SS')hora_inicio
       ,r.time_taken_display tiempo_tomado,substr(r.status,1,25)  estado, r.input_type tipo, rpad(r.output_device_type,11,chr(126))   dispositivo
       , lpad(r.input_bytes_display,11,chr(126))  tam_entrada, lpad(r.output_bytes_display,11,chr(126)) tam_salida 
  FROM (select   SESSION_RECID, command_id, start_time, time_taken_display, status, input_type, output_device_type, input_bytes_display, output_bytes_display
               , output_bytes_per_sec_display from v$rman_backup_job_details order by start_time DESC) r WHERE rownum < 30;


+======================================+
|  consultar el session_recid          |       
+======================================+
select output
from v$rman_output
where session_recid = 15762
order by recid ;


+====================================================================+
|       CONSULTAR DIRECTORIO EN EL SISTEMA DE ARCHIVOS               |       
+====================================================================+
SELECT directory_name, directory_path FROM dba_directories WHERE directory_name = 'DISK_BACKUP_CTRLFILE';

+====================================================================+
|              PROGRESO DETALLADO DEL BACKUP                         |
+====================================================================+
SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE", 
       TIME_REMAINING, OPNAME, TARGET 
FROM V$SESSION_LONGOPS 
WHERE OPNAME LIKE 'RMAN%' AND TOTALWORK != 0 AND SOFAR != TOTALWORK;
