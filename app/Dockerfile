FROM wordpress:4.3-fpm
MAINTAINER Ali Naghavi <naghavi.ali@gmail.com>

RUN \
    apt-get update && \
    apt-get install -y curl unzip libmcrypt-dev && \
    docker-php-ext-install mcrypt gd

COPY ./php-fpm.ini ${PHP_INI_DIR}/conf.d/

#==============================
#       Customization
#==============================
ENV DADEVARZAN_FILE_DIR=/tmp/dadevarzan
ENV PLUGINS="nginx-helper wordfence wordpress-seo google-captcha google-analytics duplicate-post user-role-editor adminimize loco-translate stops-core-theme-and-plugin-updates wp-smushit all-in-one-wp-security-and-firewall underconstruction w3-total-cache contact-form-7"

COPY ./files ${DADEVARZAN_FILE_DIR}
COPY ./dadevarzan-entrypoint.sh /dadevarzan-entrypoint.sh

RUN rm -rf /usr/src/wordpress && unzip -o $DADEVARZAN_FILE_DIR/core/wordpress-4.3.1-fa_IR.zip -d /usr/src && \
    for PLUGIN in $PLUGINS ;do \
        curl -o $DADEVARZAN_FILE_DIR/plugins/$PLUGIN.zip -O `curl -i -s https://wordpress.org/plugins/$PLUGIN/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`; \
    done && \
    sed -i '$ d' /entrypoint.sh

ENTRYPOINT ["bash", "/dadevarzan-entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 80 443
