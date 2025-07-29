---Backups tablas
CREATE TABLE TABLE_NAME_BK_240725 AS
SELECT * FROM TABLE_NAME;

---Revisión Peso tablas
SELECT
    nspname AS esquema,
    pg_class.relname AS tabla,
    pg_size_pretty(pg_total_relation_size(pg_class.oid)) AS tamaño
FROM
    pg_catalog.pg_namespace nsp
JOIN
    pg_catalog.pg_class pg_class ON pg_class.relnamespace = nsp.oid
WHERE
    pg_class.relkind = 'r'  -- Solo tablas
    AND nsp.nspname = 'NOMBRE_ESQUEMA'
 AND pg_class.relname = 'NOMBRE_TABLA'
ORDER BY
    pg_total_relation_size(pg_class.oid) DESC  -- Ordenar por tamaño de tabla (de mayor a menor)
;