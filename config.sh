## oracle 11g, should install the server software
umask 022
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export PATH=$PATH:HOME/bin:$ORACLE_HOME/bin
export NLS_DATE_FORMAT="yyyy-mm-dd HH24:MI:SS"
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK

## myawr config
# username and password
USER=awruser
PASS='Addm#16'

# where to put awr files
AWRBASE=/awr

# where to install the myawr
MYAWR=/opt/myawr

# today's date
datenow=`date +%Y%m%d`
