+=============================================================================+
|  --               VALIDAR SI ES UNA INSTANCIA TIPO CLUSTER                  |
+=============================================================================+

SELECT 
    SERVERPROPERTY('IsClustered') AS EsCluster,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS NodoActivo,
    SERVERPROPERTY('MachineName') AS NombreMaquina,
    SERVERPROPERTY('InstanceName') AS Instancia,
    SERVERPROPERTY('ServerName') AS NombreServidorCompleto;


