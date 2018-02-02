#!/bin/bash
#####################################
#Init mysql 5.7 scripts
#Write by haipenge
#Date:2018.02.01
#####################################
echo 'init mysql scripts. '
datadir=/data
install_dir=
if [ ! -x "$datadir" ]; then
  mkdir -p $datadir $datadir/db  $datadir/mysql
  chown -R mysql:mysql $datadir
  cd /opt/alisql
  #mv /etc/my.cnf /tmp
  ./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=$datadir/db
  # mv /tmp/my.cnf /etc
  # cp /app/data/build/faceye-docker/docker-ubuntu-16.04-alisql/my-middle.cnf /etc/my.cnf
   cp /opt/tools/alisql/conf/my-8C16G.cnf /etc/my.cnf
   service mysqld start
   ln -s $datadir/tmp/mysql.sock /tmp/mysql.sock
   cd /opt/alisql
   ./bin/mysqladmin -u root password 'root'
else
   service mysqld start
   ln -s $datadir/tmp/mysql.sock /tmp/mysql.sock
fi
