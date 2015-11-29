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
ENV ZIP_FILE_DIR=/usr/src/dadevarzan/zip/
ADD ./files /usr/src/dadevarzan
RUN unzip -o $ZIP_FILE_DIR/wordpress-4.3.1-fa_IR.zip -d /usr/src

# Download plugins
RUN curl -o $ZIP_FILE_DIR/nginx-helper.zip -O `curl -i -s https://wordpress.org/plugins/nginx-helper/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/wordfence.zip -O `curl -i -s https://wordpress.org/plugins/wordfence/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/wordpress-seo.zip -O `curl -i -s https://wordpress.org/plugins/wordpress-seo/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/google-captcha.zip -O `curl -i -s https://wordpress.org/plugins/google-captcha/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/google-analytics-for-wordpress.zip -O `curl -i -s https://wordpress.org/plugins/google-analytics-for-wordpress/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/duplicate-post.zip -O `curl -i -s https://wordpress.org/plugins/duplicate-post/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/user-role-editor.zip -O `curl -i -s https://wordpress.org/plugins/user-role-editor/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/adminimize.zip -O `curl -i -s https://wordpress.org/plugins/adminimize/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/loco-translate.zip -O `curl -i -s https://wordpress.org/plugins/loco-translate/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/stops-core-theme-and-plugin-updates.zip -O `curl -i -s https://wordpress.org/plugins/stops-core-theme-and-plugin-updates/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/wp-smushit.zip -O `curl -i -s https://wordpress.org/plugins/wp-smushit/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/all-in-one-wp-security-and-firewall.zip -O `curl -i -s https://wordpress.org/plugins/all-in-one-wp-security-and-firewall/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/underconstruction.zip -O `curl -i -s https://wordpress.org/plugins/underconstruction/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/w3-total-cache.zip -O `curl -i -s https://wordpress.org/plugins/w3-total-cache/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`
RUN curl -o $ZIP_FILE_DIR/contact-form-7.zip -O `curl -i -s https://wordpress.org/plugins/contact-form-7/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`


COPY ./dadevarzan-entrypoint.sh /dadevarzan-entrypoint.sh

RUN sed -i '$ d' /entrypoint.sh

ENTRYPOINT ["bash", "/dadevarzan-entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 80 443
