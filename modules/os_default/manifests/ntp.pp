class os_default::ntp {
  package { 'ntp': ensure => absent }

  package { 'openntpd': ensure => installed, require => Package['ntp'] }

  file { '/etc/localtime':
    ensure  => link,
    require => Package['openntpd'],
    target  => '/usr/share/zoneinfo/Australia/Brisbane',
  }

  service { 'openntpd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/localtime'],
  }
}
