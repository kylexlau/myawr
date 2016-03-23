#!/bin/bash

source /root/awr/11g
AWRBASE=/awr
SQLDIR=/root/awr/sql

# date
datenow=`date +%Y%m%d`

# read file 
while read DB USER PASS; 
  do 

   AWRDIR=$AWRBASE/$DB
   if [ ! -e $AWRDIR ]; then
     mkdir $AWRDIR
   fi 

   DATEDIR=$AWRDIR/$datenow
   if [ ! -e $DATEDIR ]; then
     mkdir $DATEDIR
   fi

   cd $DATEDIR
   sqlplus $USER/$PASS@$DB as sysdba @$SQLDIR/myawrgrpt
   
done < /root/awr/ps/db.txt
