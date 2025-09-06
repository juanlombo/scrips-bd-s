#################################################################
#         Identifica el ORACLE_HOME GRIDD        #
#################################################################

ps -ef | grep ocssd.bin

##########################################################################
#       POR SERVICE CONTROL
##########################################################################
crsctl stat res -t
 
 
su - oracle
export ORACLE_SID=GREXCO1
export ORACLE_SID=HOMIPROD1
 
srvctl status service -d HOMIPROD
srvctl stop instance -d HOMIPROD -i HOMIPROD1 -o immediate
srvctl stop instance -d HOMIPROD -i HOMIPROD2 -o immediate
 
srvctl status service -d GREXCO
srvctl stop instance -d GREXCO -i GREXCO1 -o immediate
srvctl stop instance -d GREXCO -i GREXCO2 -o immediate
 

su - root
. oraenv
-> +ASM1
cd $ORACLE_HOME/bin
./crsctl stop crs -f
ps -fea | grep d.bin
 
------ subir
 
su - root
. oraenv
-> +ASM1
cd $ORACLE_HOME/bin
./crsctl stop crs -f
ps -fea | grep d.bin
 
srvctl status database -d GREXCO 
srvctl start instance -d GREXCO -i GREXCO1 
srvctl start instance -d GREXCO -i GREXCO2
 
srvctl status database -d HOMIPROD
srvctl start instance -d HOMIPROD -i HOMIPROD1 
srvctl start instance -d HOMIPROD -i HOMIPROD2
 
Verficasr NFS en el nodo 2 se encuentre mount
verifica los listener
verifica los servicios de la base de datos de GREXCO  y HOMIPROD




¿Hay GI en el host?
[ -f /etc/oracle/olr.loc ] && awk -F= '/crs_home/ {print "GRID_HOME=" $2}' /etc/oracle/olr.loc || echo "No hay GI en este host"
GRID_HOME=/u01/app/11.2.0/grid
[oracle@fhmoracle1 ~]$


##########################################################################
#
##########################################################################




tail -3000f /u01/app/oracle/diag/rdbms/grexco/GREXCO2/trace/alert_GREXCO2.log



tail -500f /u01/app/oracle/diag/rdbms/homiprod/HOMIPROD2/trace/alert_HOMIPROD2.log




























##########################################################################
#
##########################################################################



























##########################################################################
#
##########################################################################





















##########################################################################
#
##########################################################################

























##########################################################################
#
##########################################################################

























##########################################################################
#
##########################################################################


























##########################################################################
#
##########################################################################































##########################################################################
#
##########################################################################