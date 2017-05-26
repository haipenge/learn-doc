#############################
#Name:Nginx install sh
#Author:haipenge
#Date:2016.01.14
#############################
#bin=`which "$0"`
#bin=`dirname "${bin}"`
#bin=`cd "$bin"; pwd`
#ROOT=$(dirname $(cd "$(dirname "$0")";pwd))
ROOT=$(cd $(dirname '$0');pwd)
cd $ROOT
#Prepare Dir
mkdir -p nginx openssl pcre zlib
#Version Config
PCRE_VERSION=8.40
ZLIB_VERSION=1.2.11
OPEN_SSL_VERSION=1.0.21
NGINX_VERSION=1.13.0
#####Prepare######################
yum -y install gcc automake autoconf libtool make
yum -y install gcc gcc-c++
yum -y install wget
yum -y update
###################################
#Install pcre
cd $ROOT/pcre
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$PCRE_VERSION.tar.gz .
tar -zxvf pcre-$PCRE_VERSION.tar.gz
cd pcre-$PCRE_VERSION
./configure
make
make install
###################################
#Install zlib
cd $ROOT/zlib
wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz
tar -zxvf zlib-$ZLIB_VERSION.tar.gz
cd zlib-$ZLIB_VERSION
./configure
make
make install
###################################
#Install openssl
cd $ROOT/openssl
wget http://www.openssl.org/source/openssl-$OPEN_SSL_VERSION.tar.gz .
tar -zxvf openssl-$OPEN_SSL_VERSION.tar.gz

###################################
#Install nginx
cd $ROOT/nginx
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz .
tar -zxvf nginx-$NGINX_VERSION.tar.gz
cd nginx-$NGINX_VERSION
./configure --sbin-path=$ROOT/nginx/nginx \
--prefix=$ROOT/nginx/nginx \
--conf-path=$ROOT/nginx/nginx/conf/nginx.conf \
--pid-path=$ROOT/nginx/nginx/nginx.pid \
--with-http_ssl_module \
--with-pcre=$ROOT/pcre/pcre-$PCRE_VERSION \
--with-zlib=$ROOT/zlib/zlib-$ZLIB_VERSION \
--with-openssl=$ROOT/openssl/openssl-$OPEN_SSL_VERSION
make
make install
#Start Nginx default port:80
$ROOT/nginx/nginx/nginx
echo '<<<<<<<<<<<<<<<<<<<<<<<Nginx Install Success>>>>>>>>>>>>>>>>>>>>>>>>>'
exit 0


