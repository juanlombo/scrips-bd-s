+================================================================================+
|                    --      REVISIÓN DE GAP                                     |
+================================================================================+
	SET LINES 800 
	SET PAGESIZE 10000 
	BREAK ON REPORT 
	COMPUTE SUM LABEL TOTAL OF GAP ON REPORT 
	select primary.thread#, 
	primary.maxsequence primaryseq, 
	standby.maxsequence standbyseq, 
	primary.maxsequence - standby.maxsequence gap 
	from ( select thread#, max(sequence#) maxsequence 
	from v$archived_log 
	where archived = 'YES' 
	and resetlogs_change# = ( select d.resetlogs_change# from v$database d ) 
	group by thread# order by thread# ) primary, 
	( select thread#, max(sequence#) maxsequence 
	from v$archived_log 
	where applied = 'YES' 
	and resetlogs_change# = ( select d.resetlogs_change# from v$database d ) 
	group by thread# order by thread# ) standby 
	where primary.thread# = standby.thread#;

+================================================================================+
|               --     REVISIÓN ULTIMA SECUENCIA APLICADA                        |
+================================================================================+
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

+======================================================+
|-----      VALIDAR DATAGUARD CRIOLLO                  |
+======================================================+
 set lines 500 
SELECT al.thrd "Hilo", lhmax "Ultima Seq Aplicada", 
TO_CHAR(fmax,'yyyy-mm-dd hh24:mi:ss') "Fecha aplicado" 
FROM (SELECT THREAD# thrd, MAX(SEQUENCE#) almax 
FROM v$archived_log 
WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) 
GROUP BY THREAD#) al, 
(SELECT THREAD# thrd, MAX(SEQUENCE#) lhmax, MAX(first_time) fmax FROM v$log_history 
WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) 
GROUP BY THREAD#) lh 
      WHERE al.thrd = lh.thrd;

+================================================================================+
|            --       CONSULTA GAP, MRPO, TIEMPO SIN APLICAR                     |
+================================================================================+
SET LINES 800
SET PAGESIZE 10000
BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF GAP ON REPORT
select primary.thread#,
       primary.maxsequence primaryseq,
       standby.maxsequence standbyseq,
       primary.maxsequence - standby.maxsequence gap
from ( select thread#, max(sequence#) maxsequence
       from v$archived_log
       where archived = 'YES'
         and resetlogs_change# = ( select d.resetlogs_change# from v$database d )
       group by thread# order by thread# ) primary,
     ( select thread#, max(sequence#) maxsequence
       from v$archived_log
       where applied = 'YES'
         and resetlogs_change# = ( select d.resetlogs_change# from v$database d )
       group by thread# order by thread# ) standby
where primary.thread# = standby.thread#;
 
 
set linesize 1000
column name format a25
column value format a30
column TIME_COMPUTED format a20
column DATUM_TIME format a20
 
select NAME,VALUE,UNIT,TIME_COMPUTED,DATUM_TIME
from v$dataguard_stats
order by name
/
set pagesize 100
 
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM GV$MANAGED_STANDBY
ORDER BY 1,3,4
/

+================================================================================+
|         --  Ultima recibida ultima aplicada de los archive                     |
+================================================================================+
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

+================================================================================+
|            --   REVISIÓN ALTA GENERACION DE ARCHIVE                            |
+================================================================================+
set pages 600
set lines 500
col day form a8
col 00 form a5
col 01 form a5
col 02 form 
col 03 form a5
col 04 form a5
col 05 form a5
col 06 form a5
col 07 form a5
col 08 form a5
col 09 form a5
col 10 form a5
col 11 form a5
col 12 form a5
col 13 form a5
col 14 form a5
col 15 form a5
col 16 form a5
col 17 form a5
col 18 form a5
col 19 form a5
col 20 form a5
col 21 form a5
col 22 form a5
col 23 form a5
select to_char(first_time,'MM-DD') day,to_char(sum(decode(to_char(first_time,'hh24'),'00',1,0)),'9999') "00",to_char(sum(decode(to_char(first_time,'hh24'),'01',1,0)),'9999') "01",to_char(sum(decode(to_char(first_time,'hh24'),'02',1,0)),'9999') "02",to_char(sum(decode(to_char(first_time,'hh24'),'03',1,0)),'9999') "03",to_char(sum(decode(to_char(first_time,'hh24'),'04',1,0)),'9999') "04",to_char(sum(decode(to_char(first_time,'hh24'),'05',1,0)),'9999') "05",to_char(sum(decode(to_char(first_time,'hh24'),'06',1,0)),'9999') "06",to_char(sum(decode(to_char(first_time,'hh24'),'07',1,0)),'9999') "07",to_char(sum(decode(to_char(first_time,'hh24'),'08',1,0)),'9999') "08",to_char(sum(decode(to_char(first_time,'hh24'),'09',1,0)),'9999') "09",to_char(sum(decode(to_char(first_time,'hh24'),'10',1,0)),'9999') "10",to_char(sum(decode(to_char(first_time,'hh24'),'11',1,0)),'9999') "11",to_char(sum(decode(to_char(first_time,'hh24'),'12',1,0)),'9999') "12",to_char(sum(decode(to_char(first_time,'hh24'),'13',1,0)),'9999') "13",to_char(sum(decode(to_char(first_time,'hh24'),'14',1,0)),'9999') "14",to_char(sum(decode(to_char(first_time,'hh24'),'15',1,0)),'9999') "15",to_char(sum(decode(to_char(first_time,'hh24'),'16',1,0)),'9999') "16",to_char(sum(decode(to_char(first_time,'hh24'),'17',1,0)),'9999') "17",to_char(sum(decode(to_char(first_time,'hh24'),'18',1,0)),'9999') "18",to_char(sum(decode(to_char(first_time,'hh24'),'19',1,0)),'9999') "19",to_char(sum(decode(to_char(first_time,'hh24'),'20',1,0)),'9999') "20",to_char(sum(decode(to_char(first_time,'hh24'),'21',1,0)),'9999') "21",to_char(sum(decode(to_char(first_time,'hh24'),'22',1,0)),'9999') "22",to_char(sum(decode(to_char(first_time,'hh24'),'23',1,0)),'9999') "23"
from v$log_history
where first_time between sysdate-15 and  sysdate
group by to_char(first_time,'MM-DD')order by 1;

-- Log history
set lines 200
col name for a70
col first_change# for 99999999999999
col next_change# for 999999999999999
alter session set nls_date_format='DD-MON-RRRR HH24:MI:SS';
select * from v$log_history;

+================================================================================+
|       --                   SUICHEO ---SCRIOT VANE                              |
+================================================================================+

set pages 600
set lines 500
col day form a8
col 00 form a5
col 01 form a5
col 02 form a5
col 03 form a5
col 04 form a5
col 05 form a5
col 06 form a5
col 07 form a5
col 08 form a5
col 09 form a5
col 10 form a5
col 11 form a5
col 12 form a5
col 13 form a5
col 14 form a5
col 15 form a5
col 16 form a5
col 17 form a5
col 18 form a5
col 19 form a5
col 20 form a5
col 21 form a5
col 22 form a5
col 23 form a5
select to_char(first_time,'MM-DD') day,
to_char(sum(decode(to_char(first_time,'hh24'),'00',1,0)),'9999') "00",
to_char(sum(decode(to_char(first_time,'hh24'),'01',1,0)),'9999') "01",
to_char(sum(decode(to_char(first_time,'hh24'),'02',1,0)),'9999') "02",
to_char(sum(decode(to_char(first_time,'hh24'),'03',1,0)),'9999') "03",
to_char(sum(decode(to_char(first_time,'hh24'),'04',1,0)),'9999') "04",
to_char(sum(decode(to_char(first_time,'hh24'),'05',1,0)),'9999') "05",
to_char(sum(decode(to_char(first_time,'hh24'),'06',1,0)),'9999') "06",
to_char(sum(decode(to_char(first_time,'hh24'),'07',1,0)),'9999') "07",
to_char(sum(decode(to_char(first_time,'hh24'),'08',1,0)),'9999') "08",
to_char(sum(decode(to_char(first_time,'hh24'),'09',1,0)),'9999') "09",
to_char(sum(decode(to_char(first_time,'hh24'),'10',1,0)),'9999') "10",
to_char(sum(decode(to_char(first_time,'hh24'),'11',1,0)),'9999') "11",
to_char(sum(decode(to_char(first_time,'hh24'),'12',1,0)),'9999') "12",
to_char(sum(decode(to_char(first_time,'hh24'),'13',1,0)),'9999') "13",
to_char(sum(decode(to_char(first_time,'hh24'),'14',1,0)),'9999') "14",
to_char(sum(decode(to_char(first_time,'hh24'),'15',1,0)),'9999') "15",
to_char(sum(decode(to_char(first_time,'hh24'),'16',1,0)),'9999') "16",
to_char(sum(decode(to_char(first_time,'hh24'),'17',1,0)),'9999') "17",
to_char(sum(decode(to_char(first_time,'hh24'),'18',1,0)),'9999') "18",
to_char(sum(decode(to_char(first_time,'hh24'),'19',1,0)),'9999') "19",
to_char(sum(decode(to_char(first_time,'hh24'),'20',1,0)),'9999') "20",
to_char(sum(decode(to_char(first_time,'hh24'),'21',1,0)),'9999') "21",
to_char(sum(decode(to_char(first_time,'hh24'),'22',1,0)),'9999') "22",
to_char(sum(decode(to_char(first_time,'hh24'),'23',1,0)),'9999') "23"
from gv$log_history                                       
where first_time between sysdate-15 and  sysdate
group by to_char(first_time,'MM-DD')
order by 1;

+=======================================+
| --   REVISAR UANTO PESAN LOS REDOLOG  |
+=======================================+
select bytes/1024/1024 bytes from v$log;

+=======================================+
--------*******pasar a read only 
+=======================================+
ALTER PLUGGABLE DATABASE PMODULA OPEN READ ONLY;

+=======================================+
| -- REVISAR HASTA QUE HORAS APLICO      |
+=======================================+
SELECT
TO_CHAR(CURRENT_SCN) AS current_scn_value,
SCN_TO_TIMESTAMP(CURRENT_SCN) AS current_scn_timestamp
FROM v$database;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+================================================================================+
|         --                REVISIÓN MRPO EN EL QUE ESTA                         |
+================================================================================+
SELECT inst_id, process, status FROM gv$managed_standby WHERE process = 'MRP0';
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY ORDER BY 1,3,4;

+================================================================================+
|         --              SUBIR MRPO O BAJAR                                     |
+================================================================================+
------BAJAR
	alter database recover managed standby database cancel;
	
	------SUBIR con redos cuando son muy transaccionales 
	ALTER SYSTEM SET RECOVERY_PARALLELISM = 4 SCOPE=BOTH;
	alter database recover managed standby database using current logfile disconnect from session;
	
	------SUBIR CON ARCHIVE
	alter database recover managed standby database disconnect from session;
	alter database recover managed standby database disconnect parallel 4 using current logfile;

+================================================================================+
|         --              revisión log history                                   |
+================================================================================+ 
set lines 200
col name for a70
col first_change# for 99999999999999
col next_change# for 999999999999999
alter session set nls_date_format='DD-MON-RRRR HH24:MI:SS';
select * from v$log_history;	

+======================================================+
|--                   REVISIÓN DRP                     |
+======================================================+
--  CONECTAR BD
. CMODULA.env
--  ESTADO DEL DRP
srvctl status database -d CSOADRP
-- DETENER DRP
srvctl stop database -d CSOADRP
--  INICIAR DRP
srvctl start database -d CSOADRP

+======================================================+
|--             revisar si esta mounted                |
+======================================================+
set linesize 1500
col name for a20
col OPEN_MODE for a20
col OPEN_TIME for a35
col CREATE_SCN for 99999999
col RECOVERY_STATUS for a20
col LOCAL_UNDO for 99999999
select INST_ID, CON_ID, NAME, OPEN_MODE, OPEN_TIME, CREATE_SCN, RECOVERY_STATUS, LOCAL_UNDO from gv$pdbs;

+======================================================+
|--       ---*****DG donde se almacena                |
+======================================================+
SELECT l.group#, l.status, f.member 
FROM v$log l 
JOIN v$logfile f ON l.group# = f.group#;

SHOW PARAMETER log_archive_dest;


-- Consulta 2: Obtener información de diagnóstico
SELECT 
    value 
FROM 
    V$DIAG_INFO;



/oracle/app/oracle/diag/rdbms/bctstby/bctstby/trace

/oracle/app/oracle/diag/rdbms/bctstby/bctstby/trace





LIST BACKUP OF ARCHIVELOG SEQUENCE 422453 THREAD 1;
cd ../49858144
ls 49774593_BCT_jh3kkq1k_1_1
cd ../49871446
ls 49774593_BCT_jh3kkq1k_1_1
cd ../49872512
ls 49774593_BCT_jh3kkq1k_1_1
cd ../49864722
ls 49774593_BCT_jh3kkq1k_1_1
cd ../49859044
ls 49774593_BCT_jh3kkq1k_1_1
cd ../49873102
ls 49774593_BCT_jh3kkq1k_1_1
cd ../49873510
ls 49774593_BCT_jh3kkq1k_1_1
run
{
configure channel device type 'sbt_tape' PARMS="SBT_LIBRARY=/opt/commvault/Base/libobk.so,ENV=(BACKUP_DIR=/restore/49873510,CV_media=FILE)";
catalog device type 'sbt_tape' backuppiece
'49752871_BCT_gi3kj1pe_1_1';
}
RESTORE ARCHIVELOG SEQUENCE 420143 THREAD 1;
RESTORE ARCHIVELOG FROM SEQUENCE 420117 UNTIL SEQUENCE 420167 THREAD 1;
select PROCESS,STATUS,THREAD#,SEQUENCE# from GV$MANAGED_STANDBY where PROCESS = 'MRP0';




/u02/app/oracle/diag/rdbms/csoadg/CSOA1/trace


/u02/app/oracle/diag/rdbms/csoadg/CSOA2/trace