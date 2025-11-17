-- CREATE SCHEMA IF NOT EXISTS PUSH_TO_S3;
CREATE SCHEMA IF NOT EXISTS SP_SCD2_C;
USE SCHEMA SP_SCD2_C;

SELECT ID, ORDINAL_POSITION,
CASE ID WHEN 1 THEN 'SHA2_BINARY('
        WHEN 2 THEN 'IFNULL(NULLIF(UPPER(TRIM(TO_CHAR(' || SHA2_COLS || '))), ' || '''''' ||'), ' || '''^^'') ||'  
        WHEN 3 THEN 'IFNULL(NULLIF(UPPER(TRIM(TO_CHAR(' || SHA2_COLS || '))), ' || '''''' ||'), ' || '''^^'') '
        WHEN 4 THEN ')'
        END AS SHA2_COLS
FROM
(
SELECT 1 AS ID, 0 AS ORDINAL_POSITION, 'X' AS SHA2_COLS
UNION
SELECT 2 AS ID, ORDINAL_POSITION, 'X' AS SHA2_COLS
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SRC_CUST_DIM_BATCH_1' 
AND TABLE_CATALOG = 'PGE' 
AND TABLE_SCHEMA = 'SP_SCD2_C'
UNION
SELECT 3 AS ID, 999 AS ORDINAL_POSITION, 'X' AS SHA2_COLS
UNION
SELECT 4 AS ID, 1000 AS ORDINAL_POSITION, 'X' AS SHA2_COLS
ORDER BY ORDINAL_POSITION ASC
)
;

SELECT * -- 2 AS ID, ORDINAL_POSITION, 'X' AS SHA2_COLS
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SRC_CUST_DIM_INITIAL' AND TABLE_CATALOG = 'PGE' AND TABLE_SCHEMA = 'SP_SCD2_C';
;


SELECT TABLE_NAME, *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME LIKE '%SRC_CUST_DIM_INITIAL%'
LIMIT 1000;

/****************************************************************************************
****************************************************************************************
****************************************************************************************
****************************************************************************************
****************************************************************************************
****************************************************************************************
****************************************************************************************/




SELECT ---- for debugging -- ORDINAL_POSITION, 
       ---- for debugging -- LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) AS TEST1,
CASE 
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) = 1
     THEN 'SHA2_BINARY('
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) BETWEEN 2 AND 999 
          THEN 'IFNULL(NULLIF(UPPER(TRIM(TO_CHAR(' || SHA2_COLS || '))), ' || '''''' ||'), ' || '''^^'') || ' 
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) = 1000
          THEN 'IFNULL(NULLIF(UPPER(TRIM(TO_CHAR(' || SHA2_COLS || '))), ' || '''''' ||'), ' || '''^^'')'
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) = 0 
          THEN ')'
END AS "-- SHA2 STRING --",
FROM
(
SELECT 1 AS ID, 0 AS ORDINAL_POSITION, 'X' AS SHA2_COLS
UNION
SELECT 2 AS ID, ORDINAL_POSITION, COLUMN_NAME AS SHA2_COLS
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CASE' ------------------------------------ TABLE 
AND TABLE_SCHEMA = 'ONEVEG_STG_SC' --------------------------- SCHEMA
AND TABLE_CATALOG = 'ENT_RL_SALESFORCE_DB' ------------------- DB  
AND COLUMN_NAME NOT IN ('BATCH_ID', 'LOAD_TS')   --------------- COLUMNS TO EXCLUDE
UNION
SELECT 3 AS ID, 1000 AS ORDINAL_POSITION, ')' AS SHA2_COLS
ORDER BY ORDINAL_POSITION ASC
)
;




SELECT 
CASE 
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) = 1
     THEN 'SHA2_BINARY('
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) BETWEEN 2 AND 999 
          THEN 'IFNULL(NULLIF(UPPER(TRIM(TO_CHAR(' || SHA2_COLS || '))), ' || '''''' ||'), ' || '''^^'') || ' 
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) = 1000
          THEN 'IFNULL(NULLIF(UPPER(TRIM(TO_CHAR(' || SHA2_COLS || '))), ' || '''''' ||'), ' || '''^^'')'
     WHEN LEAD(ORDINAL_POSITION, 1, 0) OVER(ORDER BY ORDINAL_POSITION) = 0 
          THEN ')'
END AS "-- SHA2 STRING --",
FROM
(
SELECT 1 AS ID, 0 AS ORDINAL_POSITION, 'X' AS SHA2_COLS
UNION
SELECT 2 AS ID, ORDINAL_POSITION, COLUMN_NAME AS SHA2_COLS
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SRC_CUST_DIM_BATCH_1' ------------------------------------ TABLE 
AND TABLE_SCHEMA = 'SP_SCD2_C' --------------------------- SCHEMA
AND TABLE_CATALOG = 'PGE' ------------------- DB  
AND COLUMN_NAME NOT IN ('BATCH_ID', 'LOAD_TS', 'REF_UI_NOT_DATA')   --------------- COLUMNS TO EXCLUDE
UNION
SELECT 3 AS ID, 1000 AS ORDINAL_POSITION, ')' AS SHA2_COLS
ORDER BY ORDINAL_POSITION ASC
)
;






