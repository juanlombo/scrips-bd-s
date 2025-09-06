--Versión actual
SELECT version();

--Verificar configuración archive
-- Verificar si la archivación WAL está activa
SHOW archive_mode;

-- Verificar el comando de archivación configurado
SHOW archive_command;

-- Verificar últimos WAL archivados
SELECT * FROM pg_stat_archiver;

-- Fecha de ultimo backup exitoso
SELECT name, size, modification 
FROM pg_ls_waldir() 
ORDER BY modification DESC 
LIMIT 10;

-- Verificar configuración actual
SELECT name, setting, unit, context, vartype, source, min_val, max_val
FROM pg_settings
WHERE name IN (
    'shared_buffers', 'work_mem', 'maintenance_work_mem', 
    'effective_cache_size', 'max_connections',
    'checkpoint_timeout', 'checkpoint_completion_target',
    'wal_buffers', 'random_page_cost', 'effective_io_concurrency'
);


--
Buenas prácticas de configuración:
shared_buffers: 25-40% de RAM en sistemas dedicados

work_mem: 4MB-64MB dependiendo de cargas de trabajo complejas

maintenance_work_mem: 10% de RAM (para operaciones como VACUUM)

max_connections: Ajustar según necesidad (usar pool de conexiones para altas cargas)

--
RENDIMIENTO
--Consultas lentas
SELECT query, calls, total_time, mean_time, rows
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 20;
--Si no funciona, instalr (CREATE EXTENSION pg_stat_statements;)

SELECT pid, usename, query_start, query 
FROM pg_stat_activity 
WHERE state = 'active' AND query != '';

--Uso de índices
SELECT schemaname, relname, seq_scan, idx_scan, 
       100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used
FROM pg_stat_user_tables
WHERE seq_scan + idx_scan > 0
ORDER BY percent_of_times_index_used;

-- Fragmentación tablas e índices
-- Instalar la extensión primero si es necesario: CREATE EXTENSION pgstattuple;
SELECT
    current_database(),
    schemaname,
    tablename,
    pg_size_pretty(real_size) AS real_size,
    pg_size_pretty(extra_size) AS extra_size,
    round(extra_size::numeric * 100 / greatest(real_size, 1), 2) AS bloat_pct
FROM (
    SELECT
        schemaname,
        tablename,
        pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)) AS real_size,
        pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)) - 
        pg_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)) AS extra_size
    FROM
        pg_tables
    WHERE
        schemaname NOT IN ('pg_catalog', 'information_schema')
) t
WHERE
    extra_size > 0
ORDER BY
    bloat_pct DESC
LIMIT 20;

--Estado auto Vacuum
SELECT relname, 
       last_vacuum, last_autovacuum, 
       last_analyze, last_autoanalyze,
       vacuum_count, autovacuum_count,
       analyze_count, autoanalyze_count
FROM pg_stat_user_tables;

--Seguridad 
--Roles y privilegios
SELECT grantee, table_catalog, privilege_type, table_schema, table_name
FROM information_schema.role_table_grants
WHERE grantee NOT IN ('postgres', 'PUBLIC');

-- Conexiones activas
SELECT datname, usename, application_name, client_addr, 
       state, query, query_start, backend_start
FROM pg_stat_activity
WHERE state = 'active';

-- Capacidad y crecimiento
--Tamaño base de datos
SELECT datname, pg_size_pretty(pg_database_size(datname)) as size
FROM pg_database
ORDER BY pg_database_size(datname) DESC;

--Crecimiento historico
-- Necesita la extensión pg_stat_statements
SELECT datname, stats_reset
FROM pg_stat_database;


