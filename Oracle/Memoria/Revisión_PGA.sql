-- Verifica el límite actual de PGA
SHOW PARAMETER pga_aggregate_limit;

-- Revisar cuánto PGA se está utilizando actualmente
SELECT name, ROUND(value / 1024 / 1024, 2) AS value_mb
FROM     v$pgastat
WHERE name IN (
'total PGA inuse',
'total PGA allocated',
'aggregate PGA target parameter',
'aggregate PGA auto target',
'over allocation count' );

---- Revisar % de uso referente al limite 
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



-- Identificar sesiones con alto consumo de PGA
SELECT s.sid, s.serial#, p.pga_used_mem / 1024 / 1024 AS pga_used_mb, s.sql_id, 
    s.status, s.program 
FROM v$process p 
JOIN v$session s ON p.addr = s.paddr 
WHERE p.pga_used_mem > 100 * 1024 * 1024   -- sesiones con más de 100MB de PGA
ORDER BY pga_used_mb DESC;

-- Identificar sesiones con alto consumo de PGA
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
FROM table(DBMS_XPLAN.DISPLAY_CURSOR('749915dgnypsk', NULL, 'ALLSTATS LAST'));


-- Identificar quien esta usando mas PGA 
SELECT s.username, s.program, ROUND(p.pga_used_mem / 1024 / 1024, 2) AS pga_used_mb
FROM  v$session s
JOIN v$process p ON s.paddr = p.addr
WHERE p.pga_used_mem > 50 * 1024 * 1024
ORDER BY pga_used_mb DESC;


---



SQL_ID  7wf2advyctpfb, child number 0
-------------------------------------
select distinct ordnum en_otra_carga    from (Select ordnum
From Ord_Line           Where Sales_Ordnum = :var_no_ped
And Client_Id = :var_client_id             and prtnum = :var_articulo
       Union          Select ordnum            From Ord_Line
Where Sales_Ordnum = :var_no_ped             And Client_Id =
:var_client_id             and prtnum = :var_articulo)   where ordnum
<> :var_ordnum


SQL_ID  749915dgnypsk, child number 0
-------------------------------------
delete USR_TMP_CONFIABILI_CNT a  
Where a.wh_id = nvl(:1 ,:2 )

