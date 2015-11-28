#!/bin/bash

source /entrypoint.sh

if [ ! -f /var/www/html/.dadevarzan_installed ]; then
    # Copy Avada theme files
    unzip -o /usr/src/dadevarzan/Avada.zip -d /var/www/html/wp-content/themes
    chown -R www-data:www-data /var/www/html/wp-content/themes/Avada

    # Installing Plugins
    for plugin in $(ls /usr/src/dadevarzan/*.zip)
    do
        unzip -o /usr/src/dadevarzan/$plugin -d /var/www/html/wp-content/plugins/
    done
    chown -R www-data:www-data /var/www/html/wp-content/plugins/*

    # Remove unused plugins
    rm -rf /var/www/html/wp-content/plugins/akismet
    rm /var/www/html/wp-content/plugins/hello.php

    # Remove unused theme
    rm -rf /var/www/html/wp-content/themes/{twentyfifteen, twentyfourteen, twentythirteen}

    # Add css file for customizing admin panel (for all users)
    mv /usr/src/dadevarzan/admin_panel_base.css /var/www/html/wp-content/themes/Avada
    chown -R www-data:www-data /var/www/html/wp-content/themes/Avada/admin_panel_base.css

    # Add css file for customizing admin panel(for admin-user role)
    mv /usr/src/dadevarzan/admin_panel_user.css /var/www/html/wp-content/themes/Avada
    chown -R www-data:www-data /var/www/html/wp-content/themes/Avada/admin_panel_user.css

    # Add font files
    unzip -o /usr/src/dadevarzan/fonts.zip -d /var/www/html/wp-content/themes/Avada
    chown -R www-data:www-data /var/www/html/wp-content/themes/Avada/fonts

    # New 404.php file
    rm /var/www/html/wp-content/themes/Avada/404.php
    mv /usr/src/dadevarzan/404.php /var/www/html/wp-content/themes/Avada
    chown -R www-data:www-data /var/www/html/wp-content/themes/Avada/404.php
    find /usr/src/dadevarzan/ -maxdepth 1 -type f -name '*.zip' -delete

  # Activate nginx plugin once logged in
  cat << ENDL >> /var/www/html/wp-config.php
if(\$_SERVER["HTTPS"]==='on')
{
	\$SITEURL = 'https://'.\$_SERVER['HTTP_HOST'];
}
else
{
	\$SITEURL = 'http://'.\$_SERVER['HTTP_HOST'];
}
define('WP_SITEURL', \$SITEURL);
define('WP_HOME', \$SITEURL);

\$plugins = get_option( 'active_plugins' );
if ( count( \$plugins ) === 0 ) {
  require_once(ABSPATH .'/wp-admin/includes/plugin.php');
  \$pluginsToActivate = array( 'nginx-helper/nginx-helper.php', 'duplicate-post/duplicate-post.php', 'user-role-editor/user-role-editor.php', 'adminimize/adminimize.php', 'stops-core-theme-and-plugin-updates/main.php', 'wp-smushit/wp-smush.php', 'all-in-one-wp-security-and-firewall/wp-security.php', 'underconstruction/underConstruction.php', 'contact-form-7/wp-contact-form-7.php', 'legacy-admin/legacy-core.php', 'wp-jalali/wp-jalali.php', 'fusion-core/fusion-core.php', 'revslider/revslider.php');
  foreach ( \$pluginsToActivate as \$plugin ) {
    if ( !in_array( \$plugin, \$plugins ) ) {
      activate_plugin( '/var/www/html/wp-content/plugins/' . \$plugin );
    }
  }
}
ENDL
chown www-data:www-data /var/www/html/wp-config.php

# Edit function.php
cat << ENDL >> /var/www/html/wp-content/themes/Avada/functions.php
\$mylocale = get_bloginfo('language');
if(\$mylocale == 'fa-IR')
{
add_filter('date_i18n', 'ztjalali_ch_date_i18n', 111, 4);
}

function my_admin_theme_style_base() {
wp_register_style( 'custom_wp_admin_css_base', get_template_directory_uri() . '/admin_panel_base.css', false, '1.0.0' );
wp_enqueue_style( 'custom_wp_admin_css_base' );
}
add_action( 'admin_enqueue_scripts', 'my_admin_theme_style_base' );


add_action('admin_head', 'my_custom_fonts');

function my_custom_fonts() { ?>
<style>
	<?php

        function get_user_role1() {
            global \$current_user;
            \$user_roles = \$current_user->roles;
            \$user_role = array_shift(\$user_roles);
            return \$user_role;

        }

        if ( get_user_role1() == "site-admin" )
        {
            echo file_get_contents(get_template_directory_uri() . '/admin_panel_user.css');
        }
    ?>

</style>
<?php }
ENDL
    chown www-data:www-data /var/www/html/wp-content/themes/Avada/admin_panel_user.css
    chmod -f 644 /var/www/html/wp-content/themes/Avada/admin_panel_user.css
    chown www-data:www-data /var/www/html/wp-content/themes/Avada/admin_panel_base.css
    chmod -f 644 /var/www/html/wp-content/themes/Avada/admin_panel_base.css

    touch /var/www/html/.dadevarzan_installed
fi

exec "$@"