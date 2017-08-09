#!/bin/bash
#Create multi dbs
mysqldump -uprnp -pprnp -h 10.11.100.156 -P13306  -c --skip-add-locks dbs0 interface_data_todisk > /tmp/nuc_interface_data_todisk_0.sql
for i in `seq 299`
do  
    #db='db'$i
    #echo 'db name is is:'$db
    cmd='mysqldump -uprnp -pprnp  -c --skip-add-locks dbs'$i' interface_data_todisk >/tmp/nuc_interface_data_todisk_'$i'.sql;'
    echo "commond is:$cmd"
    mysqldump -uprnp -pprnp -h 10.11.100.156 -P13306  -c --skip-add-locks dbs$i interface_data_todisk > /tmp/nuc_interface_data_todisk_$i.sql
done