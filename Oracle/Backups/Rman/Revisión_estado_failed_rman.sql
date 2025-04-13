/*******************+   ATENCION   ALERTA [D1] ESTADO FAILED RMAN full - kcv0063  ********************************/

ejecutar el siguiente query para obtener el session_recid:

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
 

/************   consultar el session_recid   ********************/

select output
from v$rman_output
where session_recid = 1835521
order by recid ;

-- Estas estan en el nodo2 de bct prod
cat /home/oracle/seti/crontab/monitoreo/rman_failed/valida_failed_incr.txt
cat monitor_rman_failed_incr.sh