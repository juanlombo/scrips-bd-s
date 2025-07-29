+========================================================================+ 
|                  CONSULTAR USUARIO                                     |
+========================================================================+ 
SELECT USERNAME,ACCOUNT_STATUS,LOCK_DATE,EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'SQL_JDALVAREZ';
----CAMBIAR A OPEN
ALTER USER dbsnmp account unlock;
-----CAMBIAR CONTRASEÑA
ALTER USER PRUCONEXION IDENTIFIED BY "zeti01" ACCOUNT UNLOCK;


ALTER USER SQL_JDALVAREZ ACCOUNT LOCK;


+========================================================================+ 
|                   PRUEBA DE CONEXION                                   |
+========================================================================+
sqlplus /nolog
@> CONNECT PRUCONEXION/zeti01@GSPSPEC
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
+========================================================================+ 
|   Configurar fecha de expiración (Para inactivar en el futuro)         |
+========================================================================+
ALTER USER SQ_JSUAREZ_SOFKA ACCOUNT EXPIRE;


+========================================================================+ 
			 CONSULTAR USUARIO                                           |
=========================================================================+
SELECT username, account_status,lock_date,created, profile, last_login   
FROM DBA_USERS                                                           
WHERE USERNAME = 'PRUCONEXION';    
                                    
+========================================================================+ 
        CONSULTAR PRIVILEGIOS QUE TIENE UN ESQUEMA EN LAS TABLAS         |
=========================================================================+                                                                         
SELECT GRANTEE, TABLE_NAME, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE GRANTEE = 'FRONT' AND (PRIVILEGE = 'SELECT' OR PRIVILEGE = 'INSERT' OR PRIVILEGE = 'UPDATE');

SELECT 
    username,
    account_status,
    password_expiry,
    profile
FROM 
    dba_users
WHERE 
    username = 'pruconexion';


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

+=================================================================================+
|                  CAMBIAR DE PROFILE O ASIGNAR PROFILE                           |
+=================================================================================+

ALTER USER usuario_prueba PROFILE PRUEBA;

+=================================================================================+
|                  ASIGNAR PRIVILEGIOS AL USUARIO                                 |
+=================================================================================+

GRANT CONNECT, RESOURCE TO jhonatan_leiva;


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