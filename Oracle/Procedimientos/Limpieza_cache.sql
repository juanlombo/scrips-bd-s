BEGIN
 FOR filas IN (select username, sid, serial# from v$session 
 where (username like 'U%' and username <> 'U80175316') and osuser = 'weblogic')
 LOOP
 EXECUTE IMMEDIATE 'alter system kill session '''||filas.sid||','||filas.serial#||''' immediate';
 END LOOP;
END;
/

alter system flush buffer_cache global;


-- En cada nodo
alter system flush shared_pool;

--Validar instancia
SET LINES 300 PAGES 900 
SELECT A.INSTANCE_NAME, A.VERSION, A.STARTUP_TIME, A.STATUS, B.OPEN_MODE, A.host_name, B.DATABASE_ROLE FROM V$INSTANCE A, V$DATABASE B;


--proceso de limpieza automatizado en el servidor 200
sh -x /home/oracle/CierreDiarioSeti.sh
cat /tmp/CierreDiarioSeti.log