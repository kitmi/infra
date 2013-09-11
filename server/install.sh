#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")";pwd)

# utils
. ${SCRIPT_DIR}/scripts/bash_utils.inc.sh

# load config
. ${SCRIPT_DIR}/config.inc.sh

# script depended directories
export PACKAGE_DIR=${SCRIPT_DIR}/packages
export CONFIG_DIR=${SCRIPT_DIR}/conf
export INITD_DIR=${SCRIPT_DIR}/init.d
export TEST_DIR=${SCRIPT_DIR}/test

# script options
export NO_PROMPT=0
export ALL_REINSTALL=0
export NO_BACKUP=0
export AUTO_DOWNLOAD=0
export USE_TAR_BASENAME=0

export DOWNLOAD_BASE_URL=no_auto_download
export BACKUP_DIR_FLAG=${BACKUP_DIR}

echo "LNMP Installation Script"
echo "https://github.com/kitmi/infra/server"
echo

[ ${UID} -eq 0 ] || exit_with_error "This script must be run with root account!"

# parse arguments
while getopts ":yrfdt" OPTNAME
do
    case "${OPTNAME}" in
      "y")
        echo "Silence mode enabled."
        NO_PROMPT=1
        ;;
      "r")
        echo "Reinstall mode enabled."
        ALL_REINSTALL=1
        ;;
      "f")
        echo "Force mode (no backup) enabled."
        NO_BACKUP=1
        ;;
      "d")
          echo "Auto-Download mode enabled."
          AUTO_DOWNLOAD=1
        ;;
      "t")
          echo "Use tar package basename as component id name."
          USE_TAR_BASENAME=1
        ;;
      "?")
        echo "Unknown option ${OPTARG}"
        cat <<USAGE
LNMP Installation Script
https://github.com/kitmi/infra/server

Usages:
    install.sh [-y] [-r] [-f] [-d] [-t]
    y: no prompt while installing
    r: all components will be reinstalled
    f: no backup will be performed while installing
    d: auto download package while package not found
    t: to use tar package basename as component id name

Examples:
    install.sh -y

USAGE
        exit 1
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
        echo "Unknown error while processing options"
        ;;
    esac
done

if [ ${AUTO_DOWNLOAD} -eq 1 ]
then
    DOWNLOAD_BASE_URL=${PACKAGE_SOURCE_URL}
fi

if [ ${NO_BACKUP} -eq 1 ]
then
    BACKUP_DIR_FLAG=no_backup
else
    BACKUP_DIR_FLAG="${BACKUP_DIR}/$(date "+%Y%m%d_%H%M%S")"
fi

function main()
{
    echo
    echo "This script is going to install [${COMPONENTS}]."
    echo
    echo "Target path: ${BASE_DIR}"
    echo "Backup path: ${BACKUP_DIR}"
    echo "Data path: ${DATA_BASE_DIR}"
    echo "Log path: ${LOG_BASE_DIR}"
    echo "Tmp path: ${TMP_BASE_DIR}"
    echo

    if [ ${NO_PROMPT} -eq 0 ]
    then
        read -p "Continue?[y|n]:" ANSWER
        [ "${ANSWER}" != "y" ] && exit_with_error "Cancelled by user."
    fi

    [ -d ${BASE_DIR} ] || mkdir -p ${BASE_DIR}
    [ -d ${TMP_BASE_DIR} ] || mkdir -p ${TMP_BASE_DIR}

    set_datetime
    set_file_limits
	install_deps

    add_custom_lib_path "${BASE_DIR}/lib"
    add_custom_bin_path "${BASE_DIR}/bin"

    for COMPONENT in ${COMPONENTS}
    do
        .  ${SCRIPT_DIR}/scripts/install_${COMPONENT}.inc.sh
    done
}

function install_deps()
{
	rpm -i --nosignature ${SCRIPT_DIR}/epel-release-6-8.noarch.rpm

	yum -y install \
	    yum-utils \
	    bison \
	    make autoconf gcc gcc-c++ \
	    libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel \
	    freetype freetype-devel \
	    libxml2 libxml2-devel \
	    zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel \
	    fonts-chinese gettext gettext-devel \
	    ncurses ncurses-devel \
	    curl curl-devel \
	    e2fsprogs e2fsprogs-devel \
	    krb5 krb5-devel \
	    libidn libidn-devel \
	    openssl openssl-devel \
	    openldap openldap-devel openldap-clients \
	    pcre pcre-devel \
	    gd gd-devel \
	    libevent libevent-devel \
	    libpcap libpcap-devel \
	    wget \
	    rsync \
	    libuuid libuuid-devel \
	    ntp \
	    npm
}

function set_datetime()
{
    #todo set datetime and timezone
    echo
}

function set_file_limits()
{
    if ! grep "* soft nproc 65535" /etc/sysctl.conf >& /dev/null; then
        cat >>/etc/security/limits.conf<<EOF
* hard nproc 65535
* soft nproc 65535
* soft nofile 65535
* hard nofile 65535
EOF
    fi

    if ! grep "fs.file-max = 65535" /etc/sysctl.conf >& /dev/null; then
        cat >>/etc/sysctl.conf<<EOF
fs.file-max = 65535
EOF
    fi
}

main
