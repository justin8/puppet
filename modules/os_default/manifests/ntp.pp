class ntp {
  package { 'openntpd':
    ensure => installed,
  }
  file { 'localtime':
    path    => '/etc/localtime',
    ensure  => link,
    require => Package['openntpd'],
    target  => '/usr/share/zoneinfo/Australia/Brisbane',
  }
  service { 'openntpd':
    name      => openntpd,
    ensure    => running,
    enable    => true,
    subscribe => File['localtime'],
  }
}
