col GB format 9999999.99
col Espacio format a40
select '01. DATAFILES SISTEMA (sin TEMP/UNDO):' Espacio,
         sum(bytes)/1024/1024/1024 GB
         from dba_data_files
where   tablespace_name in ('SYSAUX','SYSTEM','USERS')
UNION
select '02. DATAFILES DATA (sin TEMP/UNDO):' Espacio,
         sum(bytes)/1024/1024/1024 GB
         from dba_data_files
where  tablespace_name not in ('SYSAUX','SYSTEM','USERS','UNDOTBS') 
UNION
select '03. UNDO:' Espacio,
        sum(bytes)/1024/1024/1024 GB
        from dba_data_files
where  tablespace_name like '%UNDO%'
UNION
select '04. TEMPFILES:',
         sum(bytes)/1024/1024/1024
         from dba_temp_files
UNION
select '05. ESPACIO LIBRE:',
sum(bytes)/1024/1024/1024 from dba_free_space;


select sum(bytes)/1024/1024/1024 MB from dba_segments;