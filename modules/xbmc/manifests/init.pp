class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'git', 'polkit', 'udisks', 'xbmc-git' ]
  $standalone_packages = [ 'slim' ]
  package { $packages: ensure => installed }
  if $standalone == 'true' {
    package { $standalone_packages: ensure => installed }
  }

  file { '/mnt/xbmctest':
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '775',
  }

  fstab { '/mnt/xbmc':
    source => '//abachi/XBMC',
    dest   => '/mnt/xbmctest',
    type   => 'cifs',
    opts   => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
    dump   => 0,
    passno => 0,
  }
}
