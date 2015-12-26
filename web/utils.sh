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
    KEY="$1"
    VALUE="$2"
    sed -ri "s/(['\"]$KEY['\"]\s*,)\s*(['\"][^'\"]*['\"])/\1$(sed_escape_rhs "$(php_escape "$VALUE")")/" ${WORDPRESS_DIR}/wp-config.php
}

install_themes() {
    REQUIRE_FILE=${1}
    THEMES=(`jq '.themes | keys' ${REQUIRE_FILE} | tr -d '"[,]\n'`)

    for THEME in "${THEMES[@]}"; do
        VALUE=`jq '.themes.'${THEME} $REQUIRE_FILE | tr -d '"'`
        if [ -z ${VALUE} ] || [ "${VALUE}" == "~" ]; then
            install_theme $THEME
        else
            install_theme $VALUE
        fi
    done
}

install_plugins() {
    REQUIRE_FILE=${1}
    PLUGINS=(`jq '.plugins | keys' ${REQUIRE_FILE} | tr -d '"[,]\n'`)

    for PLUGIN in "${PLUGINS[@]}"; do
        VALUE=`jq '.plugins.'${PLUGIN} $REQUIRE_FILE | tr -d '"'`
        if [ -z ${VALUE} ] || [ "${VALUE}" == "~" ]; then
            install_plugin ${PLUGIN}
        else
            install_plugin $VALUE
        fi
    done
}

install_theme() {
    wp --allow-root theme install --activate --path=${WORDPRESS_DIR} ${1}
}

install_plugin() {
    wp --allow-root plugin install --activate --path=${WORDPRESS_DIR} ${1}
}
