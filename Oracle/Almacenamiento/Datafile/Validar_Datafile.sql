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
                                    
ALTER DATABASE DATAFILE 2318 RESIZE 21024M;
ALTER DATABASE DATAFILE 2234 RESIZE 32767M;
ALTER DATABASE DATAFILE 618 RESIZE 32767M;

+============================================+
|            QUITAR AUTO EXTED               |
+============================================+

ALTER DATABASE DATAFILE 2235 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 2234 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 865 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 824 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 866 AUTOEXTEND OFF;
ALTER DATABASE DATAFILE 790 AUTOEXTEND OFF;

+==========================================================+
|                crear data files                          |
+==========================================================+
ALTER TABLESPACE 'NOMBRE_TABLESPACE' ADD DATAFILE 'DISCO' SIZE 1024M AUTOEXTEND ON;


alter tablespace PSINDEX add datafile '+DATAC1' size 10G autoextend on NEXT 100M;

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