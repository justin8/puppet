class xbmc( $user ) {
  $packages = [ 'ethtool', 'polkit', 'udisks', 'xbmc']
  package { $packages: ensure => installed }
  if $user == 'htpc' {
    $home_path = "/home/${user}"
  } elsif $user == 'xbmc' {
    $home_path = '/var/lib/xbmc'
  } else {
    $home = "home_${user}"
    $home_path = inline_template("<%= scope.lookupvar('::${home}') %>")
  }

  file {
    '/usr/share/xbmc/addons/skin.confluence/720p/IncludesHomeMenuItems.xml':
      ensure  => file,
      mode    => '0664',
      require => Package['xbmc'],
      source  => 'puppet:///modules/xbmc/IncludesHomeMenuItems.xml';

    "${home_path}/.xbmc":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'Thumbnails',
      owner   => $user,
      group   => $user,
      require => Package['xbmc'],
      source  => 'puppet:///modules/xbmc/shared-settings';

    "${home_path}/.xbmc/userdata/Thumbnails":
      ensure  => directory,
      owner   => $user,
      group   => $user,
      require => File["${home_path}/.xbmc"],
  }

  mount { "${home_path}/.xbmc/userdata/Thumbnails":
    ensure  => mounted,
    device  => '//abachi/XBMC-Thumbnails',
    fstype  => 'cifs',
    options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=${user},gid=${user}",
    atboot  => true,
    require => File["${home_path}/.xbmc/userdata/Thumbnails"],
  }

}
