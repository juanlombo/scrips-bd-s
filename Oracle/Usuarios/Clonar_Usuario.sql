
PASO A PASO PARA CREAR EL USUARIO 'FPENARAN' IGUAL A 'MLMONCAD'
==============================================================

1. OBTENER LOS ROLES ASIGNADOS A MLMONCAD
------------------------------------------
-- Ejecutar en SQL*Plus o una herramienta similar:
SELECT GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'MLMONCAD';

2. OBTENER LOS PRIVILEGIOS DEL SISTEMA ASIGNADOS DIRECTAMENTE
--------------------------------------------------------------
SELECT PRIVILEGE FROM DBA_SYS_PRIVS WHERE GRANTEE = 'MLMONCAD';

3. OBTENER LOS PRIVILEGIOS DE OBJETO
-------------------------------------
SELECT OWNER, TABLE_NAME, PRIVILEGE FROM DBA_TAB_PRIVS WHERE GRANTEE = 'MLMONCAD';

4. OBTENER EL PROFILE Y TABLESPACES DEL USUARIO MLMONCAD
----------------------------------------------------------
SELECT USERNAME, PROFILE, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE
FROM DBA_USERS WHERE USERNAME = 'MLMONCAD';

5. CREAR EL USUARIO FPENARAN (CON DATOS EQUIVALENTES)
------------------------------------------------------
-- Reemplazar valores según resultado del paso 4:
CREATE USER FPENARAN IDENTIFIED BY "TuPassword#2025"
DEFAULT TABLESPACE <DEFAULT_TABLESPACE>
TEMPORARY TABLESPACE <TEMPORARY_TABLESPACE>
PROFILE <PROFILE>
PASSWORD EXPIRE;

6. OTORGAR LOS ROLES OBTENIDOS EN EL PASO 1
--------------------------------------------
-- Por cada rol encontrado, ejecutar:
GRANT <ROL> TO FPENARAN;

7. OTORGAR PRIVILEGIOS DE SISTEMA (SI APLICA)
---------------------------------------------
-- Por cada privilegio:
GRANT <PRIVILEGIO> TO FPENARAN;

8. OTORGAR PRIVILEGIOS DE OBJETO (SI APLICA)
--------------------------------------------
-- Por cada combinación de OWNER/TABLE_NAME/PRIVILEGE:
GRANT <PRIVILEGIO> ON <OWNER>.<TABLE_NAME> TO FPENARAN;

9. DEFINIR LOS ROLES COMO DEFAULT ROLE (SI APLICA)
---------------------------------------------------
-- Sólo si los roles fueron otorgados explícitamente antes:
ALTER USER FPENARAN DEFAULT ROLE <ROL1>, <ROL2>, ...;

10. VALIDACIÓN FINAL
---------------------
-- Validar que el usuario fue creado y tiene permisos:
SELECT * FROM DBA_USERS WHERE USERNAME = 'FPENARAN';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'FPENARAN';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'FPENARAN';
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'FPENARAN';

-- Si todo concuerda con MLMONCAD, la clonación está completa.

