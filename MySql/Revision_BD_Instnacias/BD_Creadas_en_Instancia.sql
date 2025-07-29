======================================================================================================================
-- 									-- Revisar tamaño bd
======================================================================================================================
SELECT 
    table_schema AS 'Base de Datos',
    ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 2) AS 'Tamaño (GB)'
FROM 
    information_schema.tables
GROUP BY 
    table_schema
ORDER BY 
    'Tamaño (GB)' DESC;

---Fecha
SELECT NOW();


======================================================================================================================
-- 									LSITAR TODAS LAS BD 
======================================================================================================================
SHOW DATABASES;

======================================================================================================================
-- 									LSITAR TODAS LAS BD DESDE EL DIRECTORIO DE LA BD
======================================================================================================================	
mysql -u root -p -e "SHOW VARIABLES LIKE 'datadir';"
--resultado
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| datadir       | /var/lib/mysql/ |
+---------------+-----------------+

cd /var/lib/mysql/ ; ls -lrt

+====================================================================================================================+
|									Verificar las BD en INFORMATION_SCHEMA                                           |
+====================================================================================================================+
SELECT schema_name FROM information_schema.schemata;
----CONEXIÓN BD
mysql -u root -p


SHOW

+====================================================================================================================+
|									REVISAR BD CON MAS ACTIVIDAD                                                     |
+====================================================================================================================+

SELECT table_schema, SUM(data_length + index_length) / 1024 / 1024 AS size_mb, COUNT(*) AS num_tables 
FROM information_schema.tables 
GROUP BY table_schema 
ORDER BY size_mb DESC;





SELECT
    TABLE_NAME,
    ENGINE,
    ROW_FORMAT,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH,
    CREATE_TIME,
    TABLE_COLLATION,
    TABLE_COMMENT
FROM
    information_schema.tables
WHERE
    table_schema = 'corbetab2b'
    AND table_name = 'api_rule';





----- BUSCAR QUE BD TIENE LA TABLA SIN CONECTARSE A UNA BD 
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'sessions';

-- LISRAR BD
SHOW DATABASES;

-- CONECTARSE A LA BD 
USE nombre_de_base_datos;

---- REVISAR BD 
SELECT DATABASE();

--- revisar si la tabla tiene index
SHOW CREATE TABLE sessions;

---VERIFICAR ESTRCUTURA DE LA TABLA 
DESCRIBE sessions;

-- VERIFICAR RESTRICCIONES SOBRE LA TABLA 
SHOW CREATE TABLE sessions;

-- LISTAR LAS TABLAS DISPONIBLES EN LA BASE DE DATOS 
SHOW TABLES;


-- REVISAR PESO DE TABLA 
SELECT 
    table_schema,
    table_name,
    ROUND(data_length / 1024 / 1024, 2) AS data_mb,
    ROUND(index_length / 1024 / 1024, 2) AS index_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS total_mb
FROM information_schema.tables
WHERE table_schema = 'usuarios_distribuciones'
  AND table_name = 'sessions';

