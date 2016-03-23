-- sqlplus setting
set echo off veri off feedback off termout on heading off linesize 1500

-- variables declaration
variable dbid number;
variable bid  number;
variable eid  number;
variable inst_name varchar2(20);	
variable inst_num  varchar2(20);	
variable task_name varchar2(20);	

-- variables definition
begin
select dbid into :dbid from v$database;
select instance_name into :inst_name from v$instance;
select instance_number into :inst_num from v$instance;
select max(snap_id)-1 into :bid from sys.dba_hist_snapshot where instance_number = :inst_num;
select max(snap_id) into :eid from sys.dba_hist_snapshot where instance_number = :inst_num;
end;
/

set termout off;
column report_name new_value report_name noprint;
select :inst_name || '_addmrpt_' || to_char(sysdate,'yyyymmdd')||'_' || to_char(to_char(sysdate,'hh24')-1) || '-' || to_char(sysdate,'hh24') || '.txt' report_name from dual;
set termout on;

-- advisor start
begin
  declare
    id number;
    name varchar2(100);
    descr varchar2(500);
  BEGIN
     name := '';
     descr := 'ADDM run: snapshots [' || :bid || ', '
              || :eid || '], instance ' || :inst_num
              || ', database id ' || :dbid;

     dbms_advisor.create_task('ADDM',id,name,descr,null);

     :task_name := name;

     -- set time window
     dbms_advisor.set_task_parameter(name, 'START_SNAPSHOT', :bid);
     dbms_advisor.set_task_parameter(name, 'END_SNAPSHOT', :eid);

     -- set instance number
     dbms_advisor.set_task_parameter(name, 'INSTANCE', :inst_num);

     -- set dbid
     dbms_advisor.set_task_parameter(name, 'DB_ID', :dbid);

     -- execute task
     dbms_advisor.execute_task(name);

  end;
end;
/

-- addm report
spool &report_name;

set long 1000000 pagesize 0 longchunksize 1000
column get_clob format a80

select dbms_advisor.get_task_report(:task_name, 'TEXT', 'TYPICAL')
from   sys.dual;

spool off;


exit;
