#############################
#Name:Nginx install sh
#Author:haipenge
#Date:2016.01.14
#############################################
#bin=`which "$0"`
#bin=`dirname "${bin}"`
#bin=`cd "$bin"; pwd`
#ROOT=$(dirname $(cd "$(dirname "$0")";pwd))
ROOT=$(cd $(dirname '$0');pwd)
cd $ROOT
mkdir nginx
mkdir openssl
mkdir pcre
mkdir zlib
#####Prepare###############
yum -y install gcc automake autoconf libtool make
yum -y install gcc gcc-c++
yum -y install wget
yum -y update

######Version Config################
PCRE_VERISON=8.41
ZLIB_VERSION=1.2.11
OPEN_SSL_VERSION=1.0.2n
NGINX_VERSION=1.13.8

#Install pcre
cd $ROOT/pcre
wget https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERISON.tar.gz
#wget https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz .
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
echo '<<<<<<<<<<<<<<<<<<<<<<<Finish Nginx Install>>>>>>>>>>>>>>>>>>>>>>>>>'
exit 0


