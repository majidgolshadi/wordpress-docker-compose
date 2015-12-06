#!/bin/bash

set -e

sed_escape_lhs() {
    echo "$@" | sed 's/[]\/$*.^|[]/\\&/g'
}
sed_escape_rhs() {
    echo "$@" | sed 's/[\/&]/\\&/g'
}
php_escape() {
    php -r 'var_export((string) $argv[1]);' "$1"
}
set_config() {
    key="$1"
    value="$2"
    regex="(['\"])$(sed_escape_lhs "$key")\2\s*,"
    if [ "${key:0:1}" = '$' ]; then
        regex="^(\s*)$(sed_escape_lhs "$key")\s*="
    fi
    sed -ri "s/($regex\s*)(['\"]).*\3/\1$(sed_escape_rhs "$(php_escape "$value")")/" /var/www/wordpress/wp-config.php
}

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

WEB_DIR=/var/www
WORDPRESS_DIR=${WEB_DIR}/wordpress

if [ ! -f ${WORDPRESS_DIR}/.dadevarzan_installed ]; then
    unzip -o ${DADEVARZAN_FILE_DIR}/core/wordpress-4.3.1-fa_IR.zip -d ${WEB_DIR}

    awk '/^\/\*.*stop editing.*\*\/$/ && c == 0 { c = 1; system("cat") } { print }' ${WORDPRESS_DIR}/wp-config-sample.php > ${WORDPRESS_DIR}/wp-config.php
    for unique in "${UNIQUES[@]}"; do
        set_config "$unique" "$(head -c1M /dev/urandom | sha1sum | cut -d' ' -f1)"
    done

    unzip -o ${DADEVARZAN_FILE_DIR}/themes/Avada.zip -d ${WORDPRESS_DIR}/wp-content/themes
    unzip -o ${DADEVARZAN_FILE_DIR}/assets/fonts.zip -d ${WORDPRESS_DIR}/wp-content/themes/Avada

    for plugin in $(ls ${DADEVARZAN_FILE_DIR}/plugins/); do
        unzip -o ${DADEVARZAN_FILE_DIR}/plugins/${plugin} -d ${WORDPRESS_DIR}/wp-content/plugins/
    done

    # Activate nginx plugin once logged in
    cat  ${DADEVARZAN_FILE_DIR}/wp-config.php >> ${WORDPRESS_DIR}/wp-config.php
    cat  ${DADEVARZAN_FILE_DIR}/functions.php >> ${WORDPRESS_DIR}/wp-content/themes/Avada/functions.php

    # Customizing admin panel
    mv ${DADEVARZAN_FILE_DIR}/assets/{admin_panel_base.css,admin_panel_user.css} ${WORDPRESS_DIR}/wp-content/themes/Avada

    # Customizing 404 page
    rm ${WORDPRESS_DIR}/wp-content/themes/Avada/404.php
    mv ${DADEVARZAN_FILE_DIR}/404.php ${WORDPRESS_DIR}/wp-content/themes/Avada

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

    chmod -f 644 ${WORDPRESS_DIR}/wp-content/themes/Avada/{admin_panel_base.css,admin_panel_user.css}
    chown -R www-data:www-data ${WEB_DIR}

    rm -rf ${DADEVARZAN_FILE_DIR}
    rm -rf ${WORDPRESS_DIR}/wp-content/plugins/{akismet, hello.php}
    rm -rf ${WORDPRESS_DIR}/wp-content/themes/{twentyfifteen,twentyfourteen,twentythirteen}

    touch ${WORDPRESS_DIR}/.dadevarzan_installed
fi

exec "$@"
