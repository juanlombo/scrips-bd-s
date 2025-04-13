	Set LineSize 300
	Set PageSize 500
	set timing off
	set heading on
	Column UserName Format A15
	Column SID      Format 99999
	Column SPID     Format A20
	Column machine     Format A25
	Column Observaciones Format A30
	Column OSUser   Format a13
	column login format a15
	column event  format a30
	column program  format a15
	column serial format 999999
	column seconds format 999999


	ttitle - 
	  center  'Esperas' skip 1
	select To_Char(SYSDATE,'DD-MON-YYYY hh24:mi') FECHA from dual;

	select S.SID,status,'kill -9 '||P.SPID spid,
		   S.Username,
		   SubStr(S.Program,1,15) Program,
		   SubStr(OsUser,1,12)  OsUser,w.seconds_in_wait seconds, to_char(logon_time, 'DD-MON HH24:MI') Login,
		   SubStr(w.Event,1,30) Event,
		   SubStr(Machine,1,25) Machine
	From   V$SESSION S, V$SESSION_WAIT W, V$PROCESS P
	Where  S.SID = W.SID(+)
	And    S.PAddr(+) = P.Addr
	And    Status = 'ACTIVE' 
	And    S.Username is not null
	Order By 9,4,8
	/

	select SubStr(w.Event,1,30) Event,count(*)
	From   V$SESSION S, V$SESSION_WAIT W, V$PROCESS P
	Where  S.SID = W.SID(+)
	And    S.PAddr(+) = P.Addr
	And    (Status = 'ACTIVE'  Or S.Username = 'PIH')
	And    S.Username is not null
	group by w.event
	/

ttitle - 
  center  'Cantidad de Sesiones Activas' skip 1

break on report
compute sum of count(*) on report

Select To_Char(SYSDATE, 'dd hh24:mi:ss')  Hora,
       Username,
       Count(*)
From   V$SESSION
Where  Status = 'ACTIVE'
and username is not null
group by To_Char(SYSDATE, 'dd hh24:mi:ss'), Username
Having Count(*) > 2
/
ttitle - 
  center  'Long Sessions Status' skip 1


col opname format a15
col serial# format 99999999
col target format a25
col message format a50
col username format a15
col inicio format a16
col procesado format 9999999
col falta     format 9999999
col avanzo    format 9999999
col totalwork format 9999999
col total     format 9999999
col porcentaje format 99.99
set linesize 220
SELECT sid, serial#, opname,target,username,message,
       to_char(start_time,'DD-MON-YY HH24:MI') Inicio,elapsed_seconds Procesado,
       time_remaining falta,sofar avanzo, totalwork total,
            round(sofar/totalwork*100,2) Porcentaje
     FROM gv$session_longops
     WHERE opname NOT LIKE '%aggregate%'
     AND totalwork != 0
     AND sofar <> totalwork
/