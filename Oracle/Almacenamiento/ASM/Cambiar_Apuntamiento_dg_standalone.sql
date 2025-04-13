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