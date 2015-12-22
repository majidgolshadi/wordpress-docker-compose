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

    THEMES=(`parser_get $REQUIRE_FILE themes`)

    for THEME in "${THEMES[@]}"; do

        VALUE=`parser_get $REQUIRE_FILE themes $THEME`

        if [ -z ${VALUE} ] || [ "${VALUE}" == "~" ]; then
            wp_install theme $THEME
        else
            wp_install theme $VALUE
        fi

    done
}

install_plugins() {
    REQUIRE_FILE=${1}

    PLUGINS=(`parser_get $REQUIRE_FILE plugins`)

    for PLUGIN in "${PLUGINS[@]}"; do

        VALUE=`parser_get $REQUIRE_FILE plugins $PLUGIN`

        if [ -z ${VALUE} ] || [ "${VALUE}" == "~" ]; then
            wp_install plugin $PLUGIN
        else
            wp_install plugin $VALUE
        fi

    done
}

parser_get() {
    REQUIRE_JSON_ADDRESS=${1}
    CATEGORY=${2}
    KEY=${3}

    if [ -z $KEY ]; then
        jq ".${CATEGORY} | keys" $REQUIRE_JSON_ADDRESS | tr -d '"[,]\n'
    else
        jq ".${CATEGORY}.${KEY}" $REQUIRE_JSON_ADDRESS | tr -d '"'
    fi
}

wp_install() {
    wp --allow-root --path=$WORDPRESS_DIR ${1} install --activate ${@:2}
}
