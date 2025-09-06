
Paso a paso: detectar y arrancar bases de datos Oracle tras un apagado
=====================================================================

Introducción
------------
Este documento explica, de forma clara y práctica, cómo descubrir qué bases de datos (SIDs) existen en el servidor Oracle y cómo arrancarlas después de un apagado. Incluye pasos para instalaciones standalone (sin ASM) y para entornos con Grid/ASM. Ejecuta los comandos como el usuario correcto (normalmente "oracle" para bases y "grid" o "oracle" si Grid Infrastructure comparte usuario).

IMPORTANTE: muchas operaciones requieren privilegios del sistema y del usuario Oracle. Hazlas con cuidado y, si no estás seguro, pide ayuda a un DBA senior.

0) Antes de empezar (usuario y permisos)
---------------------------------------
- Conéctate al servidor como el usuario oracle (o grid si tu infraestructura lo usa):
  $ sudo su - oracle

- Comprueba que tienes `sqlplus` y que el ORACLE_HOME/ORACLE_SID estén configurados cuando sea necesario.

1) Verificar variables de entorno
---------------------------------
```bash
echo "USER: $(whoami)"
echo "ORACLE_SID=$ORACLE_SID"
echo "ORACLE_HOME=$ORACLE_HOME"
which sqlplus || echo "sqlplus no encontrado en PATH"
```

Si ORACLE_HOME no está exportado y `sqlplus` existe:
```bash
export ORACLE_HOME="$(dirname "$(dirname "$(which sqlplus)")")"
export PATH=$ORACLE_HOME/bin:$PATH
```

2) Descubrir qué bases existen
------------------------------
a) /etc/oratab (la fuente principal en Linux)
```bash
cat /etc/oratab | egrep -v '^\s*#|^\s*$'
```
Salida típica: `SID:/u01/app/oracle/product/21c/dbhome_1:Y`
- La primera columna es el SID.
- La última columna `Y/N` indica si `dbstart` lo arranca.

b) Archivos pfile/spfile en el DB_HOME
```bash
ls $ORACLE_HOME/dbs/init*.ora 2>/dev/null || true
ls $ORACLE_HOME/dbs/spfile*.ora 2>/dev/null || true
```

c) Revisar oradata/diag para pistas de SIDs
```bash
ls -d $ORACLE_BASE/oradata/* 2>/dev/null || true
ls -d $ORACLE_BASE/diag/rdbms/*/* 2>/dev/null || true
```

d) Si tienes Grid/ASM, busca +ASM en oratab y procesos ASM:
```bash
grep -i asm /etc/oratab || true
ps -ef | egrep "asm_smon|asm_pmon" | grep -v grep || true
```

3) Arrancar el Listener (si está abajo)
--------------------------------------
El listener es independiente de las instancias pero necesario para conexiones externas:
```bash
lsnrctl status || true
lsnrctl start
lsnrctl status
```

Observa la salida y el archivo de log del listener si falla (por lo general `$ORACLE_BASE/diag/tnslsnr/.../listener/trace/listener.log`).

4) Arrancar bases en entorno STANDALONE (sin ASM)
-------------------------------------------------
Para cada SID que encontraste en /etc/oratab:

```bash
# como oracle
export ORACLE_SID=<SID>
# opcional si tienes oraenv
# export ORAENV_ASK=NO; . /usr/local/bin/oraenv

sqlplus / as sysdba <<'SQL'
-- Arranque básico
startup;

-- Si la BD es 12c+ con PDBs:
alter pluggable database all open;
-- (Opcional) guarda el estado para siguientes arranques automáticos
alter pluggable database all save state;

-- Verifica estado
select instance_name, status from v$instance;
show pdbs;
exit
SQL
```

Notas:
- Si `startup` falla por falta de spfile, puedes probar `startup pfile=/ruta/a/init<SID>.ora`.
- Fíjate en errores de ALERT log si falla (ver sección 7).

5) Arrancar en entornos con GRID / ASM
-------------------------------------
a) Arranca ASM (desde GRID_HOME o usuario grid)
```bash
# como grid (o usuario que administra Grid Infrastructure)
export ORACLE_HOME=<GRID_HOME>
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=+ASM

sqlplus / as sysasm <<'SQL'
startup;
exit
SQL
```

b) Usa srvctl para listar y arrancar bases registradas:
```bash
# Lista BD registradas por srvctl
srvctl config database

# Arranca una BD registrada
srvctl start database -d <DB_UNIQUE_NAME>

# Verifica estado
srvctl status database -d <DB_UNIQUE_NAME>
```

c) Si la base no está registrada en srvctl, puedes arrancarla "a mano" (como en paso 4) desde el DB_HOME.

6) Verificación rápida
-----------------------
Comprueba procesos y servicios:
```bash
ps -ef | grep pmon | grep -v grep
# Debes ver algo como pmon_<SID>

lsnrctl status

# Conecta y comprueba desde sqlplus
sqlplus / as sysdba <<'SQL'
select instance_name, status from v$instance;
show pdbs;
select name from v$database;
exit
SQL
```

7) Revisión de logs y resolución de problemas comunes
-----------------------------------------------------
- Alert log de la BD: (ruta típica)
  `$ORACLE_BASE/diag/rdbms/<db>/<sid>/trace/alert_<SID>.log`
  Revisa las últimas líneas:
  ```bash
  tail -n 200 $ORACLE_BASE/diag/rdbms/*/*/trace/alert_*.log
  ```

- Errores comunes y pistas:
  * ORA-01078 / ORA-32004: problemas con pfile/spfile o parámetros incompatibles.
  * Listener no responde: revisar `listener.ora`, puertos, logs.
  * ASM no arranca: verificar discos ASM y permisos; ver logs de Grid infra en `$GRID_HOME/log/`.
  * ORA-01157 / ORA-01110: problemas con archivos de datafile (permisos, discos faltantes).

- Si `startup` falla, captura el error exacto y revisa el alert log; muchas veces la causa queda registrada ahí.

8) Forzar un arranque cuando falta spfile
------------------------------------------
Si `spfile` está corrupto o en ASM no accesible, puedes arrancar con pfile temporal:
```bash
sqlplus / as sysdba
-- desde SQL*Plus
startup pfile='/ruta/a/init<SID>.ora';
-- Luego puedes crear un spfile si todo está bien:
create spfile from pfile='/ruta/a/init<SID>.ora';
```

9) Dejar auto-arranque al reiniciar (opcional)
----------------------------------------------
Sin Grid:
- Asegúrate que las entradas en `/etc/oratab` terminen con `:Y` para los SIDs que quieras autoarrancar.
- Prueba:
```bash
su - oracle -c "dbstart $ORACLE_HOME"
su - oracle -c "dbshut $ORACLE_HOME"
```
- Para automatizar en systemd, crea un servicio que ejecute `su - oracle -c 'dbstart $ORACLE_HOME'` al iniciar.

Con Grid:
```bash
srvctl enable database -d <DB_UNIQUE_NAME>
# Esto habilita arranque automático a nivel de Grid.
```

10) Check-list rápida antes de tocar nada
-----------------------------------------
- ¿Tienes respaldo/backup reciente? (por si algo sale mal)
- ¿Tienes permisos de oracle/grid?
- ¿Alguien más está realizando cambios? (coordina con el equipo)
- ¿Listener activo? ¿Discos ASM accesibles? ¿spfile presente?

11) Comandos útiles de referencia rápida
----------------------------------------
```bash
# Entorno
whoami; hostname; date

# Detectar SIDs
cat /etc/oratab | egrep -v '^\s*#|^\s*$'

# Procesos
ps -ef | egrep "pmon|smon|asm_smon|asm_pmon" | grep -v grep

# Listener
lsnrctl status
lsnrctl start
lsnrctl stop

# SQL*Plus arranque
export ORACLE_SID=<SID>
sqlplus / as sysdba
startup
alter pluggable database all open;
exit

# Grid/ASM
srvctl config database
srvctl start database -d <DB_UNIQUE_NAME>
srvctl status database -d <DB_UNIQUE_NAME>
```

12) ¿Y si quieres, Rory...?
--------------------------
Si quieres, pégame:
- la salida de `cat /etc/oratab | egrep -v '^\s*#|^\s*$'`
- la salida de `ps -ef | egrep "pmon|asm_pmon|asm_smon" | grep -v grep`
- el resultado de `lsnrctl status`

Con eso te digo exactamente qué SID arrancar primero y los comandos exactos para tu servidor.

--- Fin del documento ---
