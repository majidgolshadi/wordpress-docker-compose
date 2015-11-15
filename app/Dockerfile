FROM wordpress:4.3-fpm
MAINTAINER Ali Naghavi <naghavi.ali@gmail.com>

########################################
# PHP Extensions
########################################
RUN apt-get update && apt-get install -y curl unzip
#RUN /usr/local/bin/docker-php-ext-install curl gd intl imagick imap mcrypt memcache ming ps pspell recode tidy xmlrpc xsl
RUN apt-get update && apt-get install -y \
        curl \
        unzip \
        libmcrypt-dev \
    && docker-php-ext-install mcrypt gd

########################################
# php-fpm config
########################################
COPY ./php-fpm.ini ${PHP_INI_DIR}/conf.d/


########################################
# Wordpress Customizations
########################################

# Add dadevarzan-specific files
ADD ./files /usr/src/dadevarzan

# Replace original Wordpress with latest Persian version
RUN cd /usr/src && unzip -o /usr/src/dadevarzan/wordpress-4.3.1-fa_IR.zip

# Download plugins
  RUN curl -o /usr/src/dadevarzan/nginx-helper.zip -O `curl -i -s https://wordpress.org/plugins/nginx-helper/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/wordfence.zip -O `curl -i -s https://wordpress.org/plugins/wordfence/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/wordpress-seo.zip -O `curl -i -s https://wordpress.org/plugins/wordpress-seo/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/google-captcha.zip -O `curl -i -s https://wordpress.org/plugins/google-captcha/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/google-analytics-for-wordpress.zip -O `curl -i -s https://wordpress.org/plugins/google-analytics-for-wordpress/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/duplicate-post.zip -O `curl -i -s https://wordpress.org/plugins/duplicate-post/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/user-role-editor.zip -O `curl -i -s https://wordpress.org/plugins/user-role-editor/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/adminimize.zip -O `curl -i -s https://wordpress.org/plugins/adminimize/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/loco-translate.zip -O `curl -i -s https://wordpress.org/plugins/loco-translate/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/stops-core-theme-and-plugin-updates.zip -O `curl -i -s https://wordpress.org/plugins/stops-core-theme-and-plugin-updates/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/wp-smushit.zip -O `curl -i -s https://wordpress.org/plugins/wp-smushit/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/all-in-one-wp-security-and-firewall.zip -O `curl -i -s https://wordpress.org/plugins/all-in-one-wp-security-and-firewall/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/underconstruction.zip -O `curl -i -s https://wordpress.org/plugins/underconstruction/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/w3-total-cache.zip -O `curl -i -s https://wordpress.org/plugins/w3-total-cache/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/dadevarzan/contact-form-7.zip -O `curl -i -s https://wordpress.org/plugins/contact-form-7/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

########################################
# Entrypoint
########################################

# Dadevarzan entrypoint
RUN sed -i '$ d' /entrypoint.sh
COPY ./dadevarzan-entrypoint.sh /dadevarzan-entrypoint.sh
RUN chmod 0755 /dadevarzan-entrypoint.sh

ENTRYPOINT ["bash", "/dadevarzan-entrypoint.sh"]
CMD ["php-fpm"]

EXPOSE 80 443