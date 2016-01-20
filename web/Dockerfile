FROM nginx:1.9

ENV WEB_DIR=/var/www
ENV WORDPRESS_DIR=/var/www/wordpress
ENV CUSTOM_FILE_DIR /tmp/dadevarzan

RUN \
    apt-get update && \
    apt-get install -y --force-yes \
                    curl unzip netcat mysql-client \
                    php5-fpm php5-cli php5-common php5-mcrypt php5-curl php5-intl php5-mysql php5-gd php-apc php5-memcache

RUN \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    apt-get install -y jq

RUN \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

RUN \
    sed -i -e "s/user  nginx/user  www-data/g" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf

RUN \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php5/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php5/fpm/pool.d/www.conf && \
    echo "php_value[memory_limit] = 32M" >> /etc/php5/fpm/pool.d/www.conf && \
    echo "php_admin_value[memory_limit] = 32M" >> /etc/php5/fpm/pool.d/www.conf


COPY nginx-fpm.conf /etc/nginx/conf.d/default.conf

COPY customize ${CUSTOM_FILE_DIR}
COPY entrypoint.sh /entrypoint.sh
COPY utils.sh /utils.sh
COPY start.sh /start.sh

VOLUME ["/var/www/wordpress"]

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/start.sh"]
