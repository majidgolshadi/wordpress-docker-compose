if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

if ($_SERVER["HTTPS"]==='on') {
	$SITEURL = 'https://'.$_SERVER['HTTP_HOST'];
} else {
    $SITEURL = 'http://'.$_SERVER['HTTP_HOST'];
}

define('WP_SITEURL', $SITEURL);
define('WP_HOME', $SITEURL);

$plugins = get_option('active_plugins');

if (count($plugins ) === 0) {
  require_once(ABSPATH .'/wp-admin/includes/plugin.php');

  $pluginsToActivate = array(
      'nginx-helper/nginx-helper.php',
      'duplicate-post/duplicate-post.php',
      'user-role-editor/user-role-editor.php',
      'adminimize/adminimize.php',
      'stops-core-theme-and-plugin-updates/main.php',
      'wp-smushit/wp-smush.php',
      'all-in-one-wp-security-and-firewall/wp-security.php',
      'underconstruction/underConstruction.php',
      'contact-form-7/wp-contact-form-7.php',
      'legacy-admin/legacy-core.php',
      'wp-jalali/wp-jalali.php',
      'fusion-core/fusion-core.php',
      'revslider/revslider.php',
  );

  foreach ($pluginsToActivate as $plugin) {
    if (!in_array($plugin, $plugins)) {
        activate_plugin('/var/www/html/wp-content/plugins/'.$plugin);
    }
  }
}
