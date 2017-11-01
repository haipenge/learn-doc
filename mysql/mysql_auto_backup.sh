#/bin/bash
ls_date=`date '+%Y-%m-%d %H:%M:%S'`
echo $ls_date
write_date=`date '+%Y%m%d'`
sql_date=`date '+%Y-%m-%d'`
sql_date=${sql_date}' 00:00:00'
backup_cmd="mysqldump -uprnp -pprnp -c --skip-add-locks --skip-add-drop-table -d nuc_indivuser --tables  ec_indivuser  -w CheckDate>='"$sql_date"' >/home/prnp/bak/ec_indivuser_"$write_date".sql"
echo $backup_cmd

mysqldump -uprnp -pprnp -c --skip-add-locks --skip-add-drop-table nuc_indivuser ec_indivuser --where= "CheckDate >='2017-09-20 00:00:00'" > /home/prnp/bak/ec_indivuser_20170920.sql



"CheckDate >='"$sql_date"'"'"' > /home/prnp/bak/ec_indivuser_"$write_date".sql"