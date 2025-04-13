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
