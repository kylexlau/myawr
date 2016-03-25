#!/bin/bash

source /opt/myawr/config.sh

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
   sqlplus $USER/$PASS@$DB @$MYAWR/sql/myawrrpt
done < $MYAWR/ps/inst.txt
