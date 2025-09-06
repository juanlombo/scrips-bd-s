#######################################################################
#   PSO TOTAL EN GB DE TABLAS (tamaño individual por tabla en GB.)    #
####################################################################### 
SET LINESIZE 200
SET PAGESIZE 200
COLUMN TABLE_NAME FORMAT A35
COLUMN OWNER FORMAT A20
COLUMN SIZE_GB FORMAT 999,999.99

SELECT 
    OWNER, 
    SEGMENT_NAME AS TABLE_NAME, 
    ROUND(SUM(BYTES) / 1024 / 1024 / 1024, 2) AS SIZE_GB
FROM DBA_SEGMENTS
WHERE (OWNER, SEGMENT_NAME) IN (
    ('GEOINT','TICKETS'),
    ('GEOINT','PAYMENTS'),
    ('GEOPOS','PAYMENTS'),
    ('GEOPOS','BONO_REPORT'),
    ('GEOPOS','DISCOUNTS'),
    ('GEOPOS','TICKETITEMS'),
    ('GEOPOS','TICKETS'),
    ('GEOPOS','FINANCE_TRANSACTION'),
    ('GEOPOS','MPCHANGES'),
    ('GEOINT','ACCOUNTINGENTRIES'),
    ('GEOPOS','TICKETITEMPROPERTIES')
)
AND SEGMENT_TYPE = 'TABLE'
GROUP BY OWNER, SEGMENT_NAME
ORDER BY SIZE_GB DESC;


#############################################
#  SUMA DE TODAS LA TABLAS
#############################################

SELECT 
    ROUND(SUM(BYTES) / 1024 / 1024 / 1024, 2) AS TOTAL_GB
FROM DBA_SEGMENTS
WHERE (OWNER, SEGMENT_NAME) IN (
    ('GEOINT','TICKETS'),
    ('GEOINT','PAYMENTS'),
    ('GEOPOS','PAYMENTS'),
    ('GEOPOS','BONO_REPORT'),
    ('GEOPOS','DISCOUNTS'),
    ('GEOPOS','TICKETITEMS'),
    ('GEOPOS','TICKETS'),
    ('GEOPOS','FINANCE_TRANSACTION'),
    ('GEOPOS','MPCHANGES'),
    ('GEOINT','ACCOUNTINGENTRIES'),
    ('GEOPOS','TICKETITEMPROPERTIES')
)
AND SEGMENT_TYPE = 'TABLE';




SET LINESIZE 200
SET PAGESIZE 200
COLUMN owner FORMAT A20
COLUMN segment_name FORMAT A35
COLUMN size_mb FORMAT 999,999,999.99

SELECT owner,
       segment_name AS table_name,
       ROUND(SUM(bytes)/1024/1024,2) AS size_mb,
       ROUND(SUM(bytes)/1024/1024/1024,2) AS size_gb
FROM dba_segments
WHERE segment_type='TABLE'
  AND segment_name LIKE '%CLIENT%'
GROUP BY owner, segment_name
ORDER BY size_mb DESC;


#########################################
#   PESO TB & INDEX Y TOTAL EN GB       #
#########################################

SET LINESIZE 200
SET PAGESIZE 200
COLUMN TABLE_NAME FORMAT A35
COLUMN OWNER FORMAT A20
COLUMN TABLE_GB FORMAT 999,999.99
COLUMN INDEX_GB FORMAT 999,999.99
COLUMN TOTAL_GB FORMAT 999,999.99

WITH sizes AS (
    SELECT owner, segment_name, segment_type, bytes
    FROM dba_segments
    WHERE (owner, segment_name) IN (
        ('SGF_ALKOSTO','CLIENTS')
        -- ('GEOINT','PAYMENTS'),
        -- ('GEOPOS','PAYMENTS'),
        -- ('GEOPOS','BONO_REPORT'),
        -- ('GEOPOS','DISCOUNTS'),
        -- ('GEOPOS','TICKETITEMS'),
        -- ('GEOPOS','TICKETS'),
        -- ('GEOPOS','FINANCE_TRANSACTION'),
        -- ('GEOPOS','MPCHANGES'),
        -- ('GEOINT','ACCOUNTINGENTRIES'),
        -- ('GEOPOS','TICKETITEMPROPERTIES')
    )
)
SELECT t.owner,
       t.table_name,
       ROUND(SUM(CASE WHEN s.segment_type = 'TABLE' THEN s.bytes END) / 1024 / 1024 / 1024, 2) AS table_gb,
       ROUND(SUM(CASE WHEN s.segment_type = 'INDEX' THEN s.bytes END) / 1024 / 1024 / 1024, 2) AS index_gb,
       ROUND(SUM(s.bytes) / 1024 / 1024 / 1024, 2) AS total_gb
FROM dba_tables t
LEFT JOIN dba_segments s
       ON s.owner = t.owner
      AND (   s.segment_name = t.table_name
           OR s.segment_name IN (SELECT index_name
                                 FROM dba_indexes i
                                 WHERE i.table_owner = t.owner
                                   AND i.table_name = t.table_name))
WHERE (t.owner, t.table_name) IN (
    ('SGF_ALKOSTO','CLIENTS')
    -- ('GEOINT','PAYMENTS'),
    -- ('GEOPOS','PAYMENTS'),
    -- ('GEOPOS','BONO_REPORT'),
    -- ('GEOPOS','DISCOUNTS'),
    -- ('GEOPOS','TICKETITEMS'),
    -- ('GEOPOS','TICKETS'),
    -- ('GEOPOS','FINANCE_TRANSACTION'),
    -- ('GEOPOS','MPCHANGES'),
    -- ('GEOINT','ACCOUNTINGENTRIES'),
    -- ('GEOPOS','TICKETITEMPROPERTIES')
)
GROUP BY t.owner, t.table_name
ORDER BY total_gb DESC;


#########################################
#   PESO TB & INDEX Y TOTAL EN GB       #
#########################################
SET LINESIZE 200
SET PAGESIZE 200
COLUMN TABLE_NAME FORMAT A35
COLUMN OWNER FORMAT A20
COLUMN TABLE_GB FORMAT 999,999.99
COLUMN INDEX_GB FORMAT 999,999.99
COLUMN TOTAL_GB FORMAT 999,999.99

WITH tab_list AS (
    SELECT 'PS_BI_LINE_DST' FROM dual UNION ALL
    SELECT 'PS_BU_ITEMS_INV_T4' FROM dual UNION ALL
    SELECT 'PS_CM_DEPLETE_COST' FROM dual UNION ALL
    SELECT 'PS_DEMAND_PHYS_INV' FROM dual UNION ALL
    SELECT 'PS_BI_LINE_TAX' FROM dual UNION ALL
    SELECT 'PS_CM_DEPLETION' FROM dual UNION ALL
    SELECT 'PS_CM_TRANSACTION' FROM dual UNION ALL
    SELECT 'PS_CK_MTPREASG_AUD' FROM dual UNION ALL
    SELECT 'PS_ITEM' FROM dual UNION ALL
    SELECT 'PS_IN_RLS_DPI_TAO' FROM dual UNION ALL
    SELECT 'PS_IN_DEMAND_ADDR' FROM dual UNION ALL
    SELECT 'PS_BCT_DTL' FROM dual UNION ALL
    SELECT 'PS_MESSAGE_LOGPARM_HIST' FROM dual UNION ALL
    SELECT 'PSAUDIT' FROM dual UNION ALL
    SELECT 'PS_BI_EXTRCT_LINE' FROM dual UNION ALL
    SELECT 'PSAPMSGPUBDATA_H2206' FROM dual UNION ALL
    SELECT 'PS_CK_VNT_BRUT_AUX' FROM dual UNION ALL
    SELECT 'PS_INTFC_BI_CMP' FROM dual UNION ALL
    SELECT 'PS_AC_LIINV_TMP' FROM dual UNION ALL
    SELECT 'PS_ORD_SCHEDULE' FROM dual UNION ALL
    SELECT 'PS_CK_DESC2_LISTPR' FROM dual UNION ALL
    SELECT 'PS_VCHR_ACCTG_LINE' FROM dual UNION ALL
    SELECT 'PS_IN_DEMAND_BI' FROM dual UNION ALL
    SELECT 'PS_IN_RLS_DMD_TAO' FROM dual UNION ALL
    SELECT 'PS_MESSAGE_LOG_HIST' FROM dual UNION ALL
    SELECT 'PS_ORD_LINE' FROM dual UNION ALL
    SELECT 'PS_CK_REPORTES' FROM dual UNION ALL
    SELECT 'PS_BI_LINE_DS_DTL' FROM dual UNION ALL
    SELECT 'PS_PENDING_ITEM' FROM dual UNION ALL
    SELECT 'PS_BI_EXTRCT' FROM dual UNION ALL
    SELECT 'PS_BIACCTENTRY_C' FROM dual UNION ALL
)
SELECT t.owner,
       t.table_name,
       ROUND(SUM(CASE WHEN s.segment_type = 'TABLE' THEN s.bytes END)/1024/1024/1024,2) AS table_gb,
       ROUND(SUM(CASE WHEN s.segment_type = 'INDEX' THEN s.bytes END)/1024/1024/1024,2) AS index_gb,
       ROUND(SUM(s.bytes)/1024/1024/1024,2) AS total_gb
FROM dba_tables t
JOIN tab_list l ON UPPER(t.table_name) = UPPER(REGEXP_SUBSTR(l.name,'[^.]+$'))
LEFT JOIN dba_segments s
       ON s.owner = t.owner
      AND (   s.segment_name = t.table_name
           OR s.segment_name IN (SELECT index_name
                                 FROM dba_indexes i
                                 WHERE i.table_owner = t.owner
                                   AND i.table_name = t.table_name))
WHERE EXISTS (SELECT 1 FROM tab_list l2
              WHERE UPPER(t.table_name) = UPPER(REGEXP_SUBSTR(l2.name,'[^.]+$')))
GROUP BY t.owner, t.table_name
ORDER BY total_gb DESC;





SET LINESIZE 220
SET PAGESIZE 200
COLUMN OWNER      FORMAT A15
COLUMN TABLE_NAME FORMAT A35
COLUMN TABLE_GB   FORMAT 999,999.99
COLUMN INDEX_GB   FORMAT 999,999.99
COLUMN TOTAL_GB   FORMAT 999,999.99

WITH raw_names AS (
  -- Pega aquí todos los nombres (con o sin esquema). No uses UNION ALL.
  SELECT TRIM(REGEXP_REPLACE(column_value, '[[:cntrl:]]','')) AS name
  FROM TABLE(SYS.ODCIVARCHAR2LIST(
    'PS_CM_ACCTG_LINE',
    'PS_IN_DEMAND',
    'PS_BI_LINE',
    'PS_BI_ACCT_ENTRY',
    'PS_TRANSACTION_INV',
    'PS_BU_ITEMS_INV_T4_HIST',
    'PS_CK_EXTRAC_PRICE',
    'PS_ITEM_DST',
    'PS_CM_DEPLETE',
    'PS_LC_SALDOSTER_CA',
    'PS_CK_INTFC_VTAPOS',
    'PS_COMBO_DATA_TBL',
    'PS_PENDING_ITEM_RST',
    'PS_BI_HDR',
    'PS_CK_VTAPOS_HIST',
    'PS_CK_EXTRAC_VNR',
    'PS_CK_FL_ACUMULADO',
    'PS_CK_CONASS_TMP',
    'PS_LC_MOV_TER_CA',
    'PS_BU_ITEMS_INV_T4_HCO',
    'PS_BI_ACCT_LN_STG',
    'ZTRACECONCIL',
    'PS_ITEM_ACTIVITY',
    'PS_BI_LINE_DST',
    'PS_BU_ITEMS_INV_T4',
    'PS_CM_DEPLETE_COST',
    'PS_DEMAND_PHYS_INV',
    'PS_BI_LINE_TAX',
    'PS_CM_DEPLETION',
    'PS_CM_TRANSACTION'
    -- 'PS_CK_MTPREASG_AUD',
    -- 'PS_ITEM',
    -- 'PS_IN_RLS_DPI_TAO',
    -- 'PS_IN_DEMAND_ADDR',
    -- 'PS_BCT_DTL',
    -- 'PS_MESSAGE_LOGPARM_HIST',
    -- 'PSAUDIT',
    -- 'PS_BI_EXTRCT_LINE',
    -- 'PSAPMSGPUBDATA_H2206',
    -- 'PS_CK_VNT_BRUT_AUX',
    -- 'PS_INTFC_BI_CMP',
    -- 'PS_AC_LIINV_TMP',
    -- 'PS_ORD_SCHEDULE',
    -- 'PS_CK_DESC2_LISTPR',
    -- 'PS_VCHR_ACCTG_LINE',
    -- 'PS_IN_DEMAND_BI',
    -- 'PS_IN_RLS_DMD_TAO',
    -- 'PS_MESSAGE_LOG_HIST',
    -- 'PS_ORD_LINE',
    -- 'PS_CK_REPORTES',
    -- 'PS_BI_LINE_DS_DTL',
    -- 'PS_PENDING_ITEM',
    -- 'PS_BI_EXTRCT',
    -- 'PS_BIACCTENTRY_C',
    -- 'PS_GROUP_CONTROL',
    -- 'PS_LC_RET_FACT_HDR',
    -- 'PS_IN_DEMAND_CMNT',
    -- 'PS_CK_PRECOB_TMP1',
    -- 'PS_CK_MOVCOSMO_TBL',
    -- 'PS_CK_MOVGRBIT_TBL',
    -- 'PS_INTFC_BI_AD_CMP',
    -- 'PS_PENDING_DST',
    -- 'PS_ITEM_ACT_VAT',
    -- 'PSAPMSGPUBDATA',
    -- 'PS_CK_BI_HDR_FAELE',
    -- 'PS_CK_ITEM_TMP',
    -- 'PS_WS_ITEM_TMP',
    -- 'PS_CK_ER_FAELE_ENV',
    -- 'SYSADM.PS_BI_HDR',
    -- 'SYSADM.PS_BI_LINE',
    -- 'SYSADM.PS_BI_LINE_DST',
    -- 'SYSADM.PS_CK_FACTURA_HDR',
    -- 'SYSADM.PS_CM_PRODCOST',
    -- 'SYSADM.PS_CK_CONCESIONES',
    -- 'SYSADM.PS_TMP_INVENTARIO',
    -- 'SYSADM.PS_CK_BU_ITEMS_INV',
    -- 'PS_CK_PO_SCM_INFO',
    -- 'PS_CK_BU_ITEMSINV5',
    -- 'PS_CK_INFORME_RECA',
    -- 'PS_LEDGER',
    -- 'PS_MSR_HDR_INV',
    -- 'PS_ORD_HEADER_EC',
    -- 'PS_DISTRIB_LINE',
    -- 'PS_TRA_ACCTG_HDR',
    -- 'PS_TRA_ACCTG_LINE',
    -- 'PS_BI_HDR_NOTE',
    -- 'PS_CK_FILTRO_TBL',
    -- 'PS_CK_FL_VLR_FLT_F',
    -- 'PS_CK_GL_REAL_TI',
    -- 'PS_CK_ORD_HOLD_CAN',
    -- 'PS_CK_PDV_PET_TBL',
    -- 'PS_CK_RMA_HDR_TBL',
    -- 'PS_CM_COST_ADJ',
    -- 'PS_CM_CST_NSSHIP',
    -- 'PS_DEPOSIT_CONTROL',
    -- 'PS_DIST_LN',
    -- 'PS_BNK_RCN_TRAN',
    -- 'PS_CK_BNK_TRAN_CAJ',
    -- 'PS_CK_FL_PEEXI_TBL',
    -- 'PS_CK_JRNL_LN_TERC',
    -- 'PS_CK_LEGAL_FACTUR',
    -- 'PS_CK_PGPROV',
    -- 'PS_JGEN_ACCT_ENTRY',
    -- 'CK_IN_INVEN_TOTAL_POR_GRUP_UN',
    -- 'PS_CK_CART_AMORT',
    -- 'PS_CK_CART_FINANC',
    -- 'PS_CK_REP_CAR_DET',
    -- 'PS_CK_RESTITEM_TBL',
    -- 'PS_CUST_CGRP_LNK',
    -- 'PS_INV_STOCK_TYPE',
    -- 'PS_ORD_LINE_EC',
    -- 'PS_SF_OP_LIST',
    -- 'PS_TMP_VENTAS',
    -- 'PS_CK_COMPR_CLIENT',
    -- 'PS_CK_CONCESIONES',
    -- 'PS_CK_CUSTO_FAELEC',
    -- 'PS_CK_EVENTOS_CLIE',
    -- 'PS_CK_FILES_VTAPOS',
    -- 'PS_CK_LEG_TM_LINE',
    -- 'PS_JRNL_HEADER',
    -- 'PS_JRNL_LN',
    -- 'PS_ORD_HOLD',
    -- 'PS_PO_LINE_DISTRIB',
    -- 'PS_PROD_GROUP_TBL',
    -- 'PS_DEMAND_TI_VW',
    -- 'PS_CM_PRODCOST',
    -- 'PS_PROD_PGRP_LNK'
  ))
),
norm AS (
  SELECT
    name                                                   AS searched,
    CASE WHEN INSTR(name,'.')>0 THEN UPPER(SUBSTR(name,1,INSTR(name,'.')-1)) END AS req_owner,
    UPPER(REGEXP_SUBSTR(name,'[^.]+$'))                   AS req_object
  FROM raw_names
)
SELECT
  t.owner,
  t.table_name,
  NVL(ROUND(SUM(CASE WHEN s.segment_type='TABLE' THEN s.bytes END)/1024/1024/1024,2),0) AS table_gb,
  NVL(ROUND(SUM(CASE WHEN s.segment_type='INDEX' THEN s.bytes END)/1024/1024/1024,2),0) AS index_gb,
  NVL(ROUND(SUM(s.bytes)/1024/1024/1024,2),0)                                              AS total_gb
FROM dba_tables t
JOIN norm n
  ON ( n.req_owner IS NOT NULL AND t.owner = n.req_owner AND UPPER(t.table_name) = n.req_object )
  OR ( n.req_owner IS NULL     AND UPPER(t.table_name) = n.req_object )
LEFT JOIN dba_segments s
  ON s.owner = t.owner
 AND (
       s.segment_name = t.table_name
    OR s.segment_name IN (
         SELECT i.index_name
         FROM dba_indexes i
         WHERE i.table_owner = t.owner
           AND i.table_name  = t.table_name
       )
 )
GROUP BY t.owner, t.table_name
ORDER BY total_gb DESC;
