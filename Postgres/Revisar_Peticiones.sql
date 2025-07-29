SELECT *
from public.ct_notificaciones
WHERE estado <> 'CONFIRMADO'
	AND (ct_notificaciones.fecha_actualizacion Is null 
		or ct_notificaciones.fecha_creacion is null)
        	--AND empresas_id = 367
;

##################################################################
--QUERYS LENTAS CUALES SE EJECUTAN MAS, CUANTO TIMEPO CONSUMEN
#################################################################
SELECT
  query,
  calls,
  total_exec_time,
  mean_exec_time,
  rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;

##############################################
#  -- REVISAR PETICINES SOBRE LA BD          #
##############################################
SELECT pid, now() - pg_stat_activity.query_start AS duration, pg_stat_activity.query, pg_stat_activity.state 
FROM pg_stat_activity WHERE pg_stat_activity.state <> 'idle' -- Solo consultas activas AND now() - pg_stat_activity.query_start > interval '30 seconds'

###################################
-- REVISAR BLOQUEOS ENTRE PROCESOS 
###################################
SELECT 
    blocked_locks.pid     AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid    AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_query,
    blocking_activity.query AS blocking_query,
    blocked_activity.query_start AS blocked_since
FROM pg_locks blocked_locks
JOIN pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
    AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
    AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
    AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
    AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
    AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
    AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
    AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;



##########################################
-- Ver estadísticas generales de actividad
##########################################
SELECT 
    datname,
    numbackends AS connections,
    xact_commit,
    xact_rollback,
    blks_read,
    blks_hit,
    tup_returned,
    tup_fetched,
    tup_inserted,
    tup_updated,
    tup_deleted
FROM 
    pg_stat_database
ORDER BY datname;

-- Campos                  clave que estás viendo
-- Columna	                Significado
-- datname	                Nombre de la base de datos.
-- connections	            Número actual de conexiones abiertas a esa base de datos.
-- xact_commit	            Total de transacciones confirmadas (COMMIT).
-- xact_rollback	        Total de transacciones revertidas (ROLLBACK).
-- blks_read	            Cantidad de bloques leídos desde disco.
-- blks_hit	                 Cantidad de bloques leídos desde memoria (cache).
-- tup_returned	            Tuplas (filas) devueltas por consultas SELECT.
-- tup_fetched	            Tuplas leídas mediante cursor o navegación por resultados.
-- tup_inserted	            Total de filas insertadas.
-- tup_updated	            Total de filas actualizadas.
-- tup_deleted	            Total de filas eliminadas.

Puedes calcular el ratio de cache
SELECT 
  datname,
  blks_hit::float / (blks_hit + blks_read) AS cache_hit_ratio
FROM pg_stat_database;




