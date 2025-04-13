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