+========================================================================+ 
|                  CONSULTAR USUARIO                                     |
+========================================================================+ 
SELECT USERNAME,ACCOUNT_STATUS,LOCK_DATE,EXPIRY_DATE FROM DBA_USERS WHERE USERNAME LIKE '%HENRY%';
----CAMBIAR A OPEN
ALTER USER METRO account unlock;
-----CAMBIAR CONTRASEÑA
ALTER USER C##HLOPEZ  IDENTIFIED BY "C2025#HLOPEZ**" ACCOUNT UNLOCK;

YXMWHC9b2

ALTER USER SQL_JDALVAREZ ACCOUNT LOCK;


+========================================================================+ 
|                   PRUEBA DE CONEXION                                   |
+========================================================================+
sqlplus /nolog
@> CONNECT C##HLOPEZ/C2025#HLOPEZ**
CONNECT C##HLOPEZ/C2025#HLOPEZ**@ZFPEFMCNN

       /*con pdb*/
@> CONNECT DBSNMP/DmjY7UFH_CnusBE6Z*fAH@PDB

+========================================================================+ 
|            xpirar la cuenta (Forzar cambio de contraseña)              |
+========================================================================+
ALTER USER SQ_JSUAREZ_SOFKA PASSWORD EXPIRE;
+========================================================================+ 
|                  Bloquear la cuenta (Inactivar)                        |
+========================================================================+
ALTER USER PROCESOS ACCOUNT UNLOCK;
ALTER USER ADM1214719234 ACCOUNT LOCK;
ALTER USER ADM1214719234 PASSWORD EXPIRE;
+========================================================================+ 
|   Configurar fecha de expiración (Para inactivar en el futuro)         |
+========================================================================+
ALTER USER SQ_JSUAREZ_SOFKA ACCOUNT EXPIRE;


+========================================================================+ 
			 CONSULTAR USUARIO                                           |
=========================================================================+
SELECT username, account_status,lock_date,created, profile, last_login   
FROM DBA_USERS                                                           
WHERE USERNAME = 'C##HLOPEZ';    
                                    
+========================================================================+ 
        CONSULTAR PRIVILEGIOS QUE TIENE UN ESQUEMA EN LAS TABLAS         |
=========================================================================+                                                                         
SELECT GRANTEE, TABLE_NAME, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE GRANTEE = 'FRONT' AND (PRIVILEGE = 'SELECT' OR PRIVILEGE = 'INSERT' OR PRIVILEGE = 'UPDATE');

SELECT 
    username,
    account_status,
    profile
FROM 
    dba_users
WHERE 
    username = 'C##HLOPEZ';


+=================================================================================+
|                   CREACIÓN DE USUARIOS EN ORACLE                                |
+=================================================================================+

CREATE USER jhonatan_leiva IDENTIFIED BY "C0l0mB1a_2025%"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP"
PROFILE "USUARIOS_CONEXION"
PASSWORD EXPIRE;
/*El PASSWORD EXPIRE es para que cuando se conecte cambie la contraseña;*/ 

+=================================================================================+
|                   DAR PRIVILEGIOS DE SETECT SOBRE UNA TABLA                     |
+=================================================================================+

GRANT SELECT ON ESB_SAP.LISTA_PRECIOS TO jhonatan_leiva;

--le otorga al usuario permiso de solo lectura (SELECT) sobre cualquier tabla de cualquier esquema en la base de datos, con algunas excepciones.
GRANT SELECT ANY TABLE TO "1032446598";

SELECT owner, table_name, privilege
FROM dba_tab_privs
WHERE 
    grantee = 'C##TSALCEDO';


+=================================================================================+
|                  CAMBIAR DE PROFILE O ASIGNAR PROFILE                           |
+=================================================================================+

ALTER USER usuario_prueba PROFILE PRUEBA;

+=================================================================================+
|                  ASIGNAR PRIVILEGIOS AL USUARIO                                 |
+=================================================================================+

GRANT CONNECT, RESOURCE TO jhonatan_leiva;

/* Construir grant select */
WITH TBLS AS (
	SELECT TABLE_NAME
	FROM DBA_TABLES
	WHERE OWNER = 'ZFWEB'
	ORDER BY TABLE_NAME
)
SELECT 'GRANT SELECT ON ZFWEB ' || t.TABLE_NAME || ' TO TEST_USER;'
FROM TBLS t 
;
 
+=========================================================================+ 
		     	 verificar usuario USUARIO                                |
+=========================================================================+
SELECT username, account_status,lock_date,created, profile, last_login   
FROM DBA_USERS                                                           
WHERE USERNAME IN ('JHONATAN_LEIVA','ANGELA_ROSERO');

+=========================================================================+ 
	  REVISAR QUE CONFIGURACIÓN DE CONTRSEÑAS TIENE EL PROFILE            |
+=========================================================================+
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'USUARIOS_CONEXION' AND RESOURCE_NAME LIKE 'PASSWORD%';

+=========================================================================+ 
	  VERIFICAR SOBRE QUE TABLAS TIENE PRIVILEGIOS                        |
+=========================================================================+
                 
SELECT OWNER, TABLE_NAME, PRIVILEGE 
FROM DBA_TAB_PRIVS 
WHERE GRANTEE IN ('JHONATAN_LEIVA','ANGELA_ROSERO');

-- REVOCAR PRIVILEGIOS
REVOKE SELECT ON HR.EMPLOYEES FROM JHONATAN_LEIVA;

-- ASIGNPRIVILEGIOS
GRANT SELECT, INSERT ON HR.EMPLOYEES TO JHONATAN_LEIVA;

+=================================================================================+
|                 VERIFICAR PROFILE DEL USUARIO                                   |
+=================================================================================+
SELECT USERNAME, PROFILE FROM DBA_USERS WHERE USERNAME IN ('JHONATAN_LEIVA','ANGELA_ROSERO');


--PRUEBA DE CONEXIÓN 

sqlplus /nolog
@> CONNECT ANGELA_ROSERO/ANG$ros3ro#2025@PDBBCT


+=======================================================================================
|                 REPISAR CONTRASEÑA EXISTENTE 
+======================================================================================

set lines 300
select 'alter user ' || name || ' identified by values ''' || spare4 || ''';' password from sys.user$ where name like 'METRO';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





---===========================================================================+
---          ASIGANACIÓN DE PERMISOS SELECT Y EJECUCIÓN A USUARIO EN TABLAS   |
---===========================================================================+

/*REVISAR QUE EL USUARIO EXISTA*/

SELECT USERNAME,ACCOUNT_STATUS,LOCK_DATE,EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'SQL_AURREA';


/*REVISAR QUE LAS TABLAS A LAS QUE SE NECESITAN LOS PERMISOS EXISTAN*/

SELECT owner, object_name, object_type
FROM all_objects
WHERE owner = 'METRO'
AND object_name IN ('LOG_MRAWEB', 'RECIBOS_TRANSP');


/*REVISAR QUE LA FUNCIÓN A LA QUE SE LE ENECITA DAR PERMISOS DE EJECUCIÓN EXITA*/

SELECT owner, object_name, object_type
FROM all_objects
WHERE owner = 'METRO'
AND object_name = 'FN_SOBRANTES_CONCILIACION';

---==========================+
---       OTORGAR PERMISOS   |
---==========================+

/*Permite al usuario ver (consultar) la tabla METRO.LOG_MRAWEB*/

GRANT SELECT ON metro.log_mraweb TO SQL_AURREA;
GRANT SELECT ON metro.recibos_transp TO SQL_AURREA;


/* Construir grant select */
WITH TBLS AS (
	SELECT TABLE_NAME
	FROM DBA_TABLES
	WHERE OWNER = 'ZFWEB'
	ORDER BY TABLE_NAME
)
SELECT 'GRANT SELECT ON ZFWEB ' || t.TABLE_NAME || ' TO TEST_USER;'
FROM TBLS t 
;
 


/*Permite al usuario ejecutar (usar) la función METRO.FN_SOBRANTES_CONCILIACION*/

GRANT EXECUTE ON metro.fn_sobrantes_conciliacion TO SQL_AURREA;


---========================================+
---     VALIDAR QUE SE OTORGARON PERMISOS  |
---========================================+
SELECT grantee, privilege, owner, table_name
FROM dba_tab_privs
WHERE grantee = 'SQL_AURREA'
AND owner = 'METRO';

SELECT grantee, privilege, owner, name
FROM dba_tab_privs
WHERE grantee = 'SQL_AURREA'
AND name = 'FN_SOBRANTES_CONCILIACION';

CREATE USER HENRYPEREZ IDENTIFIED BY "HeN7r1p325***"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT
PASSWORD EXPIRE;























-- set lines 200 
-- col USERNAME for a20 
-- col ACCOUNT_STATUS for a20 
-- col LOCK_DATE for a20 
-- col EXPIRY_DATE for a30 
-- SELECT USERNAME,ACCOUNT_STATUS,LOCK_DATE,EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'ADM1026307055';


-- alter user "ADM1026307055" identified by "Juan7055** password expire;

-- ALTER USER "CARLOS_SEMA" account unlock;

-- ALTER USER "CARLOS_SEMA" IDENTIFIED BY "C4R1/05#sdxzH";


-- ALTER USER CARLOS_SEMA account unlock;


-- alter user CARLOS_SEMA account unlock;


-- Alter user CARLOS_SEMA identified by "GuR87ZX#B4s/8";
 
 
 
 
 ALTER USER C##JUANLOMBO IDENTIFIED BY "Lombo7055JP**";






C0l0mB1a_2025






-- Otorgar privilegios de SELECT sobre las tablas del esquema AUDITORIA
GRANT SELECT ON AUDITORIA.TZFW_AUDITORIA_SERVICIOS_03062025 TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_AUDITORIA_SERVICIOS_20200302 TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_AUDITORIA_SERVICIOS_20200326 TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_CONTROL_NOTIFICACION TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_ERRORES_DUTAS TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_HOMOLOGACION_DUTAS TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_PARAM_GENERALES_INTEGRAC TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_PARAMETROS TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_TRANSACCIONES TO C##TSALCEDO;
GRANT SELECT ON AUDITORIA.TZFW_TRAZA_ERRORES TO C##TSALCEDO;


SELECT username
FROM dba_users 
WHERE username = 'AUDITORIA';


SELECT owner, table_name, privilege
FROM dba_tab_privs
WHERE grantee = 'C##TSALCEDO'
  AND owner = 'AUDITORIA'
  AND table_name IN (
    'TZFW_AUDITORIA_SERVICIOS_20200302',
    'TZFW_AUDITORIA_SERVICIOS_20200326',
    'TZFW_CONTROL_NOTIFICACION',
    'TZFW_ERRORES_DUTAS',
    'TZFW_HOMOLOGACION_DUTAS',
    'TZFW_PARAM_GENERALES_INTEGRAC',
    'TZFW_PARAMETROS',
    'TZFW_TRANSACCIONES',
    'TZFW_TRAZA_ERRORES',
    'TZFW_AUDITORIA_SERVICIOS_03062025'
  );



  col OWNER for a20                    
 col PRIVILEG for a20                                                                                   