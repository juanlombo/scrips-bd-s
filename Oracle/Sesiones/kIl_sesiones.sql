+======================================+
| Generar Kill de sesiones por SQL ID  |
+======================================+
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  FROM GV$SESSION  WHERE SQL_ID = '5s3m966n0jpqm';


select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  FROM GV$SESSION  WHERE SQL_ID = '5dvthm42n2cuq';

SELECT 'ALTER SYSTEM DISCONNECT SESSION ''' || sid || ',' || serial# || ',@' || inst_id || ''' IMMEDIATE;' FROM gv$session WHERE sql_id = '7t8z2j3qmv3xn';


+==========================================+
|Generar Kill de sesiones con concurrencia |
+==========================================+
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  from Gv$session where    wait_class in ('Concurrency');


SELECT 'ALTER SYSTEM KILL SESSION ''' || sid || ',' || serial# || ',@' || inst_id || ''' IMMEDIATE;' FROM gv$session 
WHERE 
    wait_class IN ('Concurrency')
    AND UPPER(username) = 'DEVELOP'
    AND type <> 'BACKGROUND'
    AND username IS NOT NULL
    AND username NOT IN ('SYS', 'SYSTEM');


+==========================================+
|   Construir Kill para matar sesiones     |
+==========================================+
ALTER SYSTEM DISCONNECT SESSION '1704,24226' IMMEDIATE;
alter system kill session '6175,30924,@4' immediate;
alter system kill session '1086,32783' immediate;
alter system kill session '1234,16020' immediate;
alter system kill session '242,12234' immediate; 
ALTER SYSTEM KILL SESSION '846,9707'immediate ;



alter system kill session 'SID,serial' immediate;
