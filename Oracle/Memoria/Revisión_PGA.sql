-- Verifica el límite actual de PGA
SHOW PARAMETER pga_aggregate_limit;

+====================================================+
-- Revisar cuánto PGA se está utilizando actualmente
+====================================================+
SELECT name, ROUND(value / 1024 / 1024, 2) AS value_mb
FROM     v$pgastat
WHERE name IN (
'total PGA inuse',
'total PGA allocated',
'aggregate PGA target parameter',
'aggregate PGA auto target',
'over allocation count' );

+================================================+
---- Revisar % de uso referente al limite 
+================================================+
SELECT
    ROUND(total_pga_inuse / 1024 / 1024, 2) AS total_pga_inuse_mb,
    ROUND(pga_limit / 1024 / 1024, 2) AS pga_limit_mb,
    ROUND((total_pga_inuse / pga_limit) * 100, 2) AS pct_usage
FROM (
    SELECT
        (SELECT value FROM v$pgastat WHERE name = 'total PGA inuse') AS total_pga_inuse,
        (SELECT value FROM v$parameter WHERE name = 'pga_aggregate_limit') AS pga_limit
    FROM dual
);


+================================================+
-- Identificar sesiones con alto consumo de PGA
+================================================+
SELECT s.sid, s.serial#, p.pga_used_mem / 1024 / 1024 AS pga_used_mb, s.sql_id, 
    s.status, s.program 
FROM v$process p 
JOIN v$session s ON p.addr = s.paddr 
WHERE p.pga_used_mem > 100 * 1024 * 1024   -- sesiones con más de 100MB de PGA
ORDER BY pga_used_mb DESC;

+================================================+
-- Identificar sesiones con alto consumo de PGA
+================================================+
set lines 900
col USERNAME form a30
col PROGRAM form a40
SELECT 
    s.sid,
    s.serial#,
    s.sql_id,
    --sa.sql_text,
    s.username,
    p.program,
    ROUND(p.pga_used_mem / 1024 / 1024, 2) AS pga_used_mb,
    ROUND(p.pga_alloc_mem / 1024 / 1024, 2) AS pga_allocated_mb
FROM  v$session s
JOIN  v$process p ON s.paddr = p.addr
LEFT JOIN v$sql sa ON s.sql_id = sa.sql_id
WHERE s.username IS NOT NULL 
 AND s.status = 'ACTIVE'
ORDER BY  p.pga_used_mem DESC
FETCH FIRST 10 ROWS ONLY;



SELECT * 
FROM table(DBMS_XPLAN.DISPLAY_CURSOR('ddn9147nacgrc', NULL, 'ALLSTATS LAST'));

+========================================+
-- Identificar quien esta usando mas PGA 
+========================================+
SELECT s.username, s.program, ROUND(p.pga_used_mem / 1024 / 1024, 2) AS pga_used_mb
FROM  v$session s
JOIN v$process p ON s.paddr = p.addr
WHERE p.pga_used_mem > 50 * 1024 * 1024
ORDER BY pga_used_mb DESC;


---

+========================================+
|       Consumo de la SGA                |
+========================================+
COLUMN pool FORMAT A20
COLUMN total_mb FORMAT 999,999,999
COLUMN free_mb  FORMAT 999,999,999
COLUMN used_mb  FORMAT 999,999,999
COLUMN pct_used FORMAT 999.99
SELECT pool,
       ROUND(total/1024/1024) total_mb,
       ROUND((total-free)/1024/1024) used_mb,
       ROUND(free/1024/1024) free_mb,
       ROUND((total-free)*100/total,2) pct_used
FROM (
    SELECT pool,
           SUM(bytes) total,
           SUM(CASE WHEN name LIKE '%free%' THEN bytes ELSE 0 END) free
    FROM v$sgastat
    GROUP BY pool
);


-- El shared pool está al 76% → saludable (ideal <80-85%).

-- El buffer cache (fila sin nombre) está al 100%: esto es normal, Oracle siempre usa todo el buffer cache y va reciclando bloques. No es problema.

-- El large pool al 80%: está justo en el límite, ojo si haces RMAN con muchos canales o operaciones paralelas.

-- El streams pool está libre (no lo estás usando).




+========================================+
|   REVISAR MEMORIA DEL SERVER   |  
+========================================+
free -m -w
grep -i memavailable /proc/meminfo
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head

# Ver total y disponible (para calcular el % real)
awk '/MemTotal|MemAvailable/ {print}' /proc/meminfo

# Uso total de memoria (RSS) por GoldenGate en MB
ps -eo rss,cmd | awk '/gg-source21|gg-target21/ {sum+=$1} END {printf "OGG RSS ~%.1f MB\n", sum/1024}'

# Swap y presión
free -m -w
vmstat 1 5
