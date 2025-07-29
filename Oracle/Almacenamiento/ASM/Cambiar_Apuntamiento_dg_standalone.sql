-- standalone revisar el apuntamiento 
show parameter archive

-- Despues lo pasamos al dg mas libre
ALTER SYSTEM SET log_archive_dest_1='LOCATION=+EVENTDATA' SCOPE=BOTH;

-- Alteramos para que tome el cambio 
alter system switch logfile;

-- devolver cambio
ALTER SYSTEM SET log_archive_dest_1='LOCATION=+RECOVERY' SCOPE=BOTH;

-- Alteramos para que tome el cambio 
alter system switch logfile;



####################################################################
#           -- DEPURAR DG BACKUPS CONTROLFILE Y SPFILE             #
####################################################################
-- Lista los backups de controlfile y spfile en RMAN
LIST BACKUP OF CONTROLFILE SUMMARY;
LIST BACKUP OF SPFILE SUMMARY;


-- Antes de eliminar cualquier backup, siempre hay que hacer un:
CROSSCHECK BACKUP;
CROSSCHECK ARCHIVELOG ALL;

-- Esto hará que RMAN valide el estado real de los backups y archivelogs con lo que tiene registrado. Los que estén "missing" o desactualizados RMAN los marcará como EXPIRED.
-- Luego, con el inventario sincronizado, ejecutas:
DELETE EXPIRED BACKUP;


-- Elimina backups antiguos desde RMAN
DELETE BACKUP OF CONTROLFILE COMPLETED BEFORE 'SYSDATE-15';
DELETE BACKUP OF SPFILE COMPLETED BEFORE 'SYSDATE-15';


-- Verifica la eliminación
LIST BACKUP OF CONTROLFILE SUMMARY;
LIST BACKUP OF SPFILE SUMMARY;
