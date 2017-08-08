#!/bin/bash
#Create multi dbs
for i in `seq 99`
do  
    #db='db'$i
    #echo 'db name is is:'$db
    cmd='create  database dbs'$i';'
    echo "commond is:$cmd"
    mysql -uprnp -pprnp -e "$cmd"
done  