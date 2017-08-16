wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz .
wget http://zlib.net/zlib-1.2.11.tar.gz
wget http://www.openssl.org/source/openssl-1.0.21.tar.gz .
wget http://nginx.org/download/nginx-1.13.0.tar.gz .


./configure --sbin-path=/usr/local/nginx \
--prefix=/usr/local/nginx \
--conf-path=/usr/local/nginx/conf/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_ssl_module \
--with-pcre=/tmp/nginx/pcre-8.40 \
--with-zlib=/tmp/nginx/zlib-1.2.11 \
--with-openssl=/tmp/nginx/openssl-1.0.2l