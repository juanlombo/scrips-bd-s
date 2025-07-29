SELECT NAME, GUARANTEE_FLASHBACK_DATABASE, SCN, TIME
FROM V$RESTORE_POINT;


DROP RESTORE POINT rp_pre_cambio;



###########################################
#    --DESACTIVAR FLSHBACK                  #
###########################################


SQL> STARTUP MOUNT;
ORACLE instance started.

--Total System Global Area 3.0065E+10 bytes
--Fixed Size                 32535624 bytes
--Variable Size            1.5301E+10 bytes
--database Buffers         1.4697E+10 bytes
--Redo Buffers               34570240 bytes
--Database mounted.

SQL> alter database flashback off;

--Database altered.

SQL> alter database open;

--Database altered.

SQL> SELECT FLASHBACK_ON FROM V$DATABASE;

FLASHBACK_ON
------------------
NO
