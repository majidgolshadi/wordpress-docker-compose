#!/bin/bash

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


install_themes() {
    REQUIRE_FILE=${1}
    THEMES=(`jq '.themes | keys' ${REQUIRE_FILE} | tr -d '"[,]\n'`)

    for THEME in "${THEMES[@]}"; do
        value=`jq '.themes.'${THEME} $REQUIRE_FILE | tr -d '"'`
        if [ -z ${value} ] || [ "${value}" == "~" ]; then
            install_theme $THEME
        else
            install_theme ${value}
        fi
    done
}

install_plugins() {
    REQUIRE_FILE=${1}
    PLUGINS=(`jq '.plugins | keys' ${REQUIRE_FILE} | tr -d '"[,]\n'`)

    for PLUGIN in "${PLUGINS[@]}"; do
        value=`jq '.plugins.'${PLUGIN} $REQUIRE_FILE | tr -d '"'`
        if [ -z ${value} ] || [ "${value}" == "~" ]; then
            install_plugin ${PLUGIN}
        else
            install_plugin ${value}
        fi
    done
}

install_theme() {
    wp --allow-root theme install --activate --path=${WORDPRESS_DIR} ${1}
}

install_plugin() {
    wp --allow-root plugin install --activate --path=${WORDPRESS_DIR} ${1}
}
