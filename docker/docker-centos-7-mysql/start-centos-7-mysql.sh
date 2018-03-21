#!/bin/bash
#docker centos-7 mysql5.7 启动脚本
#author:haipenge
#date:2018.02.02
echo '>>> start docker centos-7 + mysql5.7 now,please wait ....'
docker run --privileged -dit  -v /data/mysql-33306:/data  -v /etc/localtime:/etc/localtime:ro -p 33306:3306  centos-7-mysql /usr/sbin/init
echo '<<< finish start docker centos-7 mysql 5.7,docker exec -it <container_id> /bin/bash'
exit 0