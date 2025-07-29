+============================================================================+
|   -- -- -- ----******************revisión de DISKGROUP************-        |
+============================================================================+
SET LINES 200 PAGES 250 
COL OWNER FOR A15 
COL NAME FOR A30 
COL SEGMENT_NAME FOR A20 
COL OFFLINE_DISKS FOR 99 
COL GROUP_NUMBER FOR 99 
SELECT GROUP_NUMBER,NAME,STATE, TYPE, ROUND(TOTAL_MB/1024, 2) TOTAL_GB, ROUND(FREE_MB/1024, 1) FREE_GB, ROUND(USABLE_FILE_MB/1024, 2) USABLE_FILE_GB, ROUND (((TOTAL_MB-USABLE_FILE_MB)*100)/TOTAL_MB,2) AS PCT_USO, OFFLINE_DISKS 
FROM V$ASM_DISKGROUP_STAT 
--WHERE NAME LIKE '%DG_DAT_O%' 
ORDER BY PCT_USO DESC;
+============================================================================+
|                     Revisión ultima secuencia aplicada.                    |
+============================================================================+

set lines 180 
SELECT al.thrd "Hilo", almax "Ultima Seq Recibida", lhmax "Ultima Seq Aplicada", (almax-lhmax) "Diferencia", 
TO_CHAR(fmax,'yyyy-mm-dd hh24:mi:ss') "Fecha aplicado" 
FROM (SELECT THREAD# thrd, MAX(SEQUENCE#) almax 
FROM v$archived_log 
WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) 
GROUP BY THREAD#) al, 
(SELECT THREAD# thrd, MAX(SEQUENCE#) lhmax, MAX(first_time) fmax 
FROM v$log_history 
WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) 
GROUP BY THREAD#) lh 
WHERE al.thrd = lh.thrd;

1.Nos conectamos a GRID
2.NOs conectamos con:
asmcmd
3.Y buscamos la ruta de las piazas actuales
ls
cd RECO1/
ls 
cd CKPRDRP/
ls

-- Comparamos con el script de la ultimna sec. aplicada y revisamos que este la ultima aplicada desdde el asmcmd. Seleccionamos 5 atras y cogemos el numero y lo ponemos en 
-- script siguiente poniendo el nodo en el que esta la píeza 

+============================================================================+
|         -----------********ELIMINACIÓN ARCHIVELOG**********-----           |
+============================================================================+
-- 1.Nos conectamos a la BD
. CKPR.env
-- 2. Nos conectamosrman
rman target/
-- 3.Reorganiza se lanza desde el rman
crosscheck archivelog all;
-- 4.Elimina ultima aplicada desde rman
delete force archivelog until sequence 4353 thread 1;
delete force archivelog until sequence 581440 thread 2;
delete force archivelog until sequence 321816 thread 3;
--delete force archivelog until sequence 217226 thread 4;
----Reorganiza se lanza desde el rman 
crosscheck archivelog all;

*************************************************************************************************************************
-- REVISIÓN DE QUE ESTE PASANDO LOS ARCHIVE AL NUEVO DRP
-- Nos conectamos al pivote luego al nuevo drp que el No. 30 y nos pasamos a oracle
-- Con esta consulta si esta recibiendo piezas el dataguard.
select process,status,client_process,sequence#,block#,active_agents,known_agents from gv$managed_standby;


+RECOC1/CKPRDRP/ARCHIVELOG/




select NAME, PATH from v$asm_disk where GROUP_NUMBER=1 order by 1;
