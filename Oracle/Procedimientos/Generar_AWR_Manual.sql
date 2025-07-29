#####################################################################################
#                ---   PRINCIPALMENTE SE UTILIZA PARA D1           ---              #
#####################################################################################
Integrador
PBDWMS03
INTEGRADOR
@$ORACLE_HOME/rdbms/admin/awrrpt.sql;
mv awrrpt_*.html awrrpt_integrador_mayo.html

BCT
sql
alter session set container=PDBBCT;
@$ORACLE_HOME/rdbms/admin/awrgrpt.sql;
mv awrrpt_rac_53628_53977.html awrrpt_BCT_mayo.html

La estrella
ocidbwms02
sudo su - oracle
export ORACLE_PDB_SID=WMS_LAESTRELLA
sql
@$ORACLE_HOME/rdbms/admin/awrgrpt.sql;
mv awrrpt_rac_3982_4186.html awrrpt_ESTRELLA_marzo.html
mv awrrpt_ESTRELLA_marzo.html /tmp

Giradota
ocidbwms02
sudo su - oracle
export ORACLE_PDB_SID=WMS_GIRARDOTA
sql
@$ORACLE_HOME/rdbms/admin/awrgrpt.sql;
awrrpt_GIRARDOTA_marzo.html
mv *GIRARDOTA*.html /tmp

Tocancipa
ocidbwms02
sudo su - oracle
export ORACLE_PDB_SID=WMS_TOCANCIPA
sql
@$ORACLE_HOME/rdbms/admin/awrgrpt.sql;
awrrpt_TOCANCIPA_marzo.html
mv *TOCANCIPA*.html /tmp






EMREP
cd /home/oracle/seti/hardening
rm -f PBDMON01_emrep_Aseguramiento_Oracle19.html
sql
@4_Tablas_Auditoria_Drop.sql
sql
@1_Tablas_Auditoria_Creacion.sql
@2_AseguramientoOracle.sql
@3_Generacion_HTML.sql

METAREP
PBDOSB03
cd /home/oracle/seti/hardening
rm -f *.html
METAREP
@4_Tablas_Auditoria_Drop.sql
sql
@1_Tablas_Auditoria_Creacion.sql
@2_AseguramientoOracle.sql
@3_Generacion_HTML.sql

promocionales
bdprdpromoc
sudo su - oracle
cd /home/oracle/seti/hardening
rm -f *.html
PRBDPROM
@4_Tablas_Auditoria_Drop.sql
sql
@1_Tablas_Auditoria_Creacion.sql
@2_AseguramientoOracle.sql
@3_Generacion_HTML.sql
cd /tmp
ls -lrt |grep ocidbwms02
RENOMBRAR POR ocidbwms02_Estrella_Aseguramiento_Oracle19

step
PBDWMS03
cd /home/oracle/seti/hardening
rm -f *.html
step
@4_Tablas_Auditoria_Drop.sql
sql
@1_Tablas_Auditoria_Creacion.sql
@2_AseguramientoOracle.sql
@3_Generacion_HTML.sql

Tocancipa
ocidbwms02
sudo su - oracle
export ORACLE_PDB_SID=WMS_TOCANCIPA
cd /home/oracle/seti/hardening
rm -f *.html
sql
@4_Tablas_Auditoria_Drop.sql
sql
@1_Tablas_Auditoria_Creacion.sql
@2_AseguramientoOracle.sql
@3_Generacion_HTML.sql
cd /tmp
ls -lrt |grep ocidbwms02
RENOMBRAR POR ocidbwms02_Tocancipa_Aseguramiento_Oracle19
