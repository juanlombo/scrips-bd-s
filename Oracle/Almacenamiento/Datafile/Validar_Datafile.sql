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
|    DAR ESPACIO DATAFILE -TABLESPACE        |
+============================================+
ALTER DATABASE DATAFILE # RESIZE XXm;
-----------------------------------------------------------------------------------------------------------------------------------------------157
ALTER DATABASE DATAFILE 123 RESIZE 20004M;                                            
ALTER DATABASE DATAFILE 98  RESIZE 32767M;     
ALTER DATABASE DATAFILE 155 RESIZE 32767M;
ALTER DATABASE DATAFILE 97  RESIZE 32767M;
ALTER DATABASE DATAFILE 46  RESIZE 32767M;

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





--- CAMBIAR EL TAMAÑO DE AUTOEXTEND
ALTER DATABASE DATAFILE '/oradata02/OIM/datafile/PROD_oim111.dbf' AUTOEXTEND ON NEXT 500M MAXSIZE 32767M;

+============================================+
|            QUITAR AUTO EXTED               |
+============================================+


ALTER DATABASE DATAFILE 192  AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 98   AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 155 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 97   AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 46   AUTOEXTEND OFF;
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
ALTER TABLESPACE 'USERS' ADD DATAFILE 'DISCO' SIZE 1024M AUTOEXTEND ON;


alter tablespace PROD_OIM add datafile '/oradata02/OIM/datafile/' size 500M autoextend on NEXT 100M;

ALTER DATABASE DATAFILE '/oradata02/OIM/datafile/'AUTOEXTEND ON NEXT 30M MAXSIZE 32G;

ALTER DATABASE DATAFILE '+DATAC1/ckpr/datafile/psimage2_952_987545403' AUTOEXTEND ON NEXT 100M MAXSIZE 32768M;


--Crear datafile en filesystem
alter tablespace PROD_OIM add datafile '/oradata01/OIM/datafile/PROD_oim111.dbf' size 500M autoextend on maxsize 32767M;

ALTER TABLESPACE PROD_OIM ADD DATAFILE '/oradata02/OIM/datafile/PROD_oim111.dbf' SIZE 1024M AUTOEXTEND ON NEXT 500M MAXSIZE 65536M;
--Listar 
ls -l comercial_data_peq_*
ls -ltr PROD_oim*

---Validar la secuencia para crear el datafile
set lines 500
colum NAME for a60
colum CREATION_TIME for a60
select FILE#,NAME,CREATION_TIME from v$datafile;


alter tablespace PROD_OIM  add datafile '/oradata02/OIM/datafile/PROD_oim112.dbf' SIZE 3G;
ALTER TABLESPACE PROD_OIM ADD DATAFILE '/oradata01/OIM/datafile/PROD_oim_112.bdf' SIZE 1G;

+==========================================================+
|  Revisar si Es BIGFILE o SMALLFILE        |
+==========================================================+

select tablespace_name, bigfile
from dba_tablespaces
where tablespace_name = 'PROD_OIM';

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

select FILE_ID,  FILE_NAME, TABLESPACE_NAME,BYTES/1024/1024/1024 GB  
from dba_data_files where FILE_ID=01187;
select  BIGFILE from  dba_tablespaces where TABLESPACE_NAME='TOOLS_SSD';



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