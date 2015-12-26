#!/bin/bash

set -e

source /utils.sh

UNIQUES=(
    AUTH_KEY
    SECURE_AUTH_KEY
    LOGGED_IN_KEY
    NONCE_KEY
    AUTH_SALT
    SECURE_AUTH_SALT
    LOGGED_IN_SALT
    NONCE_SALT
)

export DATABASE_NAME='wordpress'
export USERNAME='root'
export PASSWORD='wordpress'

export WEB_DIR=/var/www
export WORDPRESS_DIR=${WEB_DIR}/wordpress

if [ ! -f ${WORDPRESS_DIR}/.dadevarzan_installed ]; then
    unzip -o ${CUSTOM_FILE_DIR}/files/core/wordpress-4.3.1-fa_IR.zip -d ${WEB_DIR}
    cp ${CUSTOM_FILE_DIR}/customization.sh ${WORDPRESS_DIR}
    cp ${CUSTOM_FILE_DIR}/require.json ${WORDPRESS_DIR}

    awk '/^\/\*.*stop editing.*\*\/$/ && c == 0 { c = 1; system("cat") } { print }' ${WORDPRESS_DIR}/wp-config-sample.php > ${WORDPRESS_DIR}/wp-config.php
    for unique in "${UNIQUES[@]}"; do
        set_config "$unique" "$(head -c256 /dev/urandom | sha1sum | cut -d' ' -f1)"
    done

    # Wait for mysql contaienr to come up
    until nc -z ${MYSQL_PORT_3306_TCP_ADDR} ${MYSQL_PORT_3306_TCP_PORT}; do
        echo "$(date) - Waiting for mysql on tcp://${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}..."
        sleep 5
    done

    if [ -f /config/database.cfg ]; then
        export $(cat /config/database.cfg)
    fi

    set_config 'DB_HOST' 'mysql'
    set_config 'DB_NAME' ${DATABASE_NAME}
    set_config 'DB_USER' ${USERNAME}
    set_config 'DB_PASSWORD' ${PASSWORD}

    install_themes ${WORDPRESS_DIR}/require.json
    install_plugins ${WORDPRESS_DIR}/require.json
    source ${WORDPRESS_DIR}/customization.sh

    chown -R nobody:nobody ${WEB_DIR}

    rm -rf ${CUSTOM_FILE_DIR}
    rm -rf ${WORDPRESS_DIR}/wp-content/plugins/{akismet,hello.php}
    rm -rf ${WORDPRESS_DIR}/wp-content/themes/{twentyfifteen,twentyfourteen,twentythirteen}

    touch ${WORDPRESS_DIR}/.dadevarzan_installed
fi

exec "$@"
