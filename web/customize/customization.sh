#!/bin/bash

unzip -o ${CUSTOM_FILE_DIR}/files/assets/fonts.zip -d ${WORDPRESS_DIR}/wp-content/themes/Avada

cat  ${CUSTOM_FILE_DIR}/files/functions.php >> ${WORDPRESS_DIR}/wp-content/themes/Avada/functions.php

cp ${CUSTOM_FILE_DIR}/files/assets/{admin_panel_base.css,admin_panel_user.css} ${WORDPRESS_DIR}/wp-content/themes/Avada
cp ${CUSTOM_FILE_DIR}/files/404.php ${WORDPRESS_DIR}/wp-content/themes/Avada

wp --allow-root db import --path=${WORDPRESS_DIR} ${CUSTOM_FILE_DIR}/query.sql