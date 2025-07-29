+======================================+
|     Consultar sesiones activas       |
+======================================+
col inst_id format 999
col username format  a15
col sid format 999999
col serial# format 999999999
col Minutos format 999999999
col WAIT_CLASS format a13
col event format a30
col machine format a30
col osuser format a20
set lines 500
set pages 100
select inst_id, username, sid, serial#, round(last_call_et/60) Min, WAIT_CLASS, event, machine,sql_id
from gv$session
where status = 'ACTIVE' 
and username<>'SYS'
and username is not null  
--and username not in('SETIADMIN', 'DBSNMP', ---------##'SYSMAN','GGS_OWNER','GGS_OWNER_2','GGS_OWNER02')
order by last_call_et asc, 1,2   
/

-- CONSULTA 2

col inst_id format 999 
col username format a15 
col sid format 999999 
col serial# format 999999999 
col Minutos format 999999999 
col WAIT_CLASS format a13 
col event format a40 
col machine format a30 
col osuser format a20 
set lines 500 
set pages 100 
select inst_id, username,OSUSER, sid, serial#, status, round(last_call_et/60) Min, WAIT_CLASS, event, machine,sql_id 
from gv$session 
where STATUS='ACTIVE' 
and username not in('SYS','SYSTEM') 
order by last_call_et desc, 1,2 
/ 
select username Usuario_Oracle, count (username) Numero_Sesiones from gv$session where STATUS = 'ACTIVE' group by username order by Numero_Sesiones desc;


+======================================+
|  CONSULTAR SESIONES Y USUARIOS SYS   |
+======================================+
col inst_id format 999
col username format  a15
col sid format 999999
col serial# format 999999999
col Minutos format 999999999
col WAIT_CLASS format a13
col event format a30
col machine format a30
col osuser format a20
set lines 500
set pages 100
select inst_id, username, sid, serial#, round(last_call_et/60) Min, WAIT_CLASS, event, machine,sql_id
from gv$session
where status = 'ACTIVE' 
and username<>'SYS'
and username is not null  
--and username not in('SETIADMIN', 'DBSNMP', ---------##'SYSMAN','GGS_OWNER','GGS_OWNER_2','GGS_OWNER02')
order by last_call_et asc, 1,2   
/

+======================================+
|     Consultar sesiones ZF            |
+======================================+
col inst_id format 999    
col username format a20    
col sid format 999999    
col serial# format 999999999    
col WAIT_CLASS format a13    
col event format a30    
col machine format a25    
col osuser format a12
col status format a12
col service_name format a12  
set lines 500    
set pages 100    
select inst_id, service_name, username,osuser, sid, serial#, status, round(last_call_et/60) Min, WAIT_CLASS, event, machine,sql_id    
from gv$session    
where status='ACTIVE'    
and username is not null
--and USERNAME = 'ESB_SAP'   
and username <> 'SYS'    
order by last_call_et DESC, 1,2    
/

+======================================+
|     Consultar sesiones iNACTIVAS     |
+======================================+
col inst_id format 999
col username format  a15
col sid format 999999
col serial# format 999999999
col Minutos format 999999999
col WAIT_CLASS format a13
col event format a30
col machine format a30
col osuser format a20
set lines 500
set pages 100
select inst_id, username, sid, serial#, round(last_call_et/60) Min, WAIT_CLASS, event, machine,sql_id
from gv$session
where status = 'INACTIVE' 
and username<>'SYS'
and username is not null  
--and username not in('SETIADMIN', 'DBSNMP', ---------##'SYSMAN','GGS_OWNER','GGS_OWNER_2','GGS_OWNER02')
order by last_call_et asc, 1,2   
/

+======================================+
|        REVISAR SESIONES SYS          |
+======================================+

SELECT inst_id, username, osuser, sid, serial#, status,
       ROUND(last_call_et / 60) AS Minutos,
       wait_class, event, machine, sql_id
FROM gv$session
WHERE status = 'ACTIVE'
  AND username IN ('SYS') -- o solo 'SYS' 
ORDER BY last_call_et DESC, inst_id, username;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+======================================+
|     REVISAR QUE EJECUTA EL SQL ID    |
+======================================+
set linesize 1500
col sql_id for 9999999
col sql_text for a100
select sql_id, sql_text from v_$sql where sql_id in ('4qr0mp15rgwcf');

+======================================+
|     REVISAR QUE EJECUTA EL SID       |
+======================================+
SELECT a.sql_text 
FROM gv$sqltext a, 
gv$session b 
WHERE a.address = b.sql_address 
AND a.hash_value = b.sql_hash_value and b.sid=2564; and b.INST_ID=2
ORDER BY a.piece;

+======================================+
| REVISAR QUE EJECUTA EL SID O SPID    |
+======================================+
SET LINESIZE 80 HEADING OFF FEEDBACK OFF
SELECT
  RPAD('USERNAME : ' || s.username, 80) ||
  RPAD('OSUSER   : ' || s.osuser, 80) ||
  RPAD('PROGRAM  : ' || s.program, 80) ||
  RPAD('SPID     : ' || p.spid, 80) ||
  RPAD('SID      : ' || s.sid, 80) ||
  RPAD('SERIAL#  : ' || s.serial#, 80) ||
  RPAD('MACHINE  : ' || s.machine, 80) ||
  RPAD('TERMINAL : ' || s.terminal, 80) ||
  RPAD('SQL ID   : ' || q.sql_id, 80) ||
  RPAD('SQL TEXT : ' || q.sql_text, 1000)
FROM v$session s
    ,v$process p
    ,v$sql     q
WHERE s.paddr          = p.addr
AND   s.sid           = '1713'
AND   s.sql_address    = q.address(+)
AND   s.sql_hash_value = q.hash_value(+);


+======================================+
| REVISAR QUE EJECUTA EL SID           |
+======================================+
SET LINESIZE 80 HEADING OFF FEEDBACK OFF
SELECT
  RPAD('USERNAME : ' || s.username, 80) ||
  RPAD('OSUSER   : ' || s.osuser, 80) ||
  RPAD('PROGRAM  : ' || s.program, 80) ||
  RPAD('SPID     : ' || p.spid, 80) ||
  RPAD('SID      : ' || s.sid, 80) ||
  RPAD('SERIAL#  : ' || s.serial#, 80) ||
  RPAD('MACHINE  : ' || s.machine, 80) ||
  RPAD('TERMINAL : ' || s.terminal, 80) ||
  RPAD('SQL ID   : ' || q.sql_id, 80) ||
  RPAD('SQL TEXT : ' || q.sql_text, 1000)
FROM v$session s
    ,v$process p
    ,v$sql     q
WHERE s.paddr          = p.addr
AND   p.spid           = '8635'
AND   s.sql_address    = q.address(+)
AND   s.sql_hash_value = q.hash_value(+);
+======================================+
|         REVISAR BLOQUEOS             |
+======================================+
set line 700 pages 0 feed off 
set serveroutput on size 20000 
DECLARE 
CURSOR c1 is select * from gv$lock where request != 0 order by id1, id2; 
wid1             number := -999999; 
wid2             number := -999999; 
wholder_detail   varchar2(500); 
sentenciaLock    varchar2(4000); 
v_err_msg        varchar2(80); 
wsid             number(5); 
wstep            number(2); 
wthread          number(2); 
wtype            varchar2(10); 
wobject_name     varchar2(180); 
wobject_name1    varchar2(80); 
wlock_type       varchar2(50); 
w_lastcallet     varchar2(11); 
h_lastcallet     varchar2(11); 
procesoId        varchar2(12); 
usuarioBD        varchar2(30); 
sidID            number; 
threadID         number; 
existe           number; 
BEGIN 
  FOR c1_rec in c1 LOOP 
     IF c1_rec.id1 = wid1 and c1_rec.id2 = wid2 
       THEN 
          null; 
       ELSE 
          wstep  := 10; 
          SELECT sid , type , inst_id 
   INTO wsid , wtype ,wthread 
            FROM gv$lock 
           WHERE id1  = c1_rec.id1 
             AND id2  = c1_rec.id2 
             AND request = 0 
             AND lmode != 4 
             AND rownum<=1 ; 
          DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------------'); 
          wstep  := 20; 
          SELECT 'SESION BLOQUEANTE: THREAD:0'||s.inst_id|| 
                 ' DBUSER:'||upper (s.username) || 
                 ' SPID:'||p.spid|| 
                 ' SID:'||s.sid|| 
                 ' SERIAL:'||s.serial#|| 
                 ' STATUS:'||upper (s.status)|| 
                 ' (' || floor(last_call_et/3600)||':'||floor(mod(last_call_et,3600)/60)||':'||mod(mod(last_call_et,3600),60) ||')'|| 
                 ' MACHINE:' ||upper (substr(replace(machine,'LOCALHOST',null),1,30)) 
                 , p.spid 
                 , s.sid   
            INTO wholder_detail, procesoId, sidID 
            FROM gv$session s, gv$process p 
           WHERE s.sid = wsid 
    AND s.inst_id = wthread 
             AND s.paddr = p.addr 
             AND s.inst_id = p.inst_id 
             AND rownum <= 1; 
          DBMS_OUTPUT.PUT_LINE(wholder_detail); 
          BEGIN 
             DBMS_OUTPUT.PUT_LINE('  '); 
             SELECT decode(wtype,'TX', 'Transaction', 
                                 'DL', 'DDL Lock', 
                                 'MR', 'Media Recovery', 
                                 'RT', 'Redo Thread', 
                                 'UN', 'User Name', 
                                 'TM', 'DML', 
                                 'UL', 'PL/SQL User Lock', 
                                 'DX', 'Distributed Xaction', 
                                 'CF', 'Control File', 
                                 'IS', 'Instance State', 
                                 'FS', 'File Set', 
                                 'IR', 'Instance Recovery', 
                                 'ST', 'Disk Space Transaction', 
                                 'TS', 'Temp Segment', 
                                 'IV', 'Library Cache Invalida-tion', 
                                 'LS', 'Log Start or Switch', 
                                 'RW', 'Row Wait', 
                                 'SQ', 'Sequence Number', 
                                 'TE', 'Extend Table', 
                                 'TT', 'Temp Table', 
                                 'Un-Known Type of Lock') 
               INTO wlock_type 
               FROM dual; 
             DECLARE 
             CURSOR c3 IS SELECT object_id FROM gv$locked_object WHERE session_id = wsid; 
             BEGIN 
                wobject_name := ''; 
                FOR c3_rec in c3 LOOP 
                   SELECT object_type||' '||owner||'.'||object_name 
                     INTO wobject_name 
                     FROM dba_objects 
                     WHERE object_id = c3_rec.object_id; 
                   wobject_name := wobject_name ||' '||wobject_name1; 
                END LOOP; 
                EXCEPTION 
                WHEN OTHERS THEN 
                wobject_name := wobject_name ||' No Object Found'; 
             END; 
             DBMS_OUTPUT.PUT_LINE('TIPO DE BLOQUEO: '||wtype||'-'||wlock_type||'  OBJETO BLOQUEADO: '||wobject_name); 
             DBMS_OUTPUT.PUT_LINE(''); 
             EXCEPTION 
             WHEN NO_DATA_FOUND THEN 
             DBMS_OUTPUT.PUT_LINE('TIPO DE BLOQUEO: '||wtype||'-'||wlock_type||' No object found in DBA Objects'); 
          END; 
SELECT 'SQL_ID '||a.SQL_ID || ' @ ' || a.sql_text 
            INTO sentenciaLock 
            FROM gv$sqlarea a, gv$session s 
           WHERE a.SQL_ID = s.prev_sql_id 
             AND a.inst_id = s.inst_id 
             AND s.sid = sidID 
             AND rownum<=1;   
          DBMS_OUTPUT.PUT_LINE('QUERY BLOQUEANTE: '|| sentenciaLock); 
     END IF; 
     wstep  := 30; 
     SELECT '+  SESION BLOQUEADA: THREAD: 0'||s.inst_id|| 
            ' USER BD: '||upper (s.username) || 
            ' SID: '||s.sid|| 
            ' SERIAL: '||s.serial#|| 
            ' STATUS: '||upper (s.status)|| 
            ' (' || floor(last_call_et/3600)||':'||floor(mod(last_call_et,3600)/60)||':'||mod(mod(last_call_et,3600),60) ||')'|| 
            ' MACHINE: ' ||upper (substr(replace(machine,'LOCALHOST',null),1,30)) 
            , p.spid 
            , s.sid 
, s.inst_id 
       INTO wholder_detail, procesoId, sidID, threadID 
       FROM gv$session s, gv$process p 
      WHERE s.sid = c1_rec.sid 
   AND s.inst_id =  c1_rec.inst_id 
        AND s.paddr = p.addr 
        AND s.inst_id = p.inst_id 
        AND rownum <= 1; 
     DBMS_OUTPUT.PUT_LINE(wholder_detail); 
     SELECT 'SQL_ID: '||a.SQL_ID || ' @ ' || a.sql_text 
       INTO sentenciaLock 
       FROM gv$sqlarea a, gv$session s 
      WHERE a.address = s.sql_address 
        AND s.sid = sidID 
AND s.inst_id = threadID 
        AND rownum<=1; 
     DBMS_OUTPUT.PUT_LINE('.   QUERY BLOQUEADO: '|| sentenciaLock); 
     wid1  := c1_rec.id1; 
     wid2  := c1_rec.id2; 
  END LOOP; 
  if wid1 = -999999 then 
     wstep  := 40; 
     DBMS_OUTPUT.PUT_LINE('No hay usuarios bloqueados por otros usuarios'); 
  end if; 
  exception 
  when others then 
  DBMS_OUTPUT.PUT_LINE('No hay usuarios bloqueados por otros usuarios'); 
END; 
/


+======================================+
|   --    CONECTARSE A LA PDB          |
+======================================+
alter session set container=PSOA;


+==============================================+
|   --        VALIDAR INSTANCIA                |
+==============================================+
SET LINES 400 PAGES 800 
SELECT A.INSTANCE_NAME, A.VERSION, A.STARTUP_TIME, A.STATUS, B.OPEN_MODE, A.host_name, B.DATABASE_ROLE FROM GV$INSTANCE 
A JOIN GV$DATABASE B ON A.INST_ID = B.INST_ID ORDER BY INSTANCE_NAME;

 // REVISAR AVANCE DEL PROCESO_PROTECCION
 SELECT node_id,physical_operator_name, SUM(row_count) row_count, 
   SUM(estimate_row_count) AS estimate_row_count, 
   CAST(SUM(row_count)*100 AS float)/SUM(estimate_row_count)  
FROM sys.dm_exec_query_profiles   
WHERE session_id=113
GROUP BY node_id,physical_operator_name  
ORDER BY node_id;