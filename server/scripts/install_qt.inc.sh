#install_qt

if [ ${USE_TAR_BASENAME} -eq 1 ]
then
    QT_ID_NAME=${QT_TAR_NAME}
else
    QT_ID_NAME=qt
fi

QT_DIR=${BASE_DIR}/${PHP54_ID_NAME}

function install_qt()
{
    prepare_package lib ${PACKAGE_DIR} ${QT_TAR_NAME} ${QT_DIR} ${DOWNLOAD_BASE_URL}
    install_package ${PACKAGE_DIR}/${QT_TAR_NAME} ${QT_TAR_NAME} no_auto_make --prefix=${QT_DIR}

    echo
    echo "Building ${QT_TAR_NAME} package ..."
    echo
    gmake -s && gmake -s install
    [ ! $? -eq 0 ] && exit_with_error "Building ${QT_TAR_NAME} package failed!"

    add_custom_bin_path ${QT_DIR}/bin

    echo
    echo "${QT_TAR_NAME} is installed successfully."
    echo
}

if [ ${ALL_REINSTALL} -eq 1 ] || [ ! -d ${QT_DIR} ]; then
    install_qt
    add_install_record ${QT_ID_NAME} ${QT_TAR_NAME} ${QT_DIR}

else
    echo
    echo "${QT_TAR_NAME} has already been installed."
    echo "Nothing to do."
    echo
fi
