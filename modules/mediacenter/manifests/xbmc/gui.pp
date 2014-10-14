define mediacenter::xbmc::gui ( $value, $user, $home_path = undef ) {

  if $home_path == undef {
    if $user == 'htpc' {
      $real_home_path = "/home/${user}"
    } elsif $user == 'xbmc' {
      $real_home_path = '/var/lib/xbmc'
    } else {
      $home = "home_${user}"
      $real_home_path = inline_template("<%= scope.lookupvar('::${home}') %>")
    }
  } else {
    $real_home_path = $home_path
  }

  exec { "xbmc-gui-${title}":
    path    => '/usr/bin',
    unless  => "grep -qE '<(setting\ .*)?${title}(\ default.*)?\"?>${value}</' '${real_home_path}/.xbmc/userdata/guisettings.xml'",
    command => "sed -ri '/<(setting\ .*)?${title}(\ default.*)?\"?>/s/>.*<\//>${value}<\//' '${real_home_path}/.xbmc/userdata/guisettings.xml'",
  }

}
