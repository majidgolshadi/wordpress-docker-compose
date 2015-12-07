FROM nginx:1.9

ENV DADEVARZAN_FILE_DIR /tmp/dadevarzan
ENV PRIVATE_PLUGINS "fusion-core layerSlider legact-admin revslider"
ENV PLUGINS "nginx-helper wordfence wordpress-seo google-captcha google-analytics duplicate-post user-role-editor adminimize loco-translate stops-core-theme-and-plugin-updates wp-smushit all-in-one-wp-security-and-firewall underconstruction w3-total-cache contact-form-7"

COPY files ${DADEVARZAN_FILE_DIR}
COPY entrypoint.sh /entrypoint.sh
COPY start.sh /start.sh

RUN \
    apt-get update && \
    apt-get install -y --force-yes curl php5-fpm php5-cli php5-common php5-mcrypt php5-curl php5-intl php5-mysql php5-gd php-apc \
                                    libpng12-dev libjpeg-dev libmcrypt-dev unzip netcat

RUN \
    for PLUGIN in $PLUGINS ;do \
        curl -o $DADEVARZAN_FILE_DIR/plugins/$PLUGIN.zip -O `curl -i -s https://wordpress.org/plugins/$PLUGIN/ | \
        egrep -o "https://downloads.wordpress.org/plugin/[^']+"`; \
    done

RUN \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN \
    sed -i -e "s/user  nginx/user  www-data/g" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf


COPY wordpress-fpm.conf /etc/nginx/conf.d/default.conf

VOLUME ["/var/www/wordpress"]

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/start.sh"]
