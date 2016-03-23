#!/bin/bash

source /root/awr/11g
AWRBASE=/awr
SQLDIR=/root/awr/sql

# date
datenow=`date +%Y%m%d`

# read file 
while read DB USER PASS; 
  do 
   sqlplus $USER/$PASS@$DB as sysdba @/root/awr/sql/test.sql
done < /root/awr/ps/db.txt
