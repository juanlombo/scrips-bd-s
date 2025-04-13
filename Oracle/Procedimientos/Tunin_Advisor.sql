+=============================================================================+
|        CREAR TUNING ADVISOR REMPLAZANDO EL SQL ID y plan_hash_valuen        |
+=============================================================================+
DECLARE
  stmt_task VARCHAR2(64);
BEGIN
  stmt_task:=dbms_sqltune.create_tuning_task(sql_id => 'f1gjw89d8bqr3', plan_hash_value => '3960105556', time_limit => 900, task_name => 'Tune_7z395rwuty6sb', description => 'Task to tune 7z395rwuty6sb sql_id');
END;


+=============================================================================+
|--           -------**********EJECUTAR EL TUNING*****-----                   |
+=============================================================================+
EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => '5zs96qb0nuwgv_tuning_task11');

+=============================================================================+
|-              ---******REVISAR QUE SI SE EJECUTO****-------                 |
+=============================================================================+
SELECT TASK_NAME, STATUS FROM DBA_ADVISOR_LOG WHERE TASK_NAME ='5zs96qb0nuwgv_tuning_task11';

+=============================================================================+
|       -------*****SACAR EL INFORME DEL Tuning AVISOR -****------            |
+=============================================================================+
set long 65536
set longchunksize 65536
set linesize 100
select dbms_sqltune.report_tuning_task('5zs96qb0nuwgv_tuning_task11') from dual;


+=============================================================================+
|                  --*******BORRAR EL TUNING ADVISOR****----                  |
+=============================================================================+
execute dbms_sqltune.drop_tuning_task('5zs96qb0nuwgv_tuning_task11');

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+=============================================================================+
|    SACAR EL MEJOR PLAN DE EJECUCIÓN O LOS QUE EL SQL ID UTILIZA             |
+=============================================================================+

select a.instance_number inst_id, a.snap_id,a.plan_hash_value, to_char(begin_interval_time,'dd-mon-yy hh24:mi') btime, abs(extract(minute from (end_interval_time-begin_interval_time)) + extract(hour from (end_interval_time-begin_interval_time))*60 + extract(day from (end_interval_time-begin_interval_time))*24*60) minutes,
executions_delta executions, round(ELAPSED_TIME_delta/1000000/greatest(executions_delta,1),4) "avg duration (sec)" from dba_hist_SQLSTAT a, dba_hist_snapshot b
where sql_id='5zs96qb0nuwgv' and a.snap_id=b.snap_id
and a.instance_number=b.instance_number
order by snap_id desc, a.instance_number;

+=============================================================================+
|                             qUERY QUE UTILIZA                               |
+=============================================================================+

select sql_id, SQL_TEXT from dba_hist_sqltext where sql_id='5zs96qb0nuwgv';


+=============================================================================+
|                            Con ese sacas el plan de ejecución               |
+=============================================================================+
select * from table(dbms_xplan.display_cursor('5zs96qb0nuwgv', null, 'ALLSTATS LAST'));

SELECT sql_id, plan_hash_value, substr(sql_text,1,40) sql_text
      FROM  v$sql
      WHERE sql_text like '%round(sum(untqty), 0) CHASIS%'