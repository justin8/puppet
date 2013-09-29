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

  mount { '/mnt/xbmctest':
    device  => '//abachi/XBMC',
    fstype  => 'cifs',
    options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
    require => File['/mnt/xbmctest']
    ensure  => mounted,
    atboot  => true,
  }
}
