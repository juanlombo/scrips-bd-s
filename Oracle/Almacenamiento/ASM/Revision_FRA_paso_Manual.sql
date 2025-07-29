-- REVISIÓN DE FRA

-- El DB Recovery File Destination se encuentra al límite: se puede recuperar espacio eliminando archive manualmente de la prueba

****UBICACIÓN CKPR Y JDA NUEVO DRP**************
-- CKPR 
-- JDA: (CAPPEMS, CMODULA, CPEMS, CPWMS, CMAINT)
-- OPCIÓN : 30 Y 31


---Script Revisión % del reco FRA
SET LINESIZE 1500
 
COL FRA_Name FOR A20
COL Total_Size_GB FOR 9999999
COL Used_Size_GB FOR 9999999
COL Reclaimable_Size_GB FOR 9999999
 
SELECT
    name AS FRA_Name,  -- Nombre del FRA
    space_limit / 1024 / 1024 / 1024 AS Total_Size_GB,  -- Tamaño total en GB
    space_used / 1024 / 1024 / 1024 AS Used_Size_GB,    -- Tamaño usado en GB
    space_reclaimable / 1024 / 1024 / 1024 AS Reclaimable_Size_GB,  -- Tamaño recuperable en GB
    ROUND((space_used / space_limit) * 100, 2) AS Used_Percentage  -- Porcentaje de espacio utilizado
FROM
    V$RECOVERY_FILE_DEST;
	
-- FRA: Es el que maneja como todo el punto de recuperación, archivelog, falhsback 


---script para revisar que se puede recuperar
 show parameter DB_FLASHBACK_RETENTION_TARGET 
 

**************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************************


cd $ORACLE_HOME/bin
 
./crsctl start crs


solo pedir que suban servicios con 
 
/oracle/product/grid18c/bin/crsctl start crs




usted le hace seguimiento con grid 
 
crsctl stat res -t -init y crsctl stat res -t



5$yJbMb7CrDe