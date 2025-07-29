--Validar espacio en Replica si se tiene y estado de la replicación, si se tiene al día

--Con usuario root
cd /dev/mapper/ -- Validar los permisos del disco, deben ser igual que los otros permisos de los discos, ver en todos los nodos.
oracleasm listdisks -- Ver los discos presentados en ASM

--Se agrega el nombre de los discos presentados y como deben llamarse y la ruta donde se encuentren por lo general es /dev/mapper/ se le deja el mismo nombre 
--del consecutivo

oracleasm createdisk DATA006 /dev/sdl1 -- Esto en uno de los nodos puede ser en el nodo 1.
oracleasm createdisk PRIDATA_42 /dev/mapper/PRIDATA_42 -- Esto en uno de los nodos puede ser en el nodo 1.

DATA006
fdisk /dev/sdl

/dev/sdl1

-- Crear tabla de partición
lsblk
blkid




-- Esto en los demás nodos donde no se ejecuto el anterior comando si son 2 nodos y se ejecuto en el 1 validar en el 2 el comando si son 3 nodos en el nodo 2 y 3:
oracleasm scandisks 



--Con usuario Oracle, Validar los discos que pertenecen al disgroup al DG en este caso DG_DAT_PROD y en esa ruta agregarla al alter siguiente a la validación

set lines 255
col path for a45
col Diskgroup for a18
col DiskName for a22
col disk# for 999
col total_mb for 999,999,999
col free_mb for 999,999,999
compute sum of total_mb on DiskGroup
compute sum of free_mb on DiskGroup
break on DiskGroup skip 1 on report
set pages 255
select a.name DiskGroup, b.disk_number Disk#, b.name DiskName, b.total_mb, b.free_mb, b.path, b.header_status, a.type
from v$asm_disk b, v$asm_diskgroup a
where a.group_number (+) =b.group_number
and a.name = 'ARCHIVE'
order by b.group_number,  b.name,b.disk_number
/


ejemplo:

DG_DAT_PROD            1 DG_DAT_PROD_0001            204,800       18,891 /dev/oracleasm/disks/PRIDATA_35        MEMBER       EXTERN
                      26 PRIDATA_03                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_03        MEMBER       EXTERN
                      50 PRIDATA_04                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_04        MEMBER       EXTERN
                      51 PRIDATA_05                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_05        MEMBER       EXTERN
                      52 PRIDATA_06                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_06        MEMBER       EXTERN
                      53 PRIDATA_07                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_07        MEMBER       EXTERN
                      27 PRIDATA_08                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_08        MEMBER       EXTERN
                      28 PRIDATA_09                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_09        MEMBER       EXTERN
                      29 PRIDATA_10                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_10        MEMBER       EXTERN
                      30 PRIDATA_11                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_11        MEMBER       EXTERN
                      43 PRIDATA_12                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_12        MEMBER       EXTERN
                      49 PRIDATA_13                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_13        MEMBER       EXTERN
                      54 PRIDATA_14                  204,800       18,893 /dev/oracleasm/disks/PRIDATA_14        MEMBER       EXTERN
                      55 PRIDATA_15                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_15        MEMBER       EXTERN
                      34 PRIDATA_16                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_16        MEMBER       EXTERN
                      31 PRIDATA_17                  204,800       18,893 /dev/oracleasm/disks/PRIDATA_17        MEMBER       EXTERN
                       4 PRIDATA_19                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_19        MEMBER       EXTERN
                      24 PRIDATA_22                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_22        MEMBER       EXTERN
                      25 PRIDATA_23                  204,800       18,893 /dev/oracleasm/disks/PRIDATA_23        MEMBER       EXTERN
                      32 PRIDATA_24                  204,800       18,893 /dev/oracleasm/disks/PRIDATA_24        MEMBER       EXTERN
                      33 PRIDATA_25                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_25        MEMBER       EXTERN
                      35 PRIDATA_26                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_26        MEMBER       EXTERN
                      36 PRIDATA_27                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_27        MEMBER       EXTERN
                      37 PRIDATA_28                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_28        MEMBER       EXTERN
                      38 PRIDATA_29                  204,800       18,893 /dev/oracleasm/disks/PRIDATA_29        MEMBER       EXTERN
                      39 PRIDATA_30                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_30        MEMBER       EXTERN
                      40 PRIDATA_31                  204,800       18,893 /dev/oracleasm/disks/PRIDATA_31        MEMBER       EXTERN
                      41 PRIDATA_32                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_32        MEMBER       EXTERN
                      42 PRIDATA_33                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_33        MEMBER       EXTERN
                       0 PRIDATA_34                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_34        MEMBER       EXTERN
                       2 PRIDATA_39                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_39        MEMBER       EXTERN
                       3 PRIDATA_40                  204,800       18,891 /dev/oracleasm/disks/PRIDATA_40        MEMBER       EXTERN
                       5 PRIDATA_41                  204,800       18,892 /dev/oracleasm/disks/PRIDATA_41--esta seria la ruta        MEMBER       EXTERN
                       6 PRIDATA_42                  204,800       18,896 /dev/oracleasm/disks/PRIDATA_42--esta seria la ruta        MEMBER       EXTERN


--Con usuario GRID
sqlplus / as sysasm

ALTER DISKGROUP DG_DAT_PROD ADD DISK '/dev/oracleasm/disks/HIT_1525_DG_ARCHIVE_19' NAME ARCHIVE_19 rebalance power 10;-- esperar que finalice para lanzar el otro
SELECT * FROM V$ASM_OPERATION;

ALTER DISKGROUP DG_DAT_PROD ADD DISK '/dev/oracleasm/disks/HIT_1525_DG_ARCHIVE_19' NAME ARCHIVE_19, '/dev/oracleasm/disks/HIT_1526_DG_ARCHIVE_20' NAME ARCHIVE_20, '/dev/oracleasm/disks/HIT_1527_DG_ARCHIVE_21' NAME ARCHIVE_21, '/dev/oracleasm/disks/HIT_1528_DG_ARCHIVE_22' NAME ARCHIVE_22, '/dev/oracleasm/disks/HIT_1529_DG_ARCHIVE_23' NAME ARCHIVE_23, '/dev/oracleasm/disks/HIT_152A_DG_ARCHIVE_24' NAME ARCHIVE_24 rebalance power 10;


ALTER DISKGROUP ARCHIVE ADD 
DISK 
'/dev/oracleasm/disks/HIT_1525_DG_ARCHIVE_19' NAME ARCHIVE_19,
'/dev/oracleasm/disks/HIT_1526_DG_ARCHIVE_20' NAME ARCHIVE_20,
'/dev/oracleasm/disks/HIT_1527_DG_ARCHIVE_21' NAME ARCHIVE_21,
'/dev/oracleasm/disks/HIT_1528_DG_ARCHIVE_22' NAME ARCHIVE_22,
'/dev/oracleasm/disks/HIT_1529_DG_ARCHIVE_23' NAME ARCHIVE_23,
'/dev/oracleasm/disks/HIT_152A_DG_ARCHIVE_24' NAME ARCHIVE_24
rebalance power 1;




ALTER DISKGROUP DATA ADD DISK '/dev/oracleasm/disks/DATA006'; 

ALTER DISKGROUP DATA REBALANCE POWER 8;
SELECT * FROM V$ASM_OPERATION;


/dev/oracleasm/disks/DATA006


--Seguir el proceso con la consulta, al finalizar se puede validar el asm, la consulta no debe arrojar resultados y ya se puede responder