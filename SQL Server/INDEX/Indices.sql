+===============================================+
|    REVISION DE INDEX EN UNA TABLA O MAS       |
+===============================================+

-- NOMBRE TABLA, NOMBRE INDEX, TIO DE IDEX, NOMBRE DE COLUMNA
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ic.index_column_id,
    c.name AS ColumnName,
    ic.is_included_column
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE OBJECT_NAME(i.object_id) in ('components','issues')
ORDER BY TableName, IndexName, ic.index_column_id


--tablename, indexName, user_seeks (Veces que el índice se usó en búsquedas eficientes (condiciones WHERE, JOIN, etc.)), user_scans 

SELECT 
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates,
    i.is_disabled
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE OBJECT_NAME(s.object_id) = 'components'
ORDER BY (s.user_seeks + s.user_scans + s.user_lookups) DESC


----REVISAR FRAGMENTACIÓN 
SELECT  OBJECT_NAME(IDX.OBJECT_ID) AS Table_Name, 
IDX.name AS Index_Name, 
IDXPS.index_type_desc AS Index_Type, 
IDXPS.avg_fragmentation_in_percent  Fragmentation_Percentage
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) IDXPS 
INNER JOIN sys.indexes IDX  ON IDX.object_id = IDXPS.object_id 
AND IDX.index_id = IDXPS.index_id 
ORDER BY Fragmentation_Percentage DESC