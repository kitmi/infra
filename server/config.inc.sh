#Installation configuration
#https://github.com/kitmi/infra/server

#components to install
export COMPONENTS="nginx mysql php54 phing phpmyadmin redis mongodb" #nginx mysql php54 phing phpmyadmin redis mongodb qt
export LNMP_DATA=/etc/lnmp.install.dat

#define the install path, backup path, data path, web root path and etc.
export LNMP_DIR=/lnmp
export BASE_DIR=${LNMP_DIR}/local
export BACKUP_DIR=${LNMP_DIR}/backup
export DATA_BASE_DIR=${LNMP_DIR}/data
export LOG_BASE_DIR=${LNMP_DIR}/log
export TMP_BASE_DIR=${LNMP_DIR}/tmp

#global configuration
export PACKAGE_SOURCE_URL=http://www.kingcores.com/downloads/lnmp
export TIMEZONE=Australia/Sydney

#define nginx configuration
export NGINX_USER=www
export NGINX_GROUP=www
export NGINX_WEB_ROOT=${LNMP_DIR}/www
export NGINX_PHP_CGI_PORT=9000

#define mysql configuration
export MYSQL_USER=mysql
export MYSQL_GROUP=mysql
export MYSQL_PORT=3306
export MYSQL_PASSWORD=root
export MYSQL_MEM=128M #64M,128M,512M,2G,4G

#define php configuration
export PHP_USER=www
export PHP_GROUP=www
export PHP_FPM_PORT=9000
export PHP_ONLY_INSTALL_EXT=0
export PHP_WITH_EACCELERATOR=0
export PHP_WITH_UUID=1
export PHP_WITH_REDIS=1
export PHP_WITH_XINC=0
export PHP_WITH_XDEBUG=0
export PHP_WITH_MONGODB=1
export PHP_WITH_IMAGICK=1
export PHP_WITH_ZBARCODE=1
export PHP_EXT_BUILD_NUM=20100525

#define phpmyadmin configuration
export PHPMYADMIN_DIR_NAME=db_admin
export PHPMYADMIN_DB_HOST=localhost
export PHPMYADMIN_DB_PORT=3306
export PHPMYADMIN_DB_SOCK=${TMP_BASE_DIR}/mysql/mysql.sock

#define redis configuration
export REDIS_USER=redis
export REDIS_GROUP=redis
export REDIS_PORT=6379
export REDIS_SECRET_CODE=redis

#define mongodb configuration
export MONGODB_USER=mongodb
export MONGODB_GROUP=mongodb
export MONGODB_PORT=7000
export MONGODB_ADMIN_USER=mgroot
export MONGODB_ADMIN_PASSWORD=mgroot

#define names of the packages which will be included in this installation
export NGINX_TAR_NAME=nginx-1.2.1
export MYSQL_TAR_NAME=mysql-5.5.2-m2
export LIBICONV_TAR_NAME=libiconv-1.14
export LIBMCRYPT_TAR_NAME=libmcrypt-2.5.8
export RE2C_TAR_NAME=re2c-0.13.5
export MHASH_TAR_NAME=mhash-0.9.9.9
export MCRYPT_TAR_NAME=mcrypt-2.6.8
export PHP54_TAR_NAME=php-5.4.11 #2013-01-17
export PHPMYADMIN_TAR_NAME=phpMyAdmin-3.5.2-english
export EACCELERATOR_TAR_NAME=eaccelerator #2012-08-16
export IMAGICK_TAR_NAME=imagick-3.1.0RC2 #2013-03-30
export REDIS_TAR_NAME=redis-2.6.9 #2013-01-29
export PHPREDIS_TAR_NAME=phpredis-2.2.2 #2013-01-29
export UUID_TAR_NAME=uuid-1.0.3
export PHING_TAR_NAME=phing-2.4.13
export XDEBUG_TAR_NAME=xdebug-2.2.1
export MONGODB_TAR_NAME=mongodb-linux-x86_64-2.4.4 #2013-06-28
export PHPMONGO_TAR_NAME=mongo-1.3.3 #2013-01-16
export PHP_ZBARCODE_TAR_NAME=php-zbarcode #2013-03-30
export ZBAR_TAR_NAME=zbar-0.10 #2013-03-30
export QT_TAR_NAME=qt-everywhere-opensource-src-4.8.4 #2013-04-27