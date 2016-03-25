#!/bin/bash

source /opt/myawr/config.sh

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
   sqlplus $USER/$PASS@$DB @$MYAWR/sql/myaddmrpt

done < $MYAWR/ps/inst.txt
