FROM alpine:3.2

ENV CUSTOM_FILE_DIR /tmp/dadevarzan

COPY customize ${CUSTOM_FILE_DIR}
COPY entrypoint.sh /entrypoint.sh
COPY utils.sh /utils.sh
COPY start.sh /start.sh

RUN \
    apk add --update curl nginx bash \
        php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
        php-pdo_mysql php-mysqli \
        php-gd php-iconv php-mcrypt \
        php-mysql php-curl php-opcache php-ctype php-apcu \
        php-intl php-bcmath php-dom php-xmlreader

RUN \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    apk add jq

RUN \
    rm -rf /var/cache/apk/*

COPY nginx-fpm.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf


VOLUME ["/var/www/wordpress"]

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/start.sh"]
