# the ps directory
db.txt:  passwords for awrgrpt, must be 11g database
inst.txt: passwords for awrrpt and addmrpt

# How to run AWR report?
## run automatically
### Automatic Workload Repository
```
?/rdbms/admin/awrrpt.sql
```

### AWR Global Cluster Report (must sysdba, 11g new feature)
```
?/rdbms/admin/awrgrpt.sql
```

### Automatic Database Diagnostic Monitor 
```
?/rdbms/admin/addmrpt.sql
```

## run manually
### Active Session History
```sql
-- A script to generate the lastest x minutes ASH report.
?/rdbms/admin/ashrpt.sql
```
## Automatic Database difference Report 
```
?/rdbms/admin/awrddrpt.sql
```

## AWR Global Cluster Difference Report
```
?/rdbms/admin/awrgdrpt.sql
```

## AWR SQL Report
```
?/rdbms/admin/awrsqrpt.sql
```
