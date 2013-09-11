#install_phing

if [ ${USE_TAR_BASENAME} -eq 1 ]
then
    PHING_ID_NAME=${PHING_TAR_NAME}
else
    PHING_ID_NAME=phing
fi

PHING_DIR=${BASE_DIR}/${PHING_ID_NAME}

function install_phing()
{
    download ${PACKAGE_DIR} ${PHING_TAR_NAME}.tar.gz ${DOWNLOAD_BASE_URL}

    [ -d ${PACKAGE_DIR}/${PHING_TAR_NAME} ] && rm -rf ${PACKAGE_DIR}/${PHING_TAR_NAME}

    echo
    echo "Extracting ${PHING_TAR_NAME} package ..."
    echo
    mkdir ${PACKAGE_DIR}/${PHING_TAR_NAME}
    tar xf ${PACKAGE_DIR}/${PHING_TAR_NAME}.tar.gz -C ${PACKAGE_DIR}/${PHING_TAR_NAME}

    echo
    echo "Copy phing files ..."
    echo

    [ -d ${PHING_DIR} ] || mkdir -p ${PHING_DIR}
    /bin/cp -rf ${PACKAGE_DIR}/${PHING_TAR_NAME}/* ${PHING_DIR}/

    add_custom_bin_path ${PHING_DIR}/bin
    source /etc/profile

    echo
    echo "${PHING_TAR_NAME} is installed successfully."
    echo
}

if [ ${ALL_REINSTALL} -eq 1 ] || [ ! -d ${PHING_DIR} ]; then
    install_phing
    add_install_record ${PHING_ID_NAME} ${PHING_TAR_NAME} ${PHING_DIR}

else
    echo
    echo "${PHING_TAR_NAME} has already been installed."
    echo "Nothing to do."
    echo
fi
