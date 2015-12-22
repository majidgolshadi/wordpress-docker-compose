FROM nginx:1.9

ENV CUSTOM_FILE_DIR /tmp/dadevarzan

COPY customize ${CUSTOM_FILE_DIR}
COPY entrypoint.sh /entrypoint.sh
COPY utils.sh /utils.sh
COPY start.sh /start.sh

RUN \
    apt-get update && \
    apt-get install -y --force-yes curl php5-fpm php5-cli php5-common php5-mcrypt php5-curl php5-intl php5-mysql php5-gd php-apc \
                                    libpng12-dev libjpeg-dev libmcrypt-dev unzip netcat

RUN \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    apt-get install -y jq

RUN \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN \
    sed -i -e "s/user  nginx/user  www-data/g" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf

COPY nginx-fpm.conf /etc/nginx/conf.d/default.conf


VOLUME ["/var/www/wordpress"]

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/start.sh"]
