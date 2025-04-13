+======================================+
| Generar Kill de sesiones por SQL ID  |
+======================================+
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  FROM GV$SESSION  WHERE SQL_ID = '69y4dncyzk6uz';

+==========================================+
|Generar Kill de sesiones con concurrencia |
+==========================================+
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;'  from Gv$session where    wait_class in ('Concurrency')

+==========================================+
|   Construir Kill para matar sesiones     |
+==========================================+
ALTER SYSTEM DISCONNECT SESSION '2501,24226' IMMEDIATE;
alter system kill session '6175,30924,@4' immediate;
alter system kill session '635,107' immediate;
alter system kill session '1234,16020' immediate;
alter system kill session '242,12234' immediate; 

