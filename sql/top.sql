set echo off feed off
set serveroutput on size 1000000 format wrapped
set lines 200 pages 9999

col schema format a15 trunc
col module format a20 trunc
col sql_text format a20 trunc
col sql_id format a13

-- variables declaration
variable db_name varchar2(30);
variable bid number;
variable eid number;
variable limit number;

-- variables definition
begin
    select name into :db_name from v$database;
    select max(snap_id)-1 into :bid from sys.dba_hist_snapshot where begin_interval_time < sysdate-4/24;
    select max(snap_id) into :eid from sys.dba_hist_snapshot;
    select 20 into :limit from dual;
end;
/

-- report name
set termout off;
column report_name new_value report_name noprint;
select :db_name || '_' || to_char(sysdate,'yyyy-mm-dd-hh24') || '.txt' report_name from dual;
set termout on;

spool &report_name;

-- time period
alter session set NLS_TIMESTAMP_FORMAT="YYYY-MM-DD HH24:MI:SS";
select snap_id id,end_interval_time time from dba_hist_snapshot where snap_id = :bid and rownum = 1
union all
select snap_id id,end_interval_time time from dba_hist_snapshot where snap_id = :eid and rownum = 1;

-- top sql plan
col inst_id format 9
col text for a20 trunc
col last_load_time for a25

exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL plans by CPU');

with m as
(select *
  from (select sql_plan_hash_value, sql_plan_line_id, count(*) cnt
    from gv$active_session_history
    where session_state = 'ON CPU'
    and sample_time > sysdate - 4/24
    group by sql_plan_hash_value, sql_plan_line_id
    having count(*) > 100
    order by cnt desc
  )
  where rownum <= 20)
select
m.sql_plan_hash_value plan,
m.sql_plan_line_id    line,
m.cnt                 count,
a.inst_id             inst_id,
a.sql_id              sql_id,
a.parsing_schema_name schema,
a.module              module,
a.last_load_time      last_load_time
-- a.sql_text            text,
from m
left join (select
  inst_id,
  PLAN_HASH_VALUE,
  sql_id,
  last_load_time,
  sql_text,
  parsing_schema_name,
  module,
  row_number() over(partition by plan_hash_value order by last_load_time desc) rn
  from gv$sql) a
on m.sql_plan_hash_value = a.plan_hash_value
where rn = 1
and sql_plan_hash_value != 0
order by cnt desc
;

-- top sqls
exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by buffer gets');

SELECT
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'buffer_gets',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by CPU time');

SELECT 
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'cpu_time',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by Disk Reads');

SELECT 
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'disk_reads',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by elapsed time');

SELECT
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'elapsed_time',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by executions');

SELECT
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'executions',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by fetches');

SELECT
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'fetches',
        result_limit     => :limit
    )
);


exec dbms_output.new_line;
exec dbms_output.new_line;
exec dbms_output.put_line('Top SQL by rows processed');

SELECT
sql_id,
plan_hash_value,
parsing_schema_name schema,
round(elapsed_time/1000/1000) etime,
round(cpu_time/1000/1000) cpu_time,
round(buffer_gets*8/1024/1024) gets_G,
round(disk_reads*8/1024/1024) reads_G,
rows_processed,
fetches,
executions,
substr(sql_text,0,20) sql_text,
module
FROM table(
    DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(
        begin_snap       => :bid,
        end_snap         => :eid,
        --basic_filter     => 'parsing_schema_name <> ''SYS''',
        ranking_measure1 => 'rows_processed',
        result_limit     => :limit
    )
);

spool off;
exit;
