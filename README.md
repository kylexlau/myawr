# Configure

- db.txt:  database tnsname, dbversion > 11g
- inst.txt: instance tnsname

```sql
-- Create a user for awr generating
create user awruser identified by awrpass;
grant create session to awruser;
grant select any dictionary to awruser;
grant execute on dbms_workload_repository to awruser;
grant execute on dbms_advisor to awruser;
```

# How to run AWR report?

```sql 
---- run automatically
-- Automatic Workload Repository
?/rdbms/admin/awrrpt.sql

-- AWR Global Cluster Report (must sysdba, 11g new feature)
?/rdbms/admin/awrgrpt.sql

-- Automatic Database Diagnostic Monitor 
?/rdbms/admin/addmrpt.sql

---- run manually
-- Active Session History
-- A script to generate the lastest x minutes ASH report.
?/rdbms/admin/ashrpt.sql

-- Automatic Database difference Report 
?/rdbms/admin/awrddrpt.sql

-- AWR Global Cluster Difference Report
?/rdbms/admin/awrgdrpt.sql

-- AWR SQL Report
?/rdbms/admin/awrsqrpt.sql
```
