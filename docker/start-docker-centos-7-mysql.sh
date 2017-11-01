#/bin/bash
#启动centos-7-mysql
#Author:haipenge
#Date:2017.10.26
docker run -itd centos-7-mysql /bin/bash -v /opt/docker-mysql-3306:/data -v /opt/soft:/app -v /etc/localtime:/etc/localtime:ro -p 3306:3306 /bin/bash