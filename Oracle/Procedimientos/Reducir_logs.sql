tail -n 20000 listener_scan1.log > listener_scan1_1.log
cp listener_scan1_1.log listener_scan1.log
rm -rf listener_scan1_1.log
 listener_scan1.log
 
tail -n 20000 listener.log > listener_1.log
cp listener_1.log listener.log
rm -rf listener_1.log

listener_scan1.log
du -sh * 2>/dev/null



du -sh * 2>/dev/null | sort -hr

find . -name "*.xml" -mtime +1 -type f -exec rm -rf {} \;


SHOW PARAMETER audit_trail;


SET LINESIZE 180
SET PAGESIZE 50
SET TRIMSPOOL ON
SET TRIMOUT ON

COLUMN SID FORMAT 9999
COLUMN SERIAL# FORMAT 99999
COLUMN USERNAME FORMAT A15
COLUMN PROGRAM FORMAT A35
COLUMN STATUS FORMAT A10
COLUMN SQL_TEXT FORMAT A70

SELECT s.sid, s.serial#, s.username, s.program, s.status, q.sql_text
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.paddr = (SELECT addr FROM v$process WHERE spid = '335897');



9rcbm2xg7t1rb