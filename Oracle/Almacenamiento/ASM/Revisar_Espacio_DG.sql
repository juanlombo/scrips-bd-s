+============================================================+
|                     REVISAR DG MB                          |
+============================================================+
set linesize 1500
col name for a20  
select GROUP_NUMBER, NAME, STATE, TYPE, TOTAL_MB, FREE_MB, USABLE_FILE_MB,
    Round((total_mb - usable_file_mb) * 100 / total_mb) "% Used"
from V$ASM_DISKGROUP where STATE = 'CONNECTED';

+============================================================+
|                     REVISAR DG GB                          |
+============================================================+
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

+============================================================+
|                     REVISAR DG POR DISCO                   |
+============================================================+
SET LINES 200
COL GROUP_NAME FORMAT A15
COL DISK_NAME FORMAT A20
COL PATH FORMAT A40
COL STATE FORMAT A15
COL TOTAL_MB FORMAT 99999999
COL FREE_MB FORMAT 99999999
SELECT
    d.GROUP_NUMBER,
    g.NAME AS GROUP_NAME,
    d.DISK_NUMBER,
    d.NAME AS DISK_NAME,
    d.PATH,
    d.STATE,
    d.TOTAL_MB,
    d.FREE_MB
FROM V$ASM_DISK d
LEFT JOIN V$ASM_DISKGROUP g ON d.GROUP_NUMBER = g.GROUP_NUMBER;


SET LINES 200
COL GROUP_NAME FORMAT A15
COL DISK_NAME FORMAT A20
COL PATH FORMAT A40
COL STATE FORMAT A15
COL TOTAL_MB FORMAT 99999999
COL FREE_MB FORMAT 99999999
SELECT
    d.GROUP_NUMBER,
    g.NAME AS GROUP_NAME,
    d.DISK_NUMBER,
    d.NAME AS DISK_NAME,
    d.PATH,
    d.STATE,
    d.TOTAL_MB,
    d.FREE_MB
FROM V$ASM_DISK d
LEFT JOIN V$ASM_DISKGROUP g ON d.GROUP_NUMBER = g.GROUP_NUMBER
WHERE UPPER(g.NAME) = 'DATAC1'
ORDER BY d.DISK_NUMBER;




SET LINES 200
COL GROUP_NAME FORMAT A15
COL DISK_NAME FORMAT A20
COL PATH FORMAT A40
COL STATE FORMAT A15
COL TOTAL_MB FORMAT 99999999
COL FREE_MB FORMAT 99999999
SELECT
    d.GROUP_NUMBER,
    g.NAME AS GROUP_NAME,
    d.DISK_NUMBER,
    d.NAME AS DISK_NAME,
    d.PATH,
    d.STATE,
    d.TOTAL_MB,
    d.FREE_MB
FROM V$ASM_DISK d
LEFT JOIN V$ASM_DISKGROUP g ON d.GROUP_NUMBER = g.GROUP_NUMBER
WHERE g.NAME = 'DATAC1'
ORDER BY d.DISK_NUMBER;




########################################################################
#         Verifica el estado de los archivos temporales:               #
########################################################################


SELECT tablespace_name, file_name, status, bytes/1024/1024 AS size_mb
FROM dba_temp_files;

SELECT FILE#, NAME, CREATION_TIME, STATUS FROM v$tempfile;

############################################
#  Pasar tempfile a onlyne                 #
############################################
 ALTER DATABASE TEMPFILE '+DATA/BCT/85721EC7005C1C99E053E9A412ACF9FA/TEMPFILE/temp.1849.1114687341' ONLINE;


