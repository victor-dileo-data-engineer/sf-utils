
/*** SP THAT GETS TABLE ROWCOUNTS FOR TABLES IN <DB> <SCHEMA> ***/
use database scd2_a;

call proc_load_table_counts('PGE', 'DYN_TABLES');

select * from MYOWN_DB.PUBLIC.DAILY_TABLE_COUNTS;


CREATE OR REPLACE PROCEDURE "PROC_LOAD_TABLE_COUNTS"("DB" VARCHAR, "SCH" VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS '
    var err = '''';
 var procName = Object.keys(this)[0];
 var procResult = ''SUCCESSFULLY COMPLETED'';
    
    try
    {
        var dbase = DB;
  var table_list = `SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME FROM `+dbase+`.INFORMATION_SCHEMA.TABLES WHERE TABLE_CATALOG = ? and TABLE_SCHEMA = ?`;
  
  var table_list_stmt = snowflake.createStatement({sqlText: table_list, binds : [DB, SCH]});
  
  var exe_table_list_stmt = table_list_stmt.execute();
  
  while (exe_table_list_stmt.next())
  {
   var dbname = exe_table_list_stmt.getColumnValue(''TABLE_CATALOG'');
   var schname = exe_table_list_stmt.getColumnValue(''TABLE_SCHEMA'');
   var tblname = exe_table_list_stmt.getColumnValue(''TABLE_NAME'');
   
   var row_count_qry = `SELECT COUNT(1) as CNT FROM `+dbname+`.`+schname+`.`+tblname+`;`;
   var row_count_stmt = snowflake.createStatement({sqlText: row_count_qry});
   var exe_row_count_stmt = row_count_stmt.execute();
   
   exe_row_count_stmt.next();
   var row_count = exe_row_count_stmt.getColumnValue(''CNT'');
   
   var insrt_qry = `INSERT INTO MYOWN_DB.PUBLIC.DAILY_TABLE_COUNTS(LOAD_TIME, DATABASE_NAME, SCHEMA_NAME, TABLE_NAME, TABLE_COUNT) VALUES(CURRENT_TIMESTAMP,''`+dbname+`'',''`+schname+`'',''`+tblname+`'',`+row_count+`);`;
   var insrt_qry_stmt = snowflake.createStatement({sqlText: insrt_qry});
   var exe_insrt_qry_stmt = insrt_qry_stmt.execute();
  }
 }
 
 catch(err)
 {
  var error_query = `INSERT INTO MYOWN_DB.PUBLIC.PROC_ERROR_LOG(PROC_NAME, RUN_TIME, ERROD_CD, ERROR_MSG, ERROR_LINE) VALUES(''`+procName+`'', CURRENT_TIMESTAMP,''`+err.code+`'',''`+err.message.replace(/\\''/g, "")+`'',''`+err.stackTraceTxt+`'');`;
  var error_query_stmt = snowflake.createStatement({sqlText: error_query});
  var exe_error_query_stmt = error_query_stmt.execute();
  
  procResult = `FAILED, CHECK PROC_ERROR_LOG TABLE FOR ERROR DETAILS`;
 }
 
return procResult;
';

