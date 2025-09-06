#################################################################
#         Identifica el ORACLE_HOME correcto para  LA BD        #
#################################################################
which sqlplus

--- EJECUTAR Y BUSCAR LA LINEA CON EL ORA_PMON
ps -ef | grep pmon
-- EJEMPLO 
oracle  12345  1  0 07:00 ?  00:00:00 ora_pmon_INVHIST
---busca cuál es el binario asociado
pwdx 15324

---Una vez lo tengas, exporta las variables correctamente:
export ORACLE_SID=INVHIST
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1  
export PATH=$ORACLE_HOME/bin:$PATH

--Encontrar el ORACLE_HOME del Grid Infrastructure
find / -name crsctl 2>/dev/null | grep bin



SHOW PARAMETER service_names;

SELECT name, network_name FROM v$services ORDER BY name;




#################################################################
#         Identifica el ORACLE_HOME GRIDD        #
#################################################################

ps -ef | grep ocssd.bin
