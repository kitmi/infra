#install php54

if [ ${USE_TAR_BASENAME} -eq 1 ]
then
    PHP54_ID_NAME=${PHP54_TAR_NAME}
else
    PHP54_ID_NAME=php
fi

PHP54_DIR=${BASE_DIR}/${PHP54_ID_NAME}
PHP54_TMP_DIR=${TMP_BASE_DIR}/${PHP54_ID_NAME}
PHP54_LOG_DIR=${LOG_BASE_DIR}/${PHP54_ID_NAME}

function install_php54()
{
    #re2c
    which re2c >& /dev/null
    if [ ! $? -eq 0 ]
    then
        prepare_package lib ${PACKAGE_DIR} ${RE2C_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL}
        install_package ${PACKAGE_DIR}/${RE2C_TAR_NAME} ${RE2C_TAR_NAME}
    fi

    #libiconv
    if [ ! -f ${BASE_DIR}/lib/libiconv.so ]
    then
        prepare_package lib ${PACKAGE_DIR} ${LIBICONV_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL}
        install_package ${PACKAGE_DIR}/${LIBICONV_TAR_NAME} ${LIBICONV_TAR_NAME} --prefix=${BASE_DIR}
    fi

    #libmcrypt
    if [ ! -f ${BASE_DIR}/lib/libmcrypt.so ]
    then
        prepare_package lib ${PACKAGE_DIR} ${LIBMCRYPT_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL}
        install_package ${PACKAGE_DIR}/${LIBMCRYPT_TAR_NAME} ${LIBMCRYPT_TAR_NAME} --prefix=${BASE_DIR} --disable-posix-threads

        if [ ! -f ${BASE_DIR}/lib/libltdl.a ]
        then
            install_package ${PACKAGE_DIR}/${LIBMCRYPT_TAR_NAME}/libltdl libltdl --prefix=${BASE_DIR} --enable-ltdl-install
        fi
    fi

    #mhash
    if [ ! -f ${BASE_DIR}/lib/libmhash.so ]
    then
        prepare_package lib ${PACKAGE_DIR} ${MHASH_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL}
        install_package ${PACKAGE_DIR}/${MHASH_TAR_NAME} ${MHASH_TAR_NAME} --prefix=${BASE_DIR}
    fi

    #mcrypt
    if [ ! -f ${BASE_DIR}/bin/mcrypt ]
    then
        prepare_package lib ${PACKAGE_DIR} ${MCRYPT_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL}
        /sbin/ldconfig

        export LD_LIBRARY_PATH=${BASE_DIR}/lib:${LD_LIBRARY_PATH}
        export LDFLAGS="-L${BASE_DIR}/lib -I${BASE_DIR}/include"
        export CFLAGS="-I${BASE_DIR}/include"

        echo
        echo "Configuring ${MCRYPT_TAR_NAME} make environment ..."
        echo
        cd ${PACKAGE_DIR}/${MCRYPT_TAR_NAME}
        ./configure --prefix=${BASE_DIR} --with-libmcrypt-prefix=${BASE_DIR}
        [ ! $? -eq 0 ] && exit_with_error "Missing dependencies for ${MCRYPT_TAR_NAME}!"

        echo
        echo "Building ${MCRYPT_TAR_NAME} package ..."
        echo
        make -s && make -s install
        [ ! $? -eq 0 ] && exit_with_error "Building ${PACKAGE} package failed!"
    fi

    prepare_package ${PHP54_ID_NAME} ${PACKAGE_DIR} ${PHP54_TAR_NAME} ${PHP54_DIR} ${DOWNLOAD_BASE_URL} \
        ${BACKUP_DIR_FLAG} ${NO_PROMPT} ${PHP54_USER} ${PHP54_GROUP}

    if [ ${USE_TAR_BASENAME} -eq 1 ]
    then
        PHP_MYSQL_DIR=${BASE_DIR}/${MYSQL_TAR_NAME}
        if [ ! -d ${PHP_MYSQL_DIR} ]
        then
            PHP_MYSQL_DIR=${BASE_DIR}/mysql
        fi
    else
        PHP_MYSQL_DIR=${BASE_DIR}/mysql
        if [ ! -d ${PHP_MYSQL_DIR} ]
        then
            PHP_MYSQL_DIR=${BASE_DIR}/${MYSQL_TAR_NAME}
        fi
    fi

    [ -d ${PHP_MYSQL_DIR} ] || exit_with_error "'mysql' must be installed first before installing ${PHP54_TAR_NAME}!"

    install_package ${PACKAGE_DIR}/${PHP54_TAR_NAME} ${PHP54_TAR_NAME} no_auto_make \
        --prefix=${PHP54_DIR} \
        --with-config-file-path=${PHP54_DIR}/etc \
        --with-iconv=${BASE_DIR} \
        --with-mhash=${BASE_DIR} \
        --with-mcrypt=${BASE_DIR} \
        --with-mysql=${PHP_MYSQL_DIR} \
        --with-pdo-mysql=${PHP_MYSQL_DIR} \
        --with-freetype-dir \
        --with-bz2 \
        --with-gd \
        --with-gettext \
        --with-jpeg-dir \
        --with-png-dir \
        --with-zlib \
        --with-libxml-dir \
        --with-curlwrappers \
        --with-openssl \
        --with-xmlrpc \
        --with-curl --with-curlwrappers \
        --enable-fpm \
        --enable-sockets \
        --enable-pcntl \
        --enable-gd-native-ttf \
        --enable-soap \
        --enable-pdo \
        --enable-inline-optimization \
        --enable-mbregex --enable-mbstring \
        --enable-zip \
        --enable-xml \
        --enable-bcmath --enable-shmop --enable-sysvsem \
        --disable-rpath

    echo
    echo "Building ${PHP54_TAR_NAME} package ..."
    echo
    make -s ZEND_EXTRA_FILE='-liconv' && make -s install
    [ ! $? -eq 0 ] && exit_with_error "Building ${PHP54_TAR_NAME} package failed!"

    echo
    echo "Updating php.ini ..."
    echo
    /bin/cp -f ${CONFIG_DIR}/php.ini ${PHP54_DIR}/etc/php.ini
    sed -i "s:__PHP54_DIR__:${PHP54_DIR}:g" ${PHP54_DIR}/etc/php.ini
    sed -i "s:__TMP_DIR__:${TMP_BASE_DIR}:g" ${PHP54_DIR}/etc/php.ini
    sed -i "s:__PHP54_LOG_DIR__:${PHP54_LOG_DIR}:g" ${PHP54_DIR}/etc/php.ini

    echo
    echo "Updating php-fpm.conf ..."
    echo
    /bin/cp -f ${CONFIG_DIR}/php-fpm.conf ${PHP54_DIR}/etc/php-fpm.conf
    [ ! -d ${PHP54_LOG_DIR} ] && mkdir -p ${PHP54_LOG_DIR}
    chown -R ${PHP_USER}:${PHP_USER} ${PHP54_LOG_DIR}
    sed -i "s:__PHP54_LOG_DIR__:${PHP54_LOG_DIR}:g" ${PHP54_DIR}/etc/php-fpm.conf
    sed -i "s:__PHP54_USER__:${PHP_USER}:g" ${PHP54_DIR}/etc/php-fpm.conf
    sed -i "s:__PHP54_GROUP__:${PHP_GROUP}:g" ${PHP54_DIR}/etc/php-fpm.conf
    sed -i "s:__PHP54_PORT__:${PHP_FPM_PORT}:g" ${PHP54_DIR}/etc/php-fpm.conf

    echo
    echo "Setting up ${PHP54_ID_NAME} service ..."
    echo
    /bin/cp -f ${INITD_DIR}/php-fpm /etc/init.d/${PHP54_ID_NAME}
    sed -i "s:__PHP54_DIR__:${PHP54_DIR}:g" /etc/init.d/${PHP54_ID_NAME}
    sed -i "s:__PHP54_LOG_DIR__:${PHP54_LOG_DIR}:g" /etc/init.d/${PHP54_ID_NAME}
    chmod +x /etc/init.d/${PHP54_ID_NAME}

    chkconfig --add ${PHP54_ID_NAME}
    chkconfig --level 235 ${PHP54_ID_NAME} on

    #add php bin directory to ENVIRONMENT variable PATH
    add_custom_bin_path ${PHP54_DIR}/sbin
    add_custom_bin_path ${PHP54_DIR}/bin
    source /etc/profile

    service ${PHP54_ID_NAME} start
    [ $? -eq 0 ] || echo "${PHP54_TAR_NAME} cannot be started!"

    echo
    echo "${PHP54_TAR_NAME} is installed successfully."
    echo

    service ${PHP54_ID_NAME} stop
}

function install_php54_ext()
{
    # dependencies
    if [ ${PHP_WITH_ZBARCODE} -eq 1 ]
    then
        PHP_WITH_IMAGICK=1
    fi

    # install eaccelerator
    if [ ${PHP_WITH_EACCELERATOR} -eq 1 ]
    then
        [ -d ${TMP_BASE_DIR}/eaccelerator ] || mkdir ${TMP_BASE_DIR}/eaccelerator
        chmod 0777 ${TMP_BASE_DIR}/eaccelerator
        chown -R ${PHP_USER}:${PHP_USER} ${TMP_BASE_DIR}/eaccelerator

        install_php_extension ${PACKAGE_DIR} ${EACCELERATOR_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} ext eaccelerator.so \
            --enable-eaccelerator=shared \
            --with-php-config=${PHP54_DIR}/bin/php-config
    fi

    # install redis
    if [ ${PHP_WITH_REDIS} -eq 1 ]
    then
        install_php_extension ${PACKAGE_DIR} ${PHPREDIS_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} ext redis.so
    fi

    # install uuid
    if [ ${PHP_WITH_UUID} -eq 1 ]
    then
        install_php_extension ${PACKAGE_DIR} ${UUID_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} ext uuid.so
    fi

    # install xdebug
    if [ ${PHP_WITH_XDEBUG} -eq 1 ]
    then
        install_php_extension ${PACKAGE_DIR} ${XDEBUG_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} zend xdebug.so
    fi

    # install mongodb
    if [ ${PHP_WITH_MONGODB} -eq 1 ]
    then
        install_php_extension ${PACKAGE_DIR} ${PHPMONGO_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} ext mongo.so
    fi

    # install imagick
    if [ ${PHP_WITH_IMAGICK} -eq 1 ]
    then
        yum -y install ImageMagick ImageMagick-devel
        install_php_extension ${PACKAGE_DIR} ${IMAGICK_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} ext imagick.so
    fi

    # install zbarcode
    if [ ${PHP_WITH_ZBARCODE} -eq 1 ]
    then
        #lib zbarcode
        if [ ! -f ${BASE_DIR}/lib/libzbar.so ]
        then
            prepare_package lib ${PACKAGE_DIR} ${ZBAR_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL}
            install_package ${PACKAGE_DIR}/${ZBAR_TAR_NAME} ${ZBAR_TAR_NAME} --prefix=${BASE_DIR}
        fi
        install_php_extension ${PACKAGE_DIR} ${PHP_ZBARCODE_TAR_NAME} ${BASE_DIR} ${DOWNLOAD_BASE_URL} ${PHP54_DIR} ext zbarcode.so
    fi
}

if [ ${ALL_REINSTALL} -eq 1 ] || [ ! -d ${PHP54_DIR} ]; then
    if [ ${PHP_ONLY_INSTALL_EXT} -eq 1 ]
    then
        echo
        echo "This script is configured to install PHP extensions only."
        echo
    else
        install_php54
        add_install_record ${PHP54_ID_NAME} ${PHP54_TAR_NAME} ${PHP54_DIR}
    fi

    install_php54_ext

else
    echo
    echo "${PHP54_TAR_NAME} has already been installed."
    echo "Nothing to do."
    echo
fi

