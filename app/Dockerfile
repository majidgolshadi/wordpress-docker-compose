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
ENV DADEVARZAN_FILE_DIR=/usr/src/dadevarzan
ADD ./files /usr/src/dadevarzan
RUN unzip -o $DADEVARZAN_FILE_DIR/zip/wordpress-4.3.1-fa_IR.zip -d /usr/src

# Download plugins
RUN curl -o $DADEVARZAN_FILE_DIR/zip/nginx-helper.zip -O `curl -i -s https://wordpress.org/plugins/nginx-helper/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/wordfence.zip -O `curl -i -s https://wordpress.org/plugins/wordfence/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/wordpress-seo.zip -O `curl -i -s https://wordpress.org/plugins/wordpress-seo/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/google-captcha.zip -O `curl -i -s https://wordpress.org/plugins/google-captcha/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/google-analytics-for-wordpress.zip -O `curl -i -s https://wordpress.org/plugins/google-analytics-for-wordpress/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/duplicate-post.zip -O `curl -i -s https://wordpress.org/plugins/duplicate-post/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/user-role-editor.zip -O `curl -i -s https://wordpress.org/plugins/user-role-editor/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/adminimize.zip -O `curl -i -s https://wordpress.org/plugins/adminimize/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/loco-translate.zip -O `curl -i -s https://wordpress.org/plugins/loco-translate/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/stops-core-theme-and-plugin-updates.zip -O `curl -i -s https://wordpress.org/plugins/stops-core-theme-and-plugin-updates/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/wp-smushit.zip -O `curl -i -s https://wordpress.org/plugins/wp-smushit/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/all-in-one-wp-security-and-firewall.zip -O `curl -i -s https://wordpress.org/plugins/all-in-one-wp-security-and-firewall/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/underconstruction.zip -O `curl -i -s https://wordpress.org/plugins/underconstruction/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/w3-total-cache.zip -O `curl -i -s https://wordpress.org/plugins/w3-total-cache/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $DADEVARZAN_FILE_DIR/zip/contact-form-7.zip -O `curl -i -s https://wordpress.org/plugins/contact-form-7/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`


COPY ./dadevarzan-entrypoint.sh /dadevarzan-entrypoint.sh

RUN sed -i '$ d' /entrypoint.sh

ENTRYPOINT ["bash", "/dadevarzan-entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 80 443
