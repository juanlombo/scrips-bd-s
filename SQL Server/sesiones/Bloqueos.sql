SET NOCOUNT ON;
SET CONCAT_NULL_YIELDS_NULL OFF
GO
WITH BLOCKERS (SPID, DatabaseName, BLOCKED, LEVEL, BATCH,waittype,lastwaittype, status, login_time, cpu, waittime, loginame, program_name, hostname)
AS
(
   SELECT
   SPID,
   DatabaseName = DB_NAME(R.dbid),
   BLOCKED,
   CAST (REPLICATE ('0', 4-LEN (CAST (SPID AS VARCHAR))) + CAST (SPID AS VARCHAR) AS VARCHAR (1000)) AS LEVEL,
   REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH,
   R.waittype,
   R.lastwaittype,
   R.status,
   R.login_time,
   R.cpu,
   R.waittime,
   R.loginame,
   R.program_name,
   R.hostname  
   FROM sys.sysprocesses R with (nolock)
   CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) T
   WHERE (BLOCKED = 0 OR BLOCKED = SPID)
   AND EXISTS    (SELECT SPID,BLOCKED,CAST (REPLICATE ('0', 4-LEN (CAST (SPID AS VARCHAR))) + CAST (SPID AS VARCHAR) AS VARCHAR (1000)) AS LEVEL,
   BLOCKED, REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH,R.waittype,R.lastwaittype FROM sys.sysprocesses R2 with (nolock)
   CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) T
WHERE R2.BLOCKED = R.SPID AND R2.BLOCKED <> R2.SPID)
UNION ALL
SELECT
    R.SPID,
    DatabaseName = DB_NAME(R.dbid),
    R.BLOCKED,
    CAST (BLOCKERS.LEVEL + RIGHT (CAST ((1000 + R.SPID) AS VARCHAR (100)), 4) AS VARCHAR (1000)) AS LEVEL,
    REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH,
    R.waittype,
    R.lastwaittype,
    R.status,
    R.login_time,
    R.cpu,
    R.waittime,
    R.loginame,
    R.program_name,
    R.hostname     
    FROM sys.sysprocesses AS R with (nolock)
    CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) T
    INNER JOIN BLOCKERS ON R.BLOCKED = BLOCKERS.SPID
    WHERE R.BLOCKED > 0 AND R.BLOCKED <> R.SPID
)
SELECT N'       ' + REPLICATE (N'|      ', LEN (LEVEL)/4 - 2) +
CASE WHEN (LEN (LEVEL)/4 - 1) = 0 THEN
  'HEAD - '
ELSE '|------ '
END + CAST (SPID AS VARCHAR (10)) + ' '  + BATCH AS BLOCKING_TREE ,
DatabaseName,  
waittype ,
lastwaittype,
status, login_time,cpu, waittime, loginame, program_name, hostname
FROM BLOCKERS with (nolock) ORDER BY LEVEL ASC
go

SELECT SYSDATETIME();