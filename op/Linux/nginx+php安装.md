#PHP库文件\
wget
http://ncu.dl.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz\
wget
http://ncu.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz\
wget
http://ncu.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz\
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz\
yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng
libpng-devel freetype\
freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel
glib2 glib2-devel bzip2\
bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs
e2fsprogs-devel krb5 krb5-devel\
libidn libidn-devel openssl openssl-devel openldap openldap-devel
nss_ldap openldap-\
clients openldap-servers libicu\*\
./configure \--prefix=/usr/local/php
\--with-config-file-path=/usr/local/php/lib \--with-mcrypt -\
-with-gd \--enable-fpm \--with-fpm-user=www \--with-fpm-group=www
\--with-iconv \--with-\
zlib \--with-jpeg-dir \--with-freetype-dir \--with-png-dir
\--enable-mbstring \--enable-exif \--\
enable-zip \--enable-sockets \--enable-calendar \--enable-bcmath
\--enable-ftp \--enable-gd-\
native-ttf \--enable-gd-jis-conv \--enable-intl \--enable-soap
