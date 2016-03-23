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
   echo Processing $DB ......
   sqlplus $USER/$PASS@$DB as sysdba @$SQLDIR/myaddmrpt
   
done < /root/awr/ps/inst.txt
