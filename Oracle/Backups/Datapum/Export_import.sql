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

EXPDP

-- cuanto core de cpu tiene el server
 nproc --all

vi exportdb_devbct2_20250618.par
directory=EXPDP
dumpfile=expdp_devbct2_KOBI_TIENDAS_20250320.dmp


vi exportdb_devbct2_20250618.par
DUMPFILE=expdp_devbct2_excl_%U.dmp
DIRECTORY=EXPDP
LOGFILE=expdp_devbct2_excl.log
FULL=Y
EXCLUDE=SCHEMA:"IN ('SYS','SYSTEM')"
PARALLEL=4
FILESIZE=100G


vi exportdb_devbct2_20250618.sh
export ORACLE_PDB_SID=PDBBCT
expdp \"/ as sysdba\" parfile=exportdb_devbct2_20250618.par
 ===================================================================================
 						CREACIÓN .par PARA expdp
 ===================================================================================
-- [oracle@PBDWMS03 export]$ cat exportdb.par
-- directory=BACKUP
-- dumpfile=exportdb_ZFRANCA_ZFWEB.dmp
-- logfile=exportdb_ZFRANCA_ZFWEB_.log
-- exclude=statistics
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





CREATE DIRECTORY EXPDP_BKP AS '/u02/export_190625';

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
vi exportdb_ZFRANCA_ZFWEB.sh
export ORACLE_PDB_SID=ZFRANCA
expdp \"/ as sysdba\" parfile=exportdb_ZFRANCA_ZFWEB.par


---- nohup exportdb_KOBI_TIENDAS_20250320.sh &

vi exportdb_ZFRANCA_ZFWEB.par
directory=DATA_PUMP_DIR_2
dumpfile=exportdb_ZFRANCA_ZFWEB.dmp
logfile=exportdb_ZFRANCA_ZFWEB.log
content=METADATA_ONLY
exclude=statistics
SCHEMAS=ZFWEB


expdp system@ZFRANCA parfile=exportdb_ZFRANCA_ZFWEB.par estimate_only=YES

Dar permiosos de ejecución 
chmod +x exportdb_ZFRANCA_ZFWEB.sh


expdp \'/ as sysdba\' directory=DATA_PUMP_DIR_2 dumpfile=exportdb_ZFRANCA_ZFWEB.dmp logfile=exportdb_ZFRANCA_ZFWEB.log exclude=statistics schemas=ZFWEB estimate_only=YES


#####################################
#   ---    IMPORT                   #
#####################################
vi import_ZFRANCA_ZFWEB.par
directory=DATA_PUMP_DIR_2
dumpfile=exportdb_ZFRANCA_ZFWEB.dmp
logfile=importdb_ZFRANCA_ZFWEB.log
schemas=ZFWEB
content=METADATA_ONLY
exclude=statistics

vi import_ZFRANCA_ZFWEB.sh
export ORACLE_PDB_SID=
expdp \"/ as sysdba\" parfile=importdb_ZFRANCA_ZFWEB.par



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

-- //// VER DIRECTORIOS
SELECT directory_name, directory_path
FROM dba_directories
ORDER BY directory_name;



 SELECT username FROM dba_users WHERE account_status = 'OPEN';
