#!/bin/bash
#####################################
#Init mysql 5.7 scripts
#Write by haipenge
#Date:2018.02.01
#Dir:/app/shell/init-mysql-scripts.sh
#####################################
echo 'start to init mysql scripts. '
datadir=/data/mysql
if [ ! -x "$datadir" ]; then
  mkdir -p $datadir/data
  #初始经数据库
  #/usr/sbin/mysqld --initialize --user=root  --basedir=/data/mysql --datadir=/data/mysql/data   --explicit_defaults_for_timestamp
  /usr/sbin/mysqld --initialize --user=root  --datadir=$datadir/data   --explicit_defaults_for_timestamp
  # mv /tmp/my.cnf /etc
  # cp /app/data/build/faceye-docker/docker-ubuntu-16.04-alisql/my-middle.cnf /etc/my.cnf
   #cp /opt/tools/alisql/conf/my-8C16G.cnf /etc/my.cnf
   #service mysqld start
   #ln -s $datadir/tmp/mysql.sock /tmp/mysql.sock
   #cd /opt/alisql
   #./bin/mysqladmin -u root password 'root'
   #启动MySQL 服务
   #docker 环境下
   /usr/sbin/mysqld --daemonize --pid-file=$datadir/mysqld.pid --user=root
   #非docker环境
   #systemctl start mysqld.service
   echo '<<< Finish init mysql .please change password now.'
   echo '<<< 1. cat '$datadir'/mysqld.log|grep password '
   echo '<<< 2. mysqladmin -u root -p password * '
else
   #启动MySQL 服务
   #docker 环境下
   /usr/sbin/mysqld --daemonize --pid-file=$datadir/mysqld.pid --user=root
   #非docker环境
   #systemctl start mysqld.service
   #service mysqld start
   #ln -s $datadir/tmp/mysql.sock /tmp/mysql.sock
   echo '>> Finish start mysql now.'
   tail $datadir/mysqld.log
fi

