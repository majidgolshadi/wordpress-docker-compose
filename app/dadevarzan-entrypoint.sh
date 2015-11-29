#!/bin/bash

source /entrypoint.sh

if [ ! -f /var/www/html/.dadevarzan_installed ]; then
    # Copy Avada theme files
    unzip -o ${DADEVARZAN_FILE_DIR}/zip/Avada.zip -d /var/www/html/wp-content/themes
    rm -f ${DADEVARZAN_FILE_DIR}/zip/Avada.zip

    # Add font files
    unzip -o ${DADEVARZAN_FILE_DIR}/zip/fonts.zip -d /var/www/html/wp-content/themes/Avada
    rm -f ${DADEVARZAN_FILE_DIR}/zip/fonts.zip

    # Installing Plugins
    for plugin in $(ls ${DADEVARZAN_FILE_DIR}/zip/)
    do
        unzip -o ${DADEVARZAN_FILE_DIR}/zip/${plugin} -d /var/www/html/wp-content/plugins/
    done

    # Customizing admin panel (for all users)
    mv ${DADEVARZAN_FILE_DIR}/asstes/admin_panel_base.css /var/www/html/wp-content/themes/Avada
    # Customizing admin panel(for admin-user role)
    mv ${DADEVARZAN_FILE_DIR}/asstes/admin_panel_user.css /var/www/html/wp-content/themes/Avada
    # Customizing 404 page
    rm /var/www/html/wp-content/themes/Avada/404.php
    mv ${DADEVARZAN_FILE_DIR}/404.php /var/www/html/wp-content/themes/Avada

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
    chown -R www-data:www-data /var/www/html/*
    chmod -f 644 /var/www/html/wp-content/themes/Avada/admin_panel_user.css
    chmod -f 644 /var/www/html/wp-content/themes/Avada/admin_panel_base.css

    rm -rf ${DADEVARZAN_FILE_DIR}
    rm -rf /var/www/html/wp-content/plugins/akismet
    rm /var/www/html/wp-content/plugins/hello.php
    rm -rf /var/www/html/wp-content/themes/{twentyfifteen,twentyfourteen,twentythirteen}

    touch /var/www/html/.dadevarzan_installed
fi

exec "$@"