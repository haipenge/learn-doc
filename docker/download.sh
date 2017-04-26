####################Download Script###########################
#自动下载构建文件
#Include:
#1).ant
#2).maven
#Author:haipenge@gmail.com
##############################################################
ROOT=$(cd $(dirname '$0');pwd)
##版本
ANT_VERSION=1.9.6
M2_VERSION=3.3.9
JDK_VERSION=1.7.0_80
RESIN_VERSION=4.0.47
#初始化目录
cd $ROOT
mkdir -p ant maven resin
#下载Ant
cd $ROOT/ant
wget http://apache.fayea.com//ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz .
tar -zxvf apache-ant-$ANT_VERSION-bin.tar.gz
#下载Maven
cd $ROOT/maven
wget http://mirror.bit.edu.cn/apache/maven/maven-3/$M2_VERSION/binaries/apache-maven-$M2_VERSION-bin.tar.gz .
tar -zxvf apache-maven-$M2_VERSION-bin.tar.gz

##下载Resin
cd $ROOT/resin
wget http://caucho.com/download/resin-$RESIN_VERSION.tar.gz .
tar -zxvf resin-$RESIN_VERSION.tar.gz

##设置环境变量,环境变量可手工追加到/etc/profile中
ANT_HOME=$ROOT/ant/apache-ant-$ANT_VERSION
M2_HOME=$ROOT/maven/apache-maven-$MAVEN_VERSION
PATH=$M2_HOME/bin:$PATH
PATH=$ANT_HOME/bin:$PATH
export M2_HOME
export ANT_HOME
export PATH
####/etc/profile 配置示例
#JAVA_HOME=/usr/local/java/jdk1.7.0_80
#PATH=$JAVA_HOME/bin:$PATH
#CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#ANT_HOME=/data/tools/ant/apache-ant-1.9.6
#M2_HOME=/data/tools/maven/apache-maven-3.3.3
#PATH=$M2_HOME/bin:$PATH
#PATH=$ANT_HOME/bin:$PATH
#export M2_HOME
#export ANT_HOME
#export JAVA_HOME
#export PATH
#export CLASSPATH
