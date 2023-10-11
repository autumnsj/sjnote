## Step 1: Update Ubuntu System



Let’s begin our installation of PHP 8.1 on Ubuntu 22.04|20.04|18.04 by ensuring the system has been updated and upgraded.

```
sudo apt update && sudo apt -y upgrade
```

After a successful OS upgrade, I recommend you reboot the system:



```
sudo systemctl reboot
```

## Step 2: Add Ondřej Surý PPA repository

Ubuntu 22.04 has PHP 8.1 packages and its extensions in the OS upstream repositories. For this reason Sury repository is not needed on Ubuntu 22.04.

For Ubuntu 20.04/18.04, PHP 8.1 binary packages are available in the[ Ondřej Surý PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php) repository. This repo has to be added manually on the system.

**Add Ondřej Surý PPA repository**

```
sudo apt update
sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
sudo add-apt-repository ppa:ondrej/php
```

The only input from you is to hit *<Enter key>* and add the repository:



```
Debian oldstable and stable packages are provided as well: https://deb.sury.org/#debian-dpa

You can get more information about the packages at https://deb.sury.org

IMPORTANT: The <foo>-backports is now required on older Ubuntu releases.

BUGS&FEATURES: This PPA now has a issue tracker:
https://deb.sury.org/#bug-reporting

CAVEATS:
1. If you are using php-gearman, you need to add ppa:ondrej/pkg-gearman
2. If you are using apache2, you are advised to add ppa:ondrej/apache2
3. If you are using nginx, you are advised to add ppa:ondrej/nginx-mainline
   or ppa:ondrej/nginx

PLEASE READ: If you like my work and want to give me a little motivation, please consider donating regularly: https://donate.sury.org/

WARNING: add-apt-repository is broken with non-UTF-8 locales, see
https://github.com/oerdnj/deb.sury.org/issues/56 for workaround:

# LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
 More info: https://launchpad.net/~ondrej/+archive/ubuntu/php
Press [ENTER] to continue or Ctrl-c to cancel adding it. <Press-Enter-Key>
```



Pull the latest packages list from configured sources on your Ubuntu system:



```
$ sudo apt update
Hit:1 http://ppa.launchpad.net/ondrej/php/ubuntu focal InRelease
Hit:2 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:3 http://nova.clouds.archive.ubuntu.com/ubuntu focal InRelease
Hit:4 http://nova.clouds.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:5 http://nova.clouds.archive.ubuntu.com/ubuntu focal-backports InRelease
Reading package lists... Done
Building dependency tree
Reading state information... Done
109 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

## Step 3: Install PHP 8.1

We should now be able to install PHP 8.1 on Ubuntu 22.04|20.04|18.04 Linux machine. The commands to run are as shared below:



```
sudo apt install php8.1
```

Hit the **y** key to start installation:



```
The following additional packages will be installed:
  apache2 apache2-bin apache2-data apache2-utils libapache2-mod-php8.1 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 liblua5.2-0 php-common php8.1-cli php8.1-common
  php8.1-opcache php8.1-readline ssl-cert
Suggested packages:
  apache2-doc apache2-suexec-pristine | apache2-suexec-custom www-browser php-pear openssl-blacklist
The following NEW packages will be installed:
  apache2 apache2-bin apache2-data apache2-utils libapache2-mod-php8.1 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 liblua5.2-0 php-common php8.1 php8.1-cli
  php8.1-common php8.1-opcache php8.1-readline ssl-cert
0 upgraded, 18 newly installed, 0 to remove and 109 not upgraded.
Need to get 6589 kB of archives.
After this operation, 29.4 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
```

```
apt remove apache2   #删除掉自带的apache2
```

Check for the current active version of PHP with the following command:

```
$ php --version
PHP 8.1.0 (cli) (built: Nov 23 2021 18:56:11) (NTS gcc x86_64)
Copyright (c) The PHP Group
Zend Engine v4.1.0, Copyright (c) Zend Technologies
    with Zend OPcache v8.1.0, Copyright (c), by Zend Technologies
```



## Step 4: Install PHP 8.1 Extensions

The command to install PHP 8.1 extensions on Ubuntu 22.04|20.04|18.04 is:



```
sudo apt install php8.1-<extension>
```

Where

- *<extension>* is to be replaced with the name of PHP extension to be installed. For example, ***mysql\***, ***zip\***, ***xml\*** e.t.c.

Some available extensions are as shown below:

```
$ sudo apt install php8.1-<TAB>
php8.1-amqp            php8.1-decimal         php8.1-grpc            php8.1-maxminddb       php8.1-opcache         php8.1-redis           php8.1-tidy            php8.1-yac
php8.1-apcu            php8.1-dev             php8.1-igbinary        php8.1-mbstring        php8.1-pcov            php8.1-rrd             php8.1-uopz            php8.1-yaml
php8.1-ast             php8.1-ds              php8.1-imagick         php8.1-mcrypt          php8.1-pgsql           php8.1-smbclient       php8.1-uploadprogress  php8.1-zip
php8.1-bcmath          php8.1-enchant         php8.1-imap            php8.1-memcache        php8.1-phpdbg          php8.1-snmp            php8.1-uuid            php8.1-zmq
php8.1-bz2             php8.1-fpm             php8.1-inotify         php8.1-memcached       php8.1-protobuf        php8.1-soap            php8.1-vips            php8.1-zstd
php8.1-cgi             php8.1-gd              php8.1-interbase       php8.1-mongodb         php8.1-ps              php8.1-solr            php8.1-xdebug
php8.1-cli             php8.1-gearman         php8.1-intl            php8.1-msgpack         php8.1-pspell          php8.1-sqlite3         php8.1-xhprof
php8.1-common          php8.1-gmagick         php8.1-ldap            php8.1-mysql           php8.1-psr             php8.1-ssh2            php8.1-xml
php8.1-curl            php8.1-gmp             php8.1-lz4             php8.1-oauth           php8.1-raphf           php8.1-swoole          php8.1-xmlrpc
php8.1-dba             php8.1-gnupg           php8.1-mailparse       php8.1-odbc            php8.1-readline        php8.1-sybase          php8.1-xsl
```

Example installing commonly used PHP extensions:

```
sudo apt install php8.1-{bcmath,xml,fpm,mysql,zip,intl,ldap,gd,cli,bz2,curl,mbstring,pgsql,opcache,soap,cgi}
```

To list all PHP 8.1 loaded modules run the following command:

```
$ php --modules
[PHP Modules]
bcmath
bz2
calendar
Core
ctype
curl
date
dom
exif
FFI
fileinfo
filter
ftp
gd
gettext
hash
iconv
intl
json
ldap
libxml
mbstring
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pgsql
Phar
posix
readline
Reflection
session
shmop
SimpleXML
soap
sockets
sodium
SPL
standard
sysvmsg
sysvsem
sysvshm
tokenizer
xml
xmlreader
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```

If using PHP with Nginx web browser ensure php-fpm service is started and running:



```
$ systemctl status php*-fpm.service
● php8.1-fpm.service - The PHP 8.1 FastCGI Process Manager
     Loaded: loaded (/lib/systemd/system/php8.1-fpm.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2021-11-20 19:40:34 UTC; 59s ago
       Docs: man:php-fpm8.1(8)
    Process: 25095 ExecStartPost=/usr/lib/php/php-fpm-socket-helper install /run/php/php-fpm.sock /etc/php/8.1/fpm/pool.d/www.conf 81 (code=exited, status=0/SUCCESS)
   Main PID: 25091 (php-fpm8.1)
     Status: "Processes active: 0, idle: 2, Requests: 0, slow: 0, Traffic: 0req/sec"
      Tasks: 3 (limit: 2344)
     Memory: 10.9M
     CGroup: /system.slice/php8.1-fpm.service
             ├─25091 php-fpm: master process (/etc/php/8.1/fpm/php-fpm.conf)
             ├─25093 php-fpm: pool www
             └─25094 php-fpm: pool www

Nov 20 19:40:34 ubuntu-01 systemd[1]: Starting The PHP 8.1 FastCGI Process Manager...
Nov 20 19:40:34 ubuntu-01 php-fpm8.1[25091]: [20-Nov-2021 19:40:34] NOTICE: PHP message: PHP Warning:  PHP Startup: ^(text/|application/xhtml\+xml) (offset=0): unrecognised compile-time optio>
Nov 20 19:40:34 ubuntu-01 systemd[1]: Started The PHP 8.1 FastCGI Process Manager.
```

PHP-FPM default configuration file to set listening socket, user and other information are located in:



```
$ ls  -1 /etc/php/8.1/fpm/
conf.d
php-fpm.conf
php.ini
pool.d

$ sudo vim /etc/php/8.1/fpm/pool.d/www.conf
$ sudo vim /etc/php/8.1/fpm/php-fpm.conf
```



## nginx配置

```
apt install nginx 
vim /etc/nginx/site-enables/xxx.com.conf
```

```nginx
server {
    server_name xxxxx.com;
    client_max_body_size 1000m;
    charset utf-8;
    underscores_in_headers on;
    listen 80;
    index index.php index.html index.htm;
    root /home/project/xxxx.com/web;
    location / {
         try_files $uri $uri/ /index.html;
    }
	location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
            fastcgi_index index.php;
            include fastcgi.conf;
     }
     error_page   500 502 503 504  /50x.html;
     location = /50x.html {
            root   html;
     }
}

```

````bash
修改目录拥有者
chown -R www-data:www-data /home/project/xxxx.com
````



## 证书安装  [ssl证书.md](ssl证书.md) 
