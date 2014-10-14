define mediacenter::xbmc::gui ( $value, $user, $home_path = undef ) {

  if $home_path == undef {
    if $user == 'htpc' {
      $home_path = "/home/${user}"
    } elsif $user == 'xbmc' {
      $home_path = '/var/lib/xbmc'
    } else {
      $home = "home_${user}"
      $home_path = inline_template("<%= scope.lookupvar('::${home}') %>")
    }
  }

  exec { "xbmc-gui-${title}":
    path    => '/usr/bin',
    unless  => "grep -qE '<(setting\ .*)?${title}(\ default.*)?\"?>${value}</' '${home_path}/.xbmc/userdata/guisettings.xml'",
    command => "sed -ri '/<(setting\ .*)?${title}(\ default.*)?\"?>/s/>.*<\//>${value}<\//' '${home_path}/.xbmc/userdata/guisettings.xml'",
  }

}
