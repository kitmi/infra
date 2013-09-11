#install_mongodb

if [ ${USE_TAR_BASENAME} -eq 1 ]
then
    MONGODB_ID_NAME=${MONGODB_TAR_NAME}
else
    MONGODB_ID_NAME=mongodb
fi

MONGODB_DIR=${BASE_DIR}/${MONGODB_ID_NAME}
MONGODB_LOG_DIR=${LOG_BASE_DIR}/${MONGODB_ID_NAME}
MONGODB_DATA_DIR=${DATA_BASE_DIR}/${MONGODB_ID_NAME}

function install_mongodb()
{
    prepare_package ${MONGODB_ID_NAME} ${PACKAGE_DIR} ${MONGODB_TAR_NAME} ${MONGODB_DIR} ${DOWNLOAD_BASE_URL} \
        ${BACKUP_DIR_FLAG} ${NO_PROMPT} ${MONGODB_USER} ${MONGODB_GROUP}

    if [ ${NO_BACKUP} -eq 1 ]; then
        [ -d ${MONGODB_DATA_DIR} ] && rm -rf ${MONGODB_DATA_DIR}
    else
        backup ${MONGODB_DATA_DIR} ${BACKUP_DIR}/data ${NO_PROMPT}
    fi

    echo
    echo "Creating directories for mongodb ..."
    echo
    [ -d ${MONGODB_DATA_DIR} ] || mkdir -p ${MONGODB_DATA_DIR}
    chown -R ${MONGODB_USER}:${MONGODB_GROUP} ${MONGODB_DATA_DIR}

    [ -d ${MONGODB_LOG_DIR} ] || mkdir -p ${MONGODB_LOG_DIR}
    chown -R ${MONGODB_USER}:${MONGODB_GROUP} ${MONGODB_LOG_DIR}

    echo
    echo "Copy mongodb files ..."
    echo

    [ -d ${MONGODB_DIR} ] || mkdir -p ${MONGODB_DIR}
    /bin/cp -rf ${PACKAGE_DIR}/${MONGODB_TAR_NAME}/* ${MONGODB_DIR}/

    echo
    echo "Copy mongodb.conf ..."
    echo
    [ -d ${MONGODB_DIR}/conf ] || mkdir -p ${MONGODB_DIR}/conf
    /bin/cp -f ${CONFIG_DIR}/mongodb.conf ${MONGODB_DIR}/conf/mongodb.conf
    sed -i "s:__MONGODB_DATA_DIR__:${MONGODB_DATA_DIR}:g"  ${MONGODB_DIR}/conf/mongodb.conf
    sed -i "s:__MONGODB_LOG_DIR__:${MONGODB_LOG_DIR}:g"  ${MONGODB_DIR}/conf/mongodb.conf
    sed -i "s:__MONGODB_PORT__:${MONGODB_PORT}:g"  ${MONGODB_DIR}/conf/mongodb.conf

    echo
    echo "Setting up ${MONGODB_ID_NAME} service ..."
    echo
    /bin/cp -f ${INITD_DIR}/mongodb /etc/init.d/${MONGODB_ID_NAME}
    sed -i "s:__MONGODB_DIR__:"${MONGODB_DIR}":g" /etc/init.d/${MONGODB_ID_NAME}
    sed -i "s:__MONGODB_LOG_DIR__:"${MONGODB_LOG_DIR}":g" /etc/init.d/${MONGODB_ID_NAME}
    sed -i "s:__MONGODB_USER__:"${MONGODB_USER}":g" /etc/init.d/${MONGODB_ID_NAME}
    chmod +x /etc/init.d/${MONGODB_ID_NAME}

    chkconfig --add ${MONGODB_ID_NAME}
    chkconfig --level 235 ${MONGODB_ID_NAME} on

    service ${MONGODB_ID_NAME} init
    [ $? -eq 0 ] || exit_with_error "${MONGODB_TAR_NAME} cannot be started!"

    #add mongodb bin path to ENVIRONMENT varivle PATH
    add_custom_bin_path "${MONGODB_DIR}/bin"
    source /etc/profile

    mongo admin --port ${MONGODB_PORT} --eval "db.addUser({user:'${MONGODB_ADMIN_USER}', pwd:'${MONGODB_ADMIN_PASSWORD}', roles:['userAdminAnyDatabase']})"
    [ $? -eq 0 ] || exit_with_error "Adding administrator failed!"

    echo
    echo "${MONGODB_TAR_NAME} is installed successfully."
    echo

    service ${MONGODB_ID_NAME} stop
}

if [ ${ALL_REINSTALL} -eq 1 ] || [ ! -d ${MONGODB_DIR} ]; then
    install_mongodb
    add_install_record ${MONGODB_ID_NAME} ${MONGODB_TAR_NAME} ${MONGODB_DIR}

else
    echo
    echo "${MONGODB_TAR_NAME} has already been installed."
    echo "Nothing to do."
    echo
fi
