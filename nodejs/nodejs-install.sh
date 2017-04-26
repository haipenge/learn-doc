##############################
#Node Install script
#Author:haipenge@gmail.com
#Date:2016.02.25
##############################
#Prepare
ROOT=$(cd $(dirname '$0');pwd)
cd $ROOT
node_version=v4.3.1
yum -y install gcc make gcc-c++ openssl-devel wget
wget https://nodejs.org/dist/$node_version/node-$node_version.tar.gz
#wget https://nodejs.org/dist/v4.3.1/node-v4.3.1.tar.gz
tar -zxvf node-$node_version.tar.gz
cd node-$node_version
./configure
make && make install
node -v 
#ln -s /usr/local/bin/node /usr/bin/node
#ln -s /usr/local/lib/node /usr/lib/node
#ln -s /usr/local/bin/npm /usr/bin/npm
#ln -s /usr/local/bin/node-waf /usr/bin/node-waf
#安装Grunt
#wget  http://npmjs.org/install.sh .
#chmod +x install.sh 
#./install.sh
#npm install -g grunt-cli
exit 0