#/bin/bash
#启动centos-7-mysql
#Author:haipenge
#Date:2017.10.26
docker run --privileged -itd  -v /opt/data/docker-mysql57-3306:/data -v /opt/data/soft:/app -v /etc/localtime:/etc/localtime:ro -p 3306:3306  centos-7-mysql /usr/sbin/init
