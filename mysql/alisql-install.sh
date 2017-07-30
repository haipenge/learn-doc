#alisql install scripts
#Cent OS
 yum install centos-release-scl -y
 yum install devtoolset-4-gcc-c++ devtoolset-4-gcc -y
 yum install cmake git -y
 yum install ncurses-devel openssl-devel bison -y

#ubuntu 16.04
apt-get update -y
apt-get install git gcc g++ cmake -y
apt-get install bison libncurses5-dev zlib1g-dev libssl-dev -y

scl enable devtoolset-4 bash
cmake .                              \
-DCMAKE_BUILD_TYPE="Release"         \
-DCMAKE_INSTALL_PREFIX="/opt/alisql" \
-DWITH_EMBEDDED_SERVER=0             \
-DWITH_EXTRA_CHARSETS=all            \
-DWITH_MYISAM_STORAGE_ENGINE=1       \
-DWITH_INNOBASE_STORAGE_ENGINE=1     \
-DWITH_PARTITION_STORAGE_ENGINE=1    \
-DWITH_CSV_STORAGE_ENGINE=1          \
-DWITH_ARCHIVE_STORAGE_ENGINE=1      \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1    \
-DWITH_FEDERATED_STORAGE_ENGINE=1    \
-DWITH_PERFSCHEMA_STORAGE_ENGINE=1   \
-DWITH_TOKUDB_STORAGE_ENGINE=1       \


 make -j4 && make install

#配置并启动
groupadd mysql
useradd -M -s/sbin/nologin -g mysql -r mysql
useradd -g mysql -r mysql
#middel my.cnf
./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=/app/data/alisql/data3029/data
#small my.cnf
./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=/app/data/alisql/data3030/data

mkdir data mysql
[root@spade alisql]cd /opt/alisql
[root@spade alisql]# ./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=/app/data/alisql/data3029/dbs3029/data  ##这一步是为了初始时数据库
[root@spade alisql]# cp ./support-files/my-default.cnf /etc/my.cnf
[root@spade alisql]# cp ./support-files/mysql.server /etc/init.d/mysqld 
[root@spade alisql]# chmod +x /etc/init.d/mysqld 
[root@spade alisql]# chown -R mysql:mysql /opt/alisql  ##这一步很重要  注意看清楚*****
[root@spade alisql]# echo "export PATH=$PATH:/opt/alisql/bin">>/etc/profile
[root@spade alisql]# source /etc/profile
[root@spade alisql]# service mysqld start





关于配置disable-transparent-hugepages服务

vi /etc/init.d/disable-transparent-hugepages

#!/bin/bash
### BEGIN INIT INFO
# Provides: disable-transparent-hugepages
# Required-Start: $local_fs
# Required-Stop:
# X-Start-Before: mongod mongodb-mms-automation-agent
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description: Disable Linux transparent huge pages, to improve
# database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    re='^[0-1]+$'
    if [[ $(cat ${thp_path}/khugepaged/defrag) =~ $re ]]
    then
      # RHEL 7
      echo 0 > ${thp_path}/khugepaged/defrag
    else
      # RHEL 6
      echo 'no' > ${thp_path}/khugepaged/defrag
    fi

    unset re
    unset thp_path
    ;;
esac


对该服务授权，并设置开机自启动
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
sudo chkconfig --add disable-transparent-hugepages


重启服务器，并检查该参数是否已经生效
# cat /sys/kernel/mm/redhat_transparent_hugepage/enabled
always madvise [never]
# cat /sys/kernel/mm/redhat_transparent_hugepage/defrag
always madvise [never]


To disable THP, do the following:

Remount the /sys directory as read-write:

$ sudo mount -o rw,remount /sys

As root, change permissions as follows. Be sure to replace transparent_hugepage with the value for your system.

$ chmod o+w /sys/kernel/mm/transparent_hugepage/enabled

$ chmod o+w /sys/kernel/mm/transparent_hugepage/defrag

As root, run the following commands. Be sure to replace transparent_hugepage with the value for your system.

$ echo madvise > /sys/kernel/mm/transparent_hugepage/enabled

$ echo madvise > /sys/kernel/mm/transparent_hugepage/defrag


#解决Innodb 问题
1).
drop table if exists innodb_index_stats; \
drop table if exists innodb_table_stats; \
drop table if exists slave_master_info; \
drop table if exists slave_relay_log_info; \
drop table if exists slave_worker_info;
2).
删除上面5个表所对应的idb文件
3).

./scripts/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf --basedir=/opt/alisql --datadir=/app/data/alisql/data3306/data
