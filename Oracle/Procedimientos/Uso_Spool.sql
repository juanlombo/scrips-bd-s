
Spool /home/orarac/seti/FIDUTRIA_salida.csv

/*
Buenos días, se solicita por favor realizar DFU para el siguiente retiro Programado de la Póliza 86881 Vida, el afiliado presento rechazo en el pago programado de Marzo, por lo cual se graba un pago programado adicional:
*cc 70552924 FEDERICO BOTERO TORO BOTERO grabado Periodo primer pago 04/2024 a Periodo final pago 04/2024 el valor que arrastra el sistema esta errado figura por $9,501 siendo el correcto $10.451. Por favor me colaboran con gestión, muchas gracias
*/


-- CONSULTA PRODUCTO COMPLEMENTARIO:  2 - PÓLIZA 86881 VIDA
SELECT --*
  --/*
  SPCID SOLICITUD_PRODCOMP,
  TIDCDCODIGO               AS TIPO_ID,
  PERCDNUMEROIDENTIFICACION AS IDENTIFICACION,
  PERDSPRIMERNOMBRE
  || ' '
  || PERDSSEGUNDONOMBRE
  || ' '
  || PERDSPRIMERAPELLIDO
  || ' '
  || PERDSSEGUNDOAPELLIDO NOMBRE,
  TSOIDPRODUCTO                 AS ID_PRODUCTO,
  PRODSDESCRIPRODUCTO           AS NOMBRE_PRODUCTO,
  SPCIDCUENTA                   AS CUENTA,
  SPCIDPRODUCTOCOMPLEMENTARIO   AS ID_PROD_COMPL,
  PCPDSNOMBREPRODCOMPLEMENTARIO AS NOMBRE_PRODUCTO_COMPL,
  SPCNMVALORSOLICITADO          AS VALOR_SOLICITADO,
  SPCNMVALORCOBROPERIODICO      AS VALOR_COBRO_PERIODICO,
  SPCFECREACION                 AS FECHA_CREACION,
  SPCFESOLICITUD                AS FECHA_SOLICITUD,
  TSODSESTADOSOLICITUD          AS ESTADO
  --*/
FROM PREVCXN1.TCMV_SOLICI_PRODCOMPLEMENT
INNER JOIN PREVCXN1.TSTV_SOLICITUD            ON SPCIDSOLICITUDGLOBAL = TSOID
INNER JOIN PREVCXN1.TPER_PERSONA              ON PERID = SPCIDPERSONA
LEFT JOIN PREVCXN1.TENE_TIPO_IDENTIFICACIONES ON PERIDTIPOIDENTIFICACION = TIDID
LEFT JOIN PREVCXN1.TENE_PARAM_PRODCOMPLEMENTA ON SPCIDPRODUCTOCOMPLEMENTARIO = PCPID
LEFT JOIN PREVCXN1.TENE_PRODUCTO              ON TSOIDPRODUCTO = PROID
WHERE  PERCDNUMEROIDENTIFICACION IN ('8259317', '8301838', '10230364', 
'10269385', '10519203', '32455580', '32465169', '41491854', '41705605', 
'42884866', '70113451', '70552924', '71591003', '79110478', '79313606')
AND SPCIDPRODUCTOCOMPLEMENTARIO = 2; -- 2	PÓLIZA 86881 VIDA

-- 1
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 8259317	53812	RIVAS BERMUDEZ ALVARO PIO	 $ 11.575 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 53812 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 53812 AND PPRID = 651;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 11575
WHERE PPRIDCUENTA = 53812 AND PPRID = 651;
Commit;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 651;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 11575
WHERE DPAIDPAGOPROGRAMADO = 651 AND DPAID = 152;

 
Commit;

-- 2
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 8301838	51138	VELASQUEZ URIBE RAMIRO	 $ 11.575 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 51138 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 51138 AND PPRID = 589;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 11575
WHERE PPRIDCUENTA = 51138 AND PPRID = 589;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 589;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 11575
WHERE DPAIDPAGOPROGRAMADO = 589 AND DPAID = 90;

 
Commit;

-- 3
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 10230364	50541	URICOECHEA BORRERO MAURICIO	 $ 9.567 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50541 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50541 AND PPRID = 557;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 9567
WHERE PPRIDCUENTA = 50541 AND PPRID = 557;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 557;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 9567
WHERE DPAIDPAGOPROGRAMADO = 557 AND DPAID = 58;

 
Commit;


-- 4
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 10269385	58156	OSPINA ISAZA JORGE IVAN	 $ 14.350 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 58156 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 58156 AND PPRID = 736;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 14350
WHERE PPRIDCUENTA = 58156 AND PPRID = 736;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 736;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 14350
WHERE DPAIDPAGOPROGRAMADO = 736 AND DPAID = 237;

 
Commit;

-- 5
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 10519203	64015	POLANCO FLOREZ JORGE EDUARDO	 $ 15.433 


-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 64015 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 64015 AND PPRID = 774;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 15433
WHERE PPRIDCUENTA = 64015 AND PPRID = 774;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 774;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 15433
WHERE DPAIDPAGOPROGRAMADO = 774 AND DPAID = 275;

 
Commit;


-- 6
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 32455580	54193	BERRIO DE LEON MARIA EUGENIA	 $ 7.717 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 54193 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 54193 AND PPRID = 664;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 7717
WHERE PPRIDCUENTA = 54193 AND PPRID = 664;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 664;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 7717
WHERE DPAIDPAGOPROGRAMADO = 664 AND DPAID = 165;

 
Commit;


-- 7.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 32465169	50977	ARANGO DE SYRO LUZ MARIA	 $ 7.717 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50977 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50977 AND PPRID = 576;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 7717
WHERE PPRIDCUENTA = 50977 AND PPRID = 576;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 576;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 7717
WHERE DPAIDPAGOPROGRAMADO = 576 AND DPAID = 77;

 
Commit;

-- 8.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 41491854	67891	GREN DE TOBON MARICIELO DEL ROSARIO	 $ 15.433 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 67891 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 67891 AND PPRID = 799;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 15433 
WHERE PPRIDCUENTA = 67891 AND PPRID = 799;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 799;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 15433
WHERE DPAIDPAGOPROGRAMADO = 799 AND DPAID = 300;

 
Commit;


-- 9.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 41705605	57529	JARAMILLO RESTREPO MARIA DEL PILAR	 $ 4.783 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 57529 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 57529 AND PPRID = 725;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 4783 
WHERE PPRIDCUENTA = 57529 AND PPRID = 725;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 725;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 4783
WHERE DPAIDPAGOPROGRAMADO = 725 AND DPAID = 226;

 
Commit;



-- 10.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 42884866	50327	VELASQUEZ POSADA ANA EUGENIA	 $ 9.567 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50327 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50327 AND PPRID = 546;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 9567 
WHERE PPRIDCUENTA = 50327 AND PPRID = 546;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 546;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 9567
WHERE DPAIDPAGOPROGRAMADO = 546 AND DPAID = 47;

 
Commit;


-- 11.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 70113451	55856	MONTOYA ARISTIZABAL JUAN ALBERTO	 $ 14.350 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 55856 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 55856 AND PPRID = 702;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 14350 
WHERE PPRIDCUENTA = 55856 AND PPRID = 702;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 702;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 14350
WHERE DPAIDPAGOPROGRAMADO = 702 AND DPAID = 203;

 
Commit;

-- 12.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 70552924	56498	TORO BOTERO FEDERICO	 $ 14.350 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 56498 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 56498 AND PPRID = 717;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 14350 
WHERE PPRIDCUENTA = 56498 AND PPRID = 717;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 717;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 14350
WHERE DPAIDPAGOPROGRAMADO = 717 AND DPAID = 218;

 
Commit;


-- 13.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 71591003	50656	CORREA PARRA JUAN FERNANDO	 $ 19.133 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50656 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50656 AND PPRID = 504;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 19133 
WHERE PPRIDCUENTA = 50656 AND PPRID = 504;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 504;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 19133
WHERE DPAIDPAGOPROGRAMADO = 504 AND DPAID = 5;

 
Commit;


-- 14.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 79110478	50239	VILLAREAL RIVERA EDGAR	 $ 9.567 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50239 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50239 AND PPRID = 543;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 9567 
WHERE PPRIDCUENTA = 50239 AND PPRID = 543;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 543;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 9567
WHERE DPAIDPAGOPROGRAMADO = 543 AND DPAID = 44;

 
Commit;

--15.
-- CEDULA	CUENTA	NOMBRE	VALOR PAGO
-- 79313606	50036	MUÑOZ REBOLLEDO LUIS CARLOS	 $ 9.567 

-- 1. Pago Programado
-- Consultar el periodo de pago indicado por el usuario, columnas (PPRDSPERIODOFINALPAGO, PPRDSPERIODOPRIMERPAGO)
SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50036 -- Se obtiene de la consulta anterior campo CUENTA
AND PPRIDPRODUCTOCOMPLEMENTARIO = 2 -- 2	PÓLIZA 86881 VIDA
AND PPRDSESTADOPAGOPROGRAMADO = 'APROBADO';


SELECT * FROM PREVCXN1.TPAG_PAGO_PROGRAMADO 
WHERE PPRIDCUENTA = 50036 AND PPRID = 529;

-- UPDATE
UPDATE PREVCXN1.TPAG_PAGO_PROGRAMADO SET PPRNMVALORPAGO = 9567
WHERE PPRIDCUENTA = 50036 AND PPRID = 529;


-- 2. Destinatario Pago Programado

SELECT * FROM PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO 
WHERE DPAIDPAGOPROGRAMADO = 529;

-- UPDATE
UPDATE PREVCXN1.TPAG_DESTI_PAGOPROGRAMADO SET DPANMVALORPAGO = 9567
WHERE DPAIDPAGOPROGRAMADO = 529 AND DPAID = 30;

 
Commit;


Spool Off;
