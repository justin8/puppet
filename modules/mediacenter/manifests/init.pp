class mediacenter( $type, $user, $cache=True ) {
  if $user == 'htpc' {
    $home_path = "/home/${user}"
  } elsif $user == 'xbmc' {
    $home_path = '/var/lib/xbmc'
  } else {
    $home = "home_${user}"
    $home_path = inline_template("<%= scope.lookupvar('::${home}') %>")
  }

  if $type == 'xbmc' {
    class { 'mediacenter::xbmc':
      user  => $user,
      cache => $cache,
      home_path => $home_path,
    }
  } elsif $type == 'xbmc-standalone' {
    class { 'mediacenter::xbmc':
      user  => $user,
      cache => $cache,
      home_path => $home_path,
    }

    class { 'mediacenter::standalone':
      type      => 'xbmc',
      user      => $user,
      home_path => $home_path,
    }    
  } elsif $type == 'plex' {
    class { 'mediacenter::plex':
      user => $user,
    }
  }
}
