
create or replace view vw_mon_disk_spills
as
select warehouse_name
,      warehouse_size
,      count(*) as queries
,      round(avg(total_elapsed_time)/1000/60,1) as avg_elapsed_mins
,      round(avg(execution_time)/1000/60,1) as avg_exe_mins
,      count(iff(bytes_spilled_to_local_storage/1024/1024/1024 > 1,1,null)) as spilled_queries
,      round(avg(bytes_spilled_to_local_storage/1024/1024/1024))  as avg_local_gb
,      round(avg(bytes_spilled_to_remote_storage/1024/1024/1024)) as avg_remote_gb
from snowflake.account_usage.query_history
where true
and   warehouse_size is not null
and   datediff(days, end_time, current_timestamp()) <= 7
and   bytes_spilled_to_local_storage > 1024 * 1024 * 1024
group by all
order by 7 desc
limit 100;



