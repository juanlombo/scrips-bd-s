===================================================================================
 						CREACIÓN sh para expdp
 ===================================================================================
-- [oracle@PBDWMS03 export]$ cat exportdb_KOBI_TIENDAS.sh
-- export ORACLE_SID=BCT
-- expdp \"/ as sysdba\" parfile=exportdb.par
 ===================================================================================
 						CREACIÓN sh para expdp PDB
 ===================================================================================
-- vi exportdb_KOBI_TIENDAS_20250320.sh
   export ORACLE_PDB_SID=PDBBCT
-- expdp \"/ as sysdba\" parfile=exportdb_KOBI_TIENDAS_20250320.par

nohup exportdb_KOBI_TIENDAS_20250320.sh &

-- vi exportdb_KOBI_TIENDAS_20250320.par
-- directory=EXP_OCI
-- dumpfile=expdp_FRONT_KOBI_TIENDAS_20250320.dmp
-- logfile=expdp_FRONT_KOBI_TIENDAS_20250320.log
-- exclude=statistics
-- tables=FRONT.KOBI_TIENDAS

 ===================================================================================
 						CREACIÓN .par PARA expdp
 ===================================================================================
-- [oracle@PBDWMS03 export]$ cat exportdb.par
-- directory=BACKUP
-- dumpfile=expdp_AUDITORY_HISTORY_dic2022.dmp
-- logfile=expdp_AUDITORY_HISTORY_dic2022.log
-- exclude=statistics
-- QUERY=OSB.AUDITORY_HISTORY:"WHERE FECHA_CREACION BETWEEN to_date('2022-12-01','yyyy-mm-dd') and  to_date('2023-01-01','yyyy-mm-dd')"
-- tables=OSB.AUDITORY_HISTORY
-- ESTIMATE_ONLY=YES



-- vi import_KOBI_TIENDAS_20250320.sh
-- export ORACLE_PDB_SID=DBBCT_PDBQA
-- impdp \"/ as sysdba\" parfile=importdb_KOBI_TIENDAS_20250320.par service_name=DBBCT_PDBQA


-- vi importdb_KOBI_TIENDAS_20250320.par
-- directory=BACK_EXP
-- dumpfile=expdp_FRONT_KOBI_TIENDAS_20250320.dmp
-- logfile=import_FRONT_KOBI_TIENDAS_20250320.log
-- TABLES=FRONT.KOBI_TIENDAS
   table_exists_action=replace

Dar permiosos de ejecución 
chmod +x import_KOBI_TIENDAS_20250320.sh

-- nohup impdp "'/ as sysdba '" directory=DIR_IMP_DMP dumpfile=expdp_full_socrates_2025.02.16.dmp.gz logfile=import_full_socrates_20250216.log SCHEMAS=GAA2 TABLE_EXISTS_ACTION=REPLACE &



 ===================================================================================
 						REVISIÓN PESO DE TABLAS DE UNS ESQUEMA
 ===================================================================================

SELECT segment_name AS table_name, 
       bytes/1024/1024 AS size_mb
FROM dba_segments
WHERE segment_type = 'TABLE'
AND owner = 'FRONT'
ORDER BY size_mb DESC;


 ===================================================================================
 						REVISIÓN PESO TABLA
 ===================================================================================

SELECT segment_name AS table_name, 
       segment_type, 
       bytes/1024/1024 AS size_mb
FROM dba_segments
WHERE segment_type = 'TABLE' 
AND segment_name = 'KOBI_TIENDAS'
AND owner = 'FRONT';


 ===================================================================================
 						CREACIÓN sh para expdp PDB
 ===================================================================================
vi exportdb_OSB_20250326.sh
export ORACLE_SID=INTEGRADOR
expdp \"/ as sysdba\" parfile=exportdb_OSB_20250326.par


---- nohup exportdb_KOBI_TIENDAS_20250320.sh &

vi exportdb_OSB_20250326.par
directory=BACKUP
dumpfile=exportdb_OSB_20250326.dmp
logfile=exportdb_OSB_20250326.log
exclude=statistics
SCHEMAS=OSB
EXCLUDE=TABLE:"IN ('OSB.AUDITORY','OSB.AUDITORY_HIST')"




Dar permiosos de ejecución 
chmod +x import_KOBI_TIENDAS_20250320.sh


expdp \'/ as sysdba\' directory=BACKUP dumpfile=exportdb_OSB_20250326.dmp logfile=exportdb_OSB_20250326.log exclude=statistics schemas=OSB exclude=TABLE:"IN ('AUDITORY','AUDITORY_HIST')" estimate_only=YES


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





------------------------------MARZO 2023--------------------------------------------------------------------------------------
------------------------------MARZO 2023--------------------------------------------------------------------------------------
time scp /oracle/expdp/expdp_AUDITORY_HISTORY_mar2023.dmp oracle@172.18.164.232:/exports/exports_audit_integrador/

expdp_AUDITORY_HISTORY_mar2023.dmp                                                                                                                                                                      100%   23GB  79.9MB/s   04:59

real    5m12.678s
user    1m38.766s
sys     1m22.271s
You have mail in /var/spool/mail/oracle

/home/oracle/seti/export/


time scp /oracle/expdp/expdp_AUDITORY_HISTORY_feb05_2025.dmp oracle@172.18.164.232:/exports/exports_audit_integrador/
time scp /oracle/expdp/expdp_AUDITORY_HISTORY_feb05_2025.log oracle@172.18.164.232:/exports/exports_audit_integrador/

-- CHc*B2aR3k$HTLAvD

nohup ./exportdb.sh &
