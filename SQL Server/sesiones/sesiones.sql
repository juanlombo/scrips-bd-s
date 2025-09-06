
exec sp_whoisactive


EXEC sp_WhoIsActive @get_plans = 1;

-- ===================================================
			-- INFORMACIÓN DETALLADA DE LA SESIÓN
-- ===================================================
SELECT * FROM sys.dm_exec_sessions 
WHERE session_id = 80

-- ===================================================
			-- SENTENCIA DEL SQL EN EJECUCIÓN
-- ===================================================
SELECT 
    r.session_id, 
    t.text AS sql_text,
    r.status,
    r.wait_type,
    r.wait_time
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.session_id = 80

-- ===================================================
			-- INFORMACIÓN COMPLETA DE DIAGNOSTICO
-- ===================================================
SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    r.status,
    r.command,
    r.wait_type,
    r.wait_time,
    t.text AS sql_text
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE s.session_id = 80





 *************************************************REVISAR PROCESO 
 // REVISAR AVANCE DEL PROCESO_PROTECCION
 SELECT node_id,physical_operator_name, SUM(row_count) row_count, 
   SUM(estimate_row_count) AS estimate_row_count, 
   CAST(SUM(row_count)*100 AS float)/SUM(estimate_row_count)  
FROM sys.dm_exec_query_profiles   
WHERE session_id=113
GROUP BY node_id,physical_operator_name  
ORDER BY node_id;


################################################
-- saber quién inició esa sesión y desde dónde:
################################################
SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.client_interface_name,
    s.login_time,
    s.last_request_start_time,
    s.last_request_end_time
FROM sys.dm_exec_sessions s
WHERE s.session_id = 89;