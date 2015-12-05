$mylocale = get_bloginfo('language');

if($mylocale == 'fa-IR')
{
    add_filter('date_i18n', 'ztjalali_ch_date_i18n', 111, 4);
}

function my_admin_theme_style_base() {
    wp_register_style('custom_wp_admin_css_base', get_template_directory_uri().'/admin_panel_base.css', false, '1.0.0');
    wp_enqueue_style('custom_wp_admin_css_base');
}

add_action( 'admin_enqueue_scripts', 'my_admin_theme_style_base' );
add_action('admin_head', 'my_custom_fonts');

function my_custom_fonts() { ?>
<style>
	<?php

        function get_user_role1() {
            global $current_user;
            $user_roles = $current_user->roles;
            $user_role = array_shift($user_roles);
            return $user_role;
        }

        if ( get_user_role1() == "site-admin" )
        {
            echo file_get_contents(get_template_directory_uri() . '/admin_panel_user.css');
        }
    ?>
</style>
<?php }
