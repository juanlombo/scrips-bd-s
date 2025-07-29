+=========================================================+
|           Revisar datafiles de un Tablespace            |
+=========================================================+ 
set line 500 
set timing off 
col file_name for a80 
select 
file_id,file_name,bytes/1024/1024 TAMANO, autoextensible, maxbytes/1024/1024 TAM_LIM_AUT, USER_BYTES/1024/1024 TAM_USADO,(A.INCREMENT_BY * B.BLOCK_SIZE)/1024/1024 NEXT 
from dba_data_files A, dba_tablespaces B 
where A.TABLESPACE_NAME = B.TABLESPACE_NAME and A.TABLESPACE_NAME = upper('&tablespace') order by 3;


+============================================+
|             DAR ESPACIO TABLESPACE         |
+============================================+
ALTER DATABASE DATAFILE # RESIZE XXm;
-------------------------------------------------------------------------------------------------------------------------------------------------
                                 188 +DATA/homiprod/datafile/users.463.1202308825                                          30000 NO
ALTER DATABASE DATAFILE  2 RESIZE M;                              
ALTER DATABASE DATAFILE 70 RESIZE 20980M;

ALTER DATABASE DATAFILE 1962 RESIZE 1500M;
ALTER DATABASE DATAFILE 2239 RESIZE 32767M;
ALTER DATABASE DATAFILE 2242 RESIZE 32767M;
ALTER DATABASE DATAFILE 832 RESIZE 32767M;
ALTER DATABASE DATAFILE 833 RESIZE 32767M;
ALTER DATABASE DATAFILE 834 RESIZE 32767M;
ALTER DATABASE DATAFILE 835 RESIZE 32767M;
ALTER DATABASE DATAFILE 836 RESIZE 32767M;
ALTER DATABASE DATAFILE 837 RESIZE 32767M;
ALTER DATABASE DATAFILE 838 RESIZE 32767M;
ALTER DATABASE DATAFILE 839 RESIZE 32767M;
ALTER DATABASE DATAFILE 840 RESIZE 32767M;
ALTER DATABASE DATAFILE 841 RESIZE 32767M;
ALTER DATABASE DATAFILE 842 RESIZE 32767M;



+============================================+
|            QUITAR AUTO EXTED               |
+============================================+


ALTER DATABASE DATAFILE 2323 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 2241 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 64 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 9 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 117 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE  AUTOEXTEND OFF;

+==========================================================+
|                crear data files                          |
+==========================================================+
ALTER TABLESPACE 'NOMBRE_TABLESPACE' ADD DATAFILE 'DISCO' SIZE 1024M AUTOEXTEND ON;


alter tablespace OMLARGE add datafile '+DATAC1' size 2G autoextend on NEXT 100M;

+==========================================================+
|  REDIMENRISONAR DATA FILE FILTRANDO POR EL TBS           |
+==========================================================+
SELECT  'alter  database datafile   ''' || FILE_NAME ||  '''  resize  ' || TO_CHAR(TRUNC(BYTES*1.1/1024/1024)) || 'm ;'  M    FROM  DBA_DATA_FILES
                where   TABLESPACE_NAME = 'INDEX_MAYOR';

+==========================================================+
|                    REVISAR DATA FILES                    |
+==========================================================+
set lines 500
colum NAME for a60
colum CREATION_TIME for a60
select FILE#,NAME,CREATION_TIME from v$datafile;


SELECT 
  file_id, 
  file_name, 
  bytes/1024/1024 AS size_mb
FROM 
  dba_temp_files
WHERE 
  tablespace_name = 'TEMP';


ALTER DATABASE TEMPFILE '+DATOS_DBSCBX5/DBSCBX5/TEMPFILE/temp.262.1200391929' RESIZE 512M;



-- =====================================================
   -- VALDIAR SI CREADON ALGUN DATAFILE NUEVO
-- =====================================================
set lines 500
colum NAME for a60
colum CREATION_TIME for a60
select FILE#,NAME,CREATION_TIME from v$datafile;





//----Listar datafiles para validar la creación de los nuevos en la principal y la stby----//
 
set lines 500
colum NAME for a60
colum CREATION_TIME for a60
select FILE#,NAME,CREATION_TIME from v$datafile;
 
 
//----Validar parametro----//
 
show parameter standby_file_management
 
--DEBE ESTAR EN MANUAL, Se cambia de la siguiente manera
 
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=MANUALscope=memory;
 
 
//----RENOMBRAR EL DATAFILE EN HPTUSTBY----//
 
alter database create datafile '/oracle/11204/db/dbs/UNNAMED00352' as '+IMAGES/hptu/datafile/scaneo_actual_tsd_53.dbf';