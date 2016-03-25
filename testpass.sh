#!/bin/bash

source /opt/myawr/config.sh

# read file 
while read DB USER PASS; 
  do 
   echo sqlplus $USER/$PASS@$DB as sysdba @$MYAWR/sql/test.sql
done < $MYAWR/ps/inst.txt.bak
