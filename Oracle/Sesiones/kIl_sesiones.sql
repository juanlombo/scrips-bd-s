+======================================+
| Generar Kill de sesiones por SQL ID  |
+======================================+
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  FROM GV$SESSION  WHERE SQL_ID = 'dun0c8cag3s64';


select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  FROM GV$SESSION  WHERE SQL_ID = 'audfm0sr0gf2d';

SELECT 'ALTER SYSTEM DISCONNECT SESSION ''' || sid || ',' || serial# || ',@' || inst_id || ''' IMMEDIATE;' FROM gv$session WHERE sql_id = 'audfm0sr0gf2d';


+==========================================+
|Generar Kill de sesiones con concurrencia |
+==========================================+
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  from Gv$session where    wait_class in ('Concurrency');

+==========================================+
|   Construir Kill para matar sesiones     |
+==========================================+
ALTER SYSTEM DISCONNECT SESSION '1704,24226' IMMEDIATE;
alter system kill session '6175,30924,@4' immediate;
alter system kill session '51527,1704' immediate;
alter system kill session '1234,16020' immediate;
alter system kill session '242,12234' immediate; 
ALTER SYSTEM KILL SESSION '846,9707'immediate ;



alter system kill session 'SID,serial' immediate;
