# exit_with_error <1:error_message>
function exit_with_error()
{
    echo
    echo $1
    echo
    exit 1
}

# create_service_user_if_not_exist <1:user> <2:group>
function create_service_user_if_not_exist()
{
    if id "$1" >& /dev/null;
    then
        echo
        echo "User '$1' already exists"
        echo
        /usr/sbin/usermod -g "$2" "$1"
    else
        if [ "$#" -lt 2 ]; then
            echo
            echo "Adding user "$1" ..."
            echo
            /usr/sbin/useradd -M -s /sbin/nologin "$1"
        elif [ "$#" -eq 2 ]; then
            echo
            echo "Adding user "$1" to group "$2" ..."
            echo
            create_group_if_not_exist "$2"
            /usr/sbin/useradd -M -s /sbin/nologin "$1" -g "$2"
        fi

        [ "$?" -eq 0 ] || exit_with_error "Adding user "$1" failed!"
        echo
        echo "User "$1" is added."
        echo
    fi
}

# create_group_if_not_exist <1:group_name>
function create_group_if_not_exist()
{
    uc=`grep $1: /etc/group | wc -l`
    [ "$uc" -gt "0" ] || /usr/sbin/groupadd $1
}

# require_yum_package <1:yum_package_name>
function require_yum_package()
{
    uc=`yum list installed|grep "^$1"|wc -l`
    [ "$uc" -gt "0" ] || yum -y install $1
}

# backup <1:source_dir> <2:backup_dir> [<3:no_prompt: 0|1>]
function backup()
{
    if [ -d $1 ]
    then
        echo
        echo "$1 already exists. The script will backup $1 into $2."
        echo

        if [ $3 -eq 0 ]
        then
            read -p "Continue?[y|n]:" ANSWER
            [ "${ANSWER}" != "y" ] && exit_with_error "Cancelled by user."
        fi

        [ ! -e $2 ] && mkdir -p $2
        mv -f $1 $2
        [ $? -eq 0 ] || exit_with_error "Backup $1 to $2 failed!"

        echo
        echo "$1 is backuped to $2."
        echo
    echo
    fi
}

# stop_service <1:service_name> <2:service_path>
function stop_service()
{
    wc=`service $1 status 2>/dev/null | grep running | wc -l`

    if [ $wc -gt 0 ]
    then
        echo
        echo "Stopping service $1 ..."
        echo

        service $1 stop
        sleep 1
    fi

    wc=`ps aux | grep $2/* | wc -l`

    if [ $wc -gt 1 ]
    then
        exit_with_error "Failed to stop service [$1]!"
    fi
}

# prepare_package <1:package_id: lib|service_name> <2:package_dir> <3:package_name> <4:target_dir>
# <5:download_url> <6:backup: dir|no_backup> <7:prompt_user: 0|1> [<8:user>] [<9:group>]
function prepare_package()
{
    if [ ! $1 == 'lib' ]
    then
        echo
        echo "Installing $3 to $4 ..."
        echo

        #check $1 running status
        echo
        echo "Checking running $1 service ..."
        echo
        stop_service $1 $4

        #check and backup if necessary
        if [ $6 == "no_backup" ]
        then
            [ -d $4 ] && rm -rf $4/*
        else
            backup $4 $6 $7
        fi

        if [ $# -gt 7 ]
        then
            [ $8 == 'root' ] && exit_with_error "'root' cannot be used as the $1 user!"

            #create user and group
            create_service_user_if_not_exist $8 $9
        fi
    else
        echo
        echo "Installing library $3 ..."
        echo
    fi

    echo
    echo "Preparing package $3 ..."
    echo
    download_untar $2 $3 $5
}

# download: <1:package_dir> <2:package_name_with_ext> <3:download_url|"no_auto_download">
function download()
{
    if [ $3 != "no_auto_download" ] && [ ! -f $1/$2 ]
    then
        echo
        echo "Downloading package $2 ..."
        echo
        [ -d $1 ] || mkdir -p $1
        cd $1
        wget $3/$2
    fi
    [ -f $1/$2 ] || exit_with_error "$2 not found! You may try running installation script with -d option."
}

# download_untar: <1:package_dir> <2:package_name> <3:download_url>
function download_untar()
{
    download $1 $2.tar.gz $3
    [ -d $1/$2 ] && rm -rf $1/$2

    echo
    echo "Extracting $2 package ..."
    echo
    tar xf $1/$2.tar.gz -C $1
}

# install_package: <1:source_dir> <2:package_name> [<3:make_flag|"no_auto_make">] [<*:flag>]
function install_package()
{
    /sbin/ldconfig

    echo
    echo "Configuring $3 make environment ..."
    echo
    cd $1
    PACKAGE=$2
    AUTO_MAKE=1
    if [ $# -gt 2 ] && [ $3 == "no_auto_make" ]
    then
        AUTO_MAKE=0
        shift 3
    else
        shift 2
    fi
    ./configure $*
    [ ! $? -eq 0 ] && exit_with_error "Missing dependencies for ${PACKAGE} package!"

    if [ ${AUTO_MAKE} -eq 1 ]
    then
        echo
        echo "Building ${PACKAGE} package ..."
        echo
        make -s && make -s install
        [ ! $? -eq 0 ] && exit_with_error "Building ${PACKAGE} package failed!"
    fi
}

# install_php_extension <1:package_dir> <2:tar_name> <3:base_dir> <4:download_url> <5:php_dir> <6:ext|zend> <7:so_name> [<*:flag>]
function install_php_extension()
{
    SOURCE_DIR=$1/$2
    PACKAGE_NAME=$2
    PHP_DIR=$5
    SO_PATH=${PHP_DIR}/lib/php/extensions/no-debug-non-zts-${PHP_EXT_BUILD_NUM}/$7

    if [ -f ${SO_PATH} ] && [ ${ALL_REINSTALL} -eq 0 ]
    then
        echo
        echo "PHP extension '${PACKAGE_NAME}' has already been installed."
        echo "Nothing to do."
        echo
    else
        prepare_package lib $1 $2 $3 $4

        echo
        echo "Building ${PACKAGE_NAME} PHP extension package ..."
        echo
        cd ${SOURCE_DIR}
        ${PHP_DIR}/bin/phpize

        if [ $6 == "zend" ]
        then
            CONFIG_LINE="zend_extension = \"${PHP_DIR}/lib/php/extensions/no-debug-non-zts-${PHP_EXT_BUILD_NUM}/$7\""
        else
            CONFIG_LINE="extension = \"$7\""
        fi

        shift 7

        install_package ${SOURCE_DIR} ${PACKAGE_NAME} $*

        if ! grep "${CONFIG_LINE}" ${PHP_DIR}/etc/php.ini >& /dev/null; then
            PLACEHOLDER=';EXT!'
            sed -i "/${PLACEHOLDER}/i\\${CONFIG_LINE}" ${PHP_DIR}/etc/php.ini
        fi

        [ -f ${SO_PATH} ] || exit_with_error "Failed to install ${PACKAGE_NAME} PHP extension!"

        echo
        echo "PHP extension '${PACKAGE_NAME}' is installed successfully."
        echo
    fi
}

# add_custom_lib_path <1:lib_path>
function add_custom_lib_path()
{
    if ! grep "$1" /etc/ld.so.conf >& /dev/null; then
        echo
        echo "Adding '$1' to lib loading path ..."
        echo
        echo "$1" >> /etc/ld.so.conf
    fi
}

# add_custom_bin_path <1:bin_path>
function add_custom_bin_path()
{
    [ -f /etc/profile.d/klnmp.sh ] || echo "#klnmp environment configuration" >> /etc/profile.d/klnmp.sh

    if ! grep "$1" /etc/profile.d/klnmp.sh >& /dev/null; then
        echo
        echo "Adding '$1' to klnmp environment path ..."
        echo
        echo "pathmunge $1 after" >> /etc/profile.d/klnmp.sh
    fi
}

# add_install_record <1:service_name> <2:package_name> <3:install_path>
function add_install_record()
{
    if ! grep "$1 " ${LNMP_DATA} >& /dev/null;  then
        echo
        echo "Adding installation record for '$2' ..."
        echo
        echo "$1 $2 $3" >> ${LNMP_DATA}
    fi
}

# remove_install_record <1:service_name>
function remove_install_record()
{
    if grep "$1 " ${LNMP_DATA} >& /dev/null;  then
        echo
        echo "Removing installation record for '$2' ..."
        echo
        /bin/sed -i "/$1 /d" ${LNMP_DATA}
    fi
}