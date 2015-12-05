FROM php:5.6-fpm

RUN \
    apt-get update && \
    apt-get install -y libpng12-dev libjpeg-dev curl unzip libmcrypt-dev netcat && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install gd mysqli opcache mcrypt && \
    rm -rf /var/lib/apt/lists/*

COPY ./opcache-recommended.ini /usr/local/etc/php/conf.d/
COPY ./php-fpm.ini ${PHP_INI_DIR}/conf.d/

#==============================
#       Customization
#==============================
ENV DADEVARZAN_FILE_DIR=/tmp/dadevarzan
ENV PLUGINS="nginx-helper wordfence wordpress-seo google-captcha google-analytics duplicate-post user-role-editor adminimize loco-translate stops-core-theme-and-plugin-updates wp-smushit all-in-one-wp-security-and-firewall underconstruction w3-total-cache contact-form-7"

COPY ./files ${DADEVARZAN_FILE_DIR}
COPY ./dadevarzan-entrypoint.sh /dadevarzan-entrypoint.sh

RUN \
    for PLUGIN in $PLUGINS ;do \
        curl -o $DADEVARZAN_FILE_DIR/plugins/$PLUGIN.zip -O `curl -i -s https://wordpress.org/plugins/$PLUGIN/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`; \
    done

ENTRYPOINT ["bash", "/dadevarzan-entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 80 443
VOLUME /var/www
