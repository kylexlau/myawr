#!/bin/bash

source /root/awr/11g
AWRBASE=/awr
SQLDIR=/root/awr/sql

# date
datenow=`date +%Y%m%d`
USER=awruser
PASS=awrpass

# read file 
while read DB;
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
   sqlplus $USER/$PASS@$DB @$SQLDIR/myawrrpt
   
done < /root/awr/ps/inst.txt
