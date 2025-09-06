***********************************MYSQL

======================================================================================================================
-- 												*************BLOQUEOS**********
======================================================================================================================
SELECT
    pl.id,
    pl.user,
    pl.state,
    it.trx_id,
    it.trx_mysql_thread_id,
    it.trx_query AS query,
    it.trx_id AS blocking_trx_id,
    it.trx_mysql_thread_id AS blocking_thread,
    it.trx_query AS blocking_query
FROM information_schema.processlist AS pl
INNER JOIN information_schema.innodb_trx AS it
    ON pl.id = it.trx_mysql_thread_id
INNER JOIN information_schema.innodb_lock_waits AS ilw
    ON it.trx_id = ilw.requesting_trx_id
    AND it.trx_id = ilw.blocking_trx_id;



SELECT
    r.trx_id AS waiting_trx_id,
    r.trx_mysql_thread_id AS waiting_thread,
    r.trx_query AS waiting_query,
    b.trx_id AS blocking_trx_id,
    b.trx_mysql_thread_id AS blocking_thread,
    b.trx_query AS blocking_query
FROM information_schema.innodb_lock_waits w
JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id
JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id;






/* PARA VERSIONES SUPERUIORES */
SELECT
  ilw.waiting_trx_id,
  ilw.waiting_pid    AS waiting_thread,
  ilw.waiting_query,
  ilw.blocking_trx_id,
  ilw.blocking_pid   AS blocking_thread,
  ilw.blocking_query
FROM sys.innodb_lock_waits AS ilw;




======================================================================================================================
-- 												----****CONEXIONES ACTIVAS****-	
======================================================================================================================	
show status where variable_name = 'Threads_connected';

======================================================================================================================
-- 										----****MAXIMO DE CONEXIONES***---
======================================================================================================================	
show variables like "max_connections";

======================================================================================================================
-- 										HOSTNAME
======================================================================================================================
show variables like 'hostname';

======================================================================================================================
-- 										-----hostname,basedir,datadir
======================================================================================================================
SELECT @@hostname, @@basedir, @@datadir;

======================================================================================================================
-- 								-- revisar sesiones y proceso.
======================================================================================================================
SHOW PROCESSLIST;

======================================================================================================================
-- 									-- kill a sesiones de usuario especifico
======================================================================================================================
SELECT CONCAT('KILL ', ID, ';') 
FROM INFORMATION_SCHEMA.PROCESSLIST 
WHERE USER ='yair';

======================================================================================================================
-- 									---Revisar tiempo de conexión activa
======================================================================================================================
SHOW VARIABLES LIKE 'wait_timeout';

======================================================================================================================
-- 									-- modificar tiempo wait 
======================================================================================================================
*** SET GLOBAL wait_timeout = 300; -- 5 minutos


======================================================================================================================
-- 									-- BUSCAR SENTENCIAS COSTOSAS
======================================================================================================================
SELECT 
    query AS statement,
    exec_count AS execution_count,
    total_latency / 1000000000 AS total_time_seconds,
    avg_latency / 1000000000 AS avg_time_seconds,
    db
FROM 
    sys.x$statements_with_runtimes_in_95th_percentile 
WHERE 
    db = 'digistock' ---- Cambiar bd a la que queremos buscar
    AND query LIKE 'SELECT%' --- tipo de DDL
ORDER BY 
    total_time_seconds DESC
LIMIT 5;


-- Conexiones dormidas que no se cierran
SELECT id, user, host, time
FROM information_schema.processlist
WHERE command='Sleep' AND time > @@wait_timeout
ORDER BY time DESC;

-- Consultas activas y lentas
SELECT id, user, host, db, time, state, LEFT(info,200) AS sql_sample
FROM information_schema.processlist
WHERE command <> 'Sleep'
ORDER BY time DESC
LIMIT 50;

-- Errores de conexión / picos recientes
SHOW GLOBAL STATUS LIKE 'Aborted_connects';
SHOW GLOBAL STATUS LIKE 'Connections';
SHOW GLOBAL STATUS LIKE 'Connection_errors_%';



SELECT * FROM sys.host_summary ORDER BY current_connections DESC;
SELECT * FROM sys.user_summary ORDER BY current_connections DESC;
SELECT * FROM sys.processlist ORDER BY time DESC LIMIT 50;


-- Solo consultas con más de 5 segundos de ejecución
SELECT id, user, host, db, time, state, LEFT(info,200) AS query_sample
FROM information_schema.processlist
WHERE command <> 'Sleep'
  AND time > 5
ORDER BY time DESC;
