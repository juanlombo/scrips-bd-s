+==============================================================================+
|                           LISTAR TB ESPECIFICO                               |
+==============================================================================+
col "TOTAL MB" form 999,999,999.99  
col "USADO MB" form 999,999,999.99  
col "LIBRE MB" form 999,999,999.99  
col "% Usado" form 9999.9999  
col pct_warn for a10  
SET LINE 200  
SET PAGES 200  
PROMPT Verificando espacio  
select tbs.tablespace_name TABLESPACE,  
tot.bytes/(1024*1024) "TOTAL MB",  
tot.bytes/(1024*1024)-sum(nvl(fre.bytes,0))/(1024*1024) "USADO MB",  
sum(nvl(fre.bytes,0))/(1024*1024) "LIBRE MB",  
(1-sum(nvl(fre.bytes,0))/tot.bytes)*100 "% Usado",  
decode(  
greatest((1-sum(nvl(fre.bytes,0))/tot.bytes)*100, 95),  
95, '', '*'  
) pct_warn  
from dba_free_space fre,  
(select tablespace_name, sum(bytes) bytes  
from dba_data_files  
group by tablespace_name) tot,  
dba_tablespaces tbs  
where tot.tablespace_name = tbs.tablespace_name  
and fre.tablespace_name(+) = tbs.tablespace_name  
and tbs.TABLESPACE_NAME  Like ('%%PSINDEX%')  
group by tbs.tablespace_name, tot.bytes/1024, tot.bytes  
order by "% Usado" desc;

+==================================================================================================+
|                   CONSULTA PARA LISTAR POR TABLESPACE  (Se ejecuta y pide el nombre)             |
+==================================================================================================+
col "TOTAL MB" form 999,999,999.99 
col "USADO MB" form 999,999,999.99 
col "LIBRE MB" form 999,999,999.99 
col "% Usado" form 9999.9999 
col pct_warn for a10 
SET LINE 200 
SET PAGES 200 
PROMPT Verificando espacio 
select tbs.tablespace_name TABLESPACE, 
tot.bytes/(1024*1024) "TOTAL MB", 
tot.bytes/(1024*1024)-sum(nvl(fre.bytes,0))/(1024*1024) "USADO MB", 
sum(nvl(fre.bytes,0))/(1024*1024) "LIBRE MB", 
(1-sum(nvl(fre.bytes,0))/tot.bytes)*100 "% Usado", 
decode( 
greatest((1-sum(nvl(fre.bytes,0))/tot.bytes)*100, 95), 
95, '', '*' 
) pct_warn 
from dba_free_space fre, 
(select tablespace_name, sum(bytes) bytes 
from dba_data_files 
group by tablespace_name) tot, 
dba_tablespaces tbs 
where tot.tablespace_name = tbs.tablespace_name 
and fre.tablespace_name(+) = tbs.tablespace_name 
and tbs.TABLESPACE_NAME  Like ('&1') 
group by tbs.tablespace_name, tot.bytes/1024, tot.bytes 
order by "% Usado" desc;

+==================================================================================================+
|                   LISTAR TODOS LOS TABLESPACE                                                    |
+==================================================================================================+
col "Tablespace" for a22
col "Used MB" for 99,999,999
col "Free MB" for 99,999,999
col "Total MB" for 99,999,999
select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments
group by tablespace_name) tu
where df.tablespace_name = tu.tablespace_name 
order by 5 desc;

---CONSULTA 2
set head on
set feed on
set timing off
col Tablespace form a30
col "Size (M)" form a10
col "Used (M)" form a10
col "Free (M)" form a10
col "Used %" form a10
set line 200
set pages 500
SELECT d.status "Status", d.tablespace_name "Tablespace", d.contents "Type", d.extent_management "Extent Management",
       TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'999999999') "Size (M)",
       TO_CHAR(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024,'999999999')  "Used (M)",
       TO_CHAR(NVL(f.bytes / 1024 / 1024, 0),'999999999')  "Free (M)",
       TO_CHAR(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), '990.00') "Used %"
FROM   sys.dba_tablespaces d, (select tablespace_name, sum(bytes) bytes
                             from   dba_data_files group by tablespace_name) a,
                            (select tablespace_name, sum(bytes) bytes
                             from   dba_free_space group by tablespace_name) f
WHERE d.tablespace_name = a.tablespace_name(+)
AND   d.tablespace_name = f.tablespace_name(+)
AND   NOT (d.extent_management like 'LOCAL'
AND   d.contents like 'TEMPORARY')
UNION ALL
SELECT d.status "Status", d.tablespace_name "Name", d.contents "Type", d.extent_management "Extent Management",
       TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'999999999') "Size (M)",
       TO_CHAR(NVL(t.bytes, 0)/1024/1024,'999999999')  "Used (M)",
       TO_CHAR(NVL(a.bytes - NVL(t.bytes, 0), 0)/1024/1024,'999999999')  "Free (M)",
       TO_CHAR(NVL(t.bytes / a.bytes * 100, 0), '990.00') "Used %"
FROM   sys.dba_tablespaces d, (select tablespace_name, sum(bytes) bytes
                               from dba_temp_files group by tablespace_name) a,
                              (select tablespace_name, sum(bytes_cached) bytes
                               from v$temp_extent_pool group by tablespace_name) t
WHERE  d.tablespace_name = a.tablespace_name(+)
AND    d.tablespace_name = t.tablespace_name(+)
AND    d.extent_management like 'LOCAL'
AND    d.contents like 'TEMPORARY'
order by 8
/

+==================================================================================================+
|                       validar tb temporal                                                        |
+==================================================================================================+
set line 500
set timing off
col file_name for a80
select file_id,file_name,bytes/1024/1024 PESO_MEGAS,autoextensible from dba_temp_files where tablespace_name = upper('&tablespace') order by 3 desc;